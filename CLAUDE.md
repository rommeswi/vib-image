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

## Modifying the Image

- To add APT packages to the base image: add them to the `lab-packages` module in `recipe.yml` or create a new module.
- To add dotfiles/configs: place them under `includes.container/` at the target path.
- To add a new feature module: create `modules/<name>/install.yml` + `config.yml`, then reference them in `recipe.yml`.
- To install `.deb` files directly: place them in `includes.container/deb-pkgs/`.
- NVIDIA drivers: change `desktop:main` to `nvidia:main` in `recipe.yml` line 5.
