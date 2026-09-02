#!/usr/bin/env python3
"""Fail the build if the image would ship a GNOME extension it cannot run.

Two things go wrong on their own, without anyone touching this repository:

  * The base image moves to a new GNOME Shell. Every extension whose
    metadata.json does not list the new version is dead on arrival -- GNOME
    refuses to load it, and the user finds out after `abroot upgrade`.
  * An extension is dropped from the image but left in enabled-extensions, so
    GNOME is told to enable something that is not there.

Both are silent at build time, which is why this runs as a recipe module: Vib
joins every command with `&&`, so a non-zero exit here fails the build and
nothing is pushed.

Add a UUID to ALLOW_INCOMPATIBLE only with a reason, and only when shipping the
extension anyway is a deliberate decision.
"""

import json
import pathlib
import re
import subprocess
import sys

EXTENSION_DIRS = [
    pathlib.Path("/usr/share/gnome-shell/extensions"),
    pathlib.Path("/usr/local/share/gnome-shell/extensions"),
]
DCONF_DEFAULTS = pathlib.Path("/etc/dconf/db/local.d/00-lab-defaults")

ALLOW_INCOMPATIBLE: dict[str, str] = {}


def shell_major() -> str:
    """Major version of the GNOME Shell in this image, e.g. '49'."""
    out = subprocess.run(
        ["gnome-shell", "--version"], capture_output=True, text=True, check=True
    ).stdout
    match = re.search(r"(\d+)", out)
    if not match:
        sys.exit(f"could not read a version out of `gnome-shell --version`: {out!r}")
    return match.group(1)


def installed() -> dict[str, dict]:
    """uuid -> parsed metadata.json, for every extension in the image."""
    found = {}
    for root in EXTENSION_DIRS:
        for meta in sorted(root.glob("*/metadata.json")):
            try:
                data = json.loads(meta.read_text())
            except (OSError, ValueError) as exc:
                sys.exit(f"{meta}: unreadable metadata.json ({exc})")
            found[data.get("uuid", meta.parent.name)] = data
    return found


def enabled() -> list[str]:
    """UUIDs the dconf defaults switch on. Empty if the file is absent."""
    if not DCONF_DEFAULTS.exists():
        return []
    for line in DCONF_DEFAULTS.read_text().splitlines():
        if line.startswith("enabled-extensions="):
            return re.findall(r"'([^']+)'", line)
    return []


def supports(metadata: dict, major: str) -> bool:
    """GNOME matches on the major version, or on an exact major.minor entry."""
    return any(
        str(v) == major or str(v).startswith(f"{major}.")
        for v in metadata.get("shell-version", [])
    )


def main() -> int:
    major = shell_major()
    present = installed()
    turned_on = enabled()
    problems = []

    print(f"GNOME Shell {major}; {len(present)} extensions installed, "
          f"{len(turned_on)} enabled by default\n")

    for uuid, metadata in sorted(present.items()):
        versions = ",".join(str(v) for v in metadata.get("shell-version", [])) or "none"
        on = "enabled" if uuid in turned_on else "installed"
        if supports(metadata, major):
            print(f"  ok        {uuid}  [{versions}]  {on}")
        elif uuid in ALLOW_INCOMPATIBLE:
            print(f"  allowed   {uuid}  [{versions}]  {ALLOW_INCOMPATIBLE[uuid]}")
        else:
            print(f"  BROKEN    {uuid}  [{versions}]  {on}")
            problems.append(
                f"{uuid} does not support GNOME {major} (declares: {versions})"
            )

    for uuid in turned_on:
        if uuid not in present:
            print(f"  MISSING   {uuid}  enabled but not installed")
            problems.append(f"{uuid} is in enabled-extensions but ships no files")

    if problems:
        print("\nExtension check failed:")
        for problem in problems:
            print(f"  - {problem}")
        print(
            "\nFix by updating the extension, dropping it from the image, or -- if "
            "shipping it broken is deliberate -- adding it to ALLOW_INCOMPATIBLE "
            "in this script with a reason."
        )
        return 1

    print("\nAll shipped extensions support this GNOME Shell.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
