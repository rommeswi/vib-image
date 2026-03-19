# Vanilla Science Image

This repository builds a custom [Vib image](https://github.com/Vanilla-OS/Vib) on top of the [official Vanilla OS image](https://images.vanillaos.org) like [desktop image](https://github.com/Vanilla-OS/desktop-image).
The goal of the image is to provide an easy starting point for doing data-driven scientific work. It comes with Emacs and Neovim as editors, python, a selection of useful tools along with a Tokyo night Gnome theme.

## Use the custom image

If you already have Vanilla OS installed, just point ABRoot to the custom image to use it:

- Edit the configuration file with the command: `abroot config-editor`.
- Change the "name" entry from something like `vanilla-os/desktop` to `rommeswi/vib-image`.  [**Note**: All characters must be in lowercase.]
- Now, Run `abroot upgrade` to switch to the custom image.
- You may want to create a new user account to make use of the heavy customization of the user environment.

If you are installing Vanilla OS, select the installation option to use a custom image and supply the image data in the dialogue.

## Modifying the Image

> [!NOTE]
> If you want to use NVIDIA drivers, you need to change the base image in the recipe.yml from desktop:main to nvidia:main.

- Go to **Settings → Actions → General** and ensure "_Allow all actions and reusable workflows_" are enabled.
- Open the `vib-build.yml` workflow file and replace the custom image name with an image name of your choosing in line 14.
- Open the `recipe.yml` file and replace the image name and ID with your image name and ID in lines 1 and 2.
- Now, perform your additions and modifications to the recipe as per your requirements.
- If you just want to install `.deb` files, you can just put them in `includes.container/deb-pkgs`
- Optionally, add your modules to the `modules` directory and add them to the package-modules `includes` in `recipe.yml`.
- You can check the Actions tab in GitHub to see the build progress of your image.

> [!TIP]
> The [Vib documentation](https://docs.vanillaos.org/collections/vib) has more information about recipe format, structure of modules and the supported fields.

## Explore

Now, that you are aware of the basics, let's explore the files and directories present in this repository:

- `.github/workflows/vib-build.yml`: This file contains the GitHub Actions workflow to check for updates to the base image and build the Vib image on push and pull requests.
  - It uses the [`vib-gh-action`](https://github.com/Vanilla-OS/vib-gh-action) to build the recipe and upload it as an artifact. The generated artifact is then built using Docker's actions and pushed to GHCR (**Note**: The image with the respective branch tags is published to GHCR only on push actions to the branches in your repository or on tags and not on pull requests).
  - The action runs automatically on a schedule checking updates to the base image using [Differ](https://github.com/Vanilla-OS/Differ).
- `.github/workflows/release.yml`: This file contains the GitHub Actions workflow to automatically create a GitHub release when a tag is created and it uploads the generated Containerfile to the release for future reference.
- `.github/dependabot.yml`: This file contains the configuration for GitHub's Dependabot to check for updates to the GitHub actions used in the workflow files monthly and when it finds a new version it creates a PR in your repository.
- `includes.container`: The files included in this directory are added by default to your image to the specified location (**Note**: It also contains ABRoot's configuration file).
- `modules`: This directory contains the modules that are used to customize the image. You can add your modules to this directory.
- `recipe.yml`: This file contains the recipe for the image. It specifies the base image, modules and other fields to be present in the custom image.
