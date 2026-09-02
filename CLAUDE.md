# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a custom [Vib (Vanilla Image Builder)](https://github.com/Vanilla-OS/Vib) image for Vanilla OS, optimized for data-driven scientific work. The build process is entirely CI-driven via GitHub Actions — there are no local build commands.

## Build Process

There is no Makefile or local build tooling. The image is built by:

1. **GitHub Actions** (`.github/workflows/vib-build.yml`): Triggered on push to main, tags, PRs, or daily schedule. It checks if the base image digest has changed, then uses `vib-gh-action` to convert `recipe.yml` into a `Containerfile`, and builds/pushes the Docker image to GHCR (`ghcr.io/<owner>/vib-image`).
2. **Release** (`.github/workflows/release.yml`): On tag creation, builds and attaches the generated `Containerfile` to a GitHub release.

To trigger a build manually: use the "Run workflow" button in GitHub Actions (this sets `has_updates=true` regardless of digest changes).

## Repository Structure

- **`recipe.yml`** — The single source of truth for the image. Defines base image, build stages, and which modules to include. New modules are added here.
- **`modules/`** — Feature modules, each with `install.yml` (packages/commands) and `config.yml` (shell commands for post-install setup). Modules are composed into the recipe via `type: includes`.
- **`includes.container/`** — Files copied verbatim into the image at their specified paths (e.g., dotfiles, configs, scripts).

## Module Pattern

Each module follows this convention:

- `modules/<name>/install.yml` — `type: apt` or `type: shell` module with packages/install commands
- `modules/<name>/config.yml` — `type: shell` module with configuration commands run inside the container

Modules are wired into `recipe.yml` under `type: includes` entries. New custom modules should be added between the two comment markers in `recipe.yml` (`# Put your custom actions behind/before this comment`).

## Key Architecture Points

- **Base image**: `ghcr.io/vanilla-os/desktop:main` (swap to `nvidia:main` for NVIDIA GPU support)
- **lpkg lock/unlock**: The `init-setup` module unlocks `lpkg` (Vanilla OS's package manager guard) before apt operations; `cleanup` re-locks it. All apt installs must happen between these.
- **fsguard**: The `fsguard` module at the end generates a filesystem integrity key for `/usr/bin`. This is always the second-to-last step.
- **`includes.container/usr/share/abroot/`**: Contains the ABRoot configuration — this controls what image URL Vanilla OS will pull during `abroot upgrade`.
- **`includes.container/vanilla-first-setup/`**: Controls the first-run setup wizard shown to new users.

## Live System Constraints

The deployed Vanilla OS instance running this repository is **immutable** (managed by ABRoot). The root filesystem is read-only on the live system. Do not attempt to directly modify files under `/usr`, `/etc`, or other system paths on the running OS — those operations will fail or have no lasting effect. All changes must go through the vib image repository and take effect after the next image build and `abroot upgrade`.

## Modifying the Image

- To add APT packages to the base image: add them to the `lab-packages` module in `recipe.yml` or create a new module.
- To add dotfiles/configs: place them under `includes.container/` at the target path.
- To add a new feature module: create `modules/<name>/install.yml` + `config.yml`, then reference them in `recipe.yml`.
- To install `.deb` files directly: place them in `includes.container/deb-pkgs/`.
- NVIDIA drivers: change `desktop:main` to `nvidia:main` in `recipe.yml` line 5.

## Pinned Third-Party Sources

`modules/abc/install.yml` installs [alestic/abc](https://github.com/alestic/abc) from a
pinned commit (`ABC_REF`). The project publishes no releases, tags, or PyPI package, so the
pin is the only thing keeping image contents reproducible. Never change `ABC_REF` to a branch
name, and never leave it unpinned.

When asked to check for updates — and proactively whenever working in this repository after a
gap of a month or more — do the following:

1. `git ls-remote https://github.com/alestic/abc.git HEAD` and compare against `ABC_REF`.
2. If it moved, review the actual diff before bumping:
   `git clone` the repo and `git log --oneline <ABC_REF>..HEAD`, then
   `git diff <ABC_REF>..HEAD` over `abc_cli/` and `abc_provider_anthropic/`.
3. Run a safety check on the new code and report findings before changing the pin. Look for:
   - new `subprocess`, `os.system`, `eval`, or `exec` calls in the Python (there are none at
     the pinned commit; any addition is worth explaining)
   - changes to `abc_cli/abc.sh`, which runs inside the user's interactive shell and ends in
     `eval "$user_cmd"` — in particular anything that shortens the path between LLM output and
     that `eval`, or that removes the typeahead flush guarding it
   - changes to `process_generated_command` in `abc_generate.py`, which neutralizes
     high-danger commands by commenting them out
   - new network egress beyond the configured LLM provider's own API, and any telemetry
   - anything reading `~/.config/abc/config`, which holds an API key in plaintext, or
     weakening its mode 600
4. Only bump `ABC_REF` after reporting what changed. If the diff contains anything from the
   list above, say so and let the user decide rather than bumping.

`modules/paperwm/install.yml` installs [paperwm/PaperWM](https://github.com/paperwm/PaperWM)
the same way, from a pinned commit (`PAPERWM_REF`). The project tags releases but attaches
no artifacts to them, so a clone is the only route. Check for updates and review the diff
before bumping, as above; PaperWM hooks deeply into window management, so pay attention to
changes in keybinding registration and in what it does to `enabled-extensions`.

Apply the same discipline to any other module installing from a VCS ref rather than a
versioned artifact.

## GNOME Extensions

Extensions live in three places and all three must agree:

- installed into `/usr/share/gnome-shell/extensions/` — from the `gnome-shell-extensions`
  deb, from `includes.container/gnome/extensions.yml` (GitHub release assets), or from a
  module like `modules/paperwm/install.yml`
- switched on in `enabled-extensions` in `includes.container/etc/dconf/db/local.d/00-lab-defaults`
- compatible with the GNOME Shell the base image ships

`modules/checks/extensions.yml` enforces the last two at build time. It runs
`includes.container/vib-checks/check-extensions.py` after every module that installs an
extension, and fails the build if any installed extension does not declare support for this
GNOME Shell, or if `enabled-extensions` names a UUID that ships no files. Vib joins every
recipe command with `&&`, so a non-zero exit stops the build and nothing is pushed.

This exists because both failures happen without anyone editing this repository: the base
image moves to a new GNOME Shell and strands every extension that has not been updated. When
the build fails that way, update the extension, drop it from the image, or -- if shipping it
broken is a deliberate choice -- add its UUID to `ALLOW_INCOMPATIBLE` in the script with a
reason.

Installing an extension does not enable it. Anything absent from `enabled-extensions` ships
dormant, which is how PaperWM is set up. When removing an extension, remove it from both the
filesystem and that list; the check catches the half-done case.
