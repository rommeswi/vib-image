# Vanilla Science Image

This repository builds a custom [Vib image](https://github.com/Vanilla-OS/Vib) on top of the [official Vanilla OS image](https://images.vanillaos.org) like [desktop image](https://github.com/Vanilla-OS/desktop-image).
The goal of the image is to provide an easy starting point for doing data-driven scientific work. It comes with Emacs and Neovim as editors, python, a selection of useful tools along with a Tokyo night Gnome theme.

## Use the custom image

If you already have Vanilla OS installed, just point ABRoot to the custom image to use it:

- Edit the configuration file with the command: `abroot config-editor`.
- Examine the "Packages" section of this repository. It lists a `docker pull` command of the form `docker pull ghcr.io/USERNAME/NAMESPACE:TAG`.
- Change the "name" entry from something like `vanilla-os/desktop` to `USERNAME/NAMESPACE`.  [**Note**: All characters must be in lowercase.]
- Change the "tag" entry to `TAG`.
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

## Creating a Labstick USB

This section walks you through installing Vanilla OS on a fast USB stick and
then switching it to the Labstick image. You will need two USB sticks:

- **Installation stick** — any stick you have lying around, at least 8 GB.
  Speed does not matter; it is only used once.
- **Target stick** — the stick you will actually use day-to-day. At least
  128 GB, and as fast as possible (USB 3.1 Gen 2 or better).

### Step 1 — Prepare the installation stick with Ventoy

[Ventoy](https://www.ventoy.net) turns a USB stick into a bootable menu that
can hold multiple ISO files. Install it once on your installation stick; after
that you can simply copy ISOs onto it without reflashing.

1. Download the latest Ventoy release for your operating system from
   [ventoy.net/en/download.html](https://www.ventoy.net/en/download.html).
2. Unpack the archive and run `VentoyGUI` (Linux/macOS) or `Ventoy2Disk.exe`
   (Windows). Select your installation stick and click **Install**.
3. Download the latest Vanilla OS ISO from
   [images.vanillaos.org](https://images.vanillaos.org). Copy the `.iso` file
   onto the Ventoy partition that now appears on your installation stick.

### Step 2 — Install Vanilla OS onto the target stick

Plug both sticks into the computer you will use for installation. Boot from the
installation stick (press the key your machine uses to open the boot menu —
usually F11, F12, Esc, or Del — and select the Ventoy stick). In the Ventoy
menu, select the Vanilla OS ISO and choose **Try Vanilla OS** to load the live
desktop without touching any disks yet.

Once the desktop has loaded, open the installer. When it asks where to install,
choose **Manual partitioning** and select your target stick as the destination
disk. Create the following partitions in order:

| Size | Filesystem | Role |
|------|-----------|------|
| 1 GB | ext4 | Boot (`vos-boot`) |
| 1 GB | FAT32, mark as EFI System Partition | EFI (`vos-efi`) |
| 40 GB | Leave unformatted (LVM, managed by the installer) | Root |
| Remaining space | ext4 | Data (`vos-var`) |

> [!IMPORTANT]
> Do not use automatic partitioning. The automatic layout only assigns 20 GB
> to the root partition, which is not enough once you switch to the Labstick
> image. 40 GB is the recommended minimum.

Proceed through the rest of the installer with the standard options (no custom
image needed at this point — you will switch to the Labstick image after first
boot). When the installer finishes, **do not reboot yet**.

### Step 3 — Fix UEFI boot so the stick works on any machine

Without this step, the stick may fail to appear as a boot option on machines
other than the one it was installed on. While you are still in the live desktop
(before rebooting), open the **Files** application and find the small partition
labelled `vos-efi` on your target stick. Open it, then:

1. Navigate into the `EFI` folder and create a new folder called `BOOT` inside
   of it.
2. Navigate into the `vanilla` folder next to `BOOT`.
3. Copy `shimx64.efi` into `BOOT` and rename the copy to `BOOTX64.EFI`.
4. Copy `grubx64.efi` into `BOOT`, keeping the same name.
5. Copy `grub.cfg` into `BOOT`, keeping the same name.

Afterwards the `EFI` folder should contain both a `vanilla` folder (untouched)
and a new `BOOT` folder with those three files in it.

If you are comfortable with the terminal, open a terminal from the Activities
menu and run the script from this repository instead:

```bash
sudo scripts/fix-uefi-fallback.sh /dev/sdX   # replace sdX with your target stick's device name
```

### Step 4 — Boot the target stick and switch to the Labstick image

Shut the computer down, remove the installation stick, and start the computer
again. It should now boot from the target stick into Vanilla OS. Complete the
first-run setup.

Once at the desktop, open a terminal and switch the system to the Labstick
image by editing the ABRoot configuration:

```bash
pkexec abroot config-editor
```

Change the `name` field to `rommeswi/labstick` and the `tag` field to `main`,
then save and close the editor. Run:

```bash
abroot upgrade
```

After the upgrade completes, reboot. The stick is now running the Labstick
image.

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
