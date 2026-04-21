#!/usr/bin/env bash
# fix-uefi-fallback.sh — Add the UEFI fallback bootloader to a Vanilla OS USB stick
#
# A fresh Vanilla OS installation only places bootloader files under
# EFI/vanilla/ on the ESP. Many UEFI firmwares (especially on older or
# budget hardware) will not find this entry when the stick is plugged into
# an unfamiliar machine, because they only look for the fallback path
# EFI/BOOT/BOOTX64.EFI. This script creates that fallback by copying the
# existing shim and GRUB files already present on the stick.
#
# Usage (as root):
#   ./fix-uefi-fallback.sh /dev/sdX
#
# where /dev/sdX is the USB stick device (NOT a partition).

set -euo pipefail

die() { echo "Error: $*" >&2; exit 1; }

# ── argument check ────────────────────────────────────────────────────────────
[[ $# -eq 1 ]] || die "Usage: $0 /dev/sdX"
DEVICE="$1"
[[ -b "$DEVICE" ]] || die "$DEVICE is not a block device"

# ── find the ESP partition ────────────────────────────────────────────────────
ESP_PART=$(lsblk -lno NAME,PARTTYPE "$DEVICE" \
    | awk 'tolower($2) == "c12a7328-f81f-11d2-ba4b-00a0c93ec93b" {print "/dev/"$1}' \
    | head -1)

if [[ -z "$ESP_PART" ]]; then
    # Fall back to looking for the esp flag via parted
    ESP_PART=$(parted -ms "$DEVICE" print \
        | awk -F: '/esp/ {print "'$DEVICE'" $1}' \
        | head -1)
fi

[[ -n "$ESP_PART" ]] || die "Could not find an EFI System Partition on $DEVICE"
echo "ESP partition: $ESP_PART"

# ── mount the ESP ─────────────────────────────────────────────────────────────
MOUNTPOINT=$(mktemp -d)
trap 'umount "$MOUNTPOINT" 2>/dev/null; rmdir "$MOUNTPOINT"' EXIT

mount "$ESP_PART" "$MOUNTPOINT"

# ── locate source files ───────────────────────────────────────────────────────
SRC_DIR=""
for candidate in "$MOUNTPOINT"/EFI/*/shimx64.efi; do
    [[ -f "$candidate" ]] && SRC_DIR="$(dirname "$candidate")" && break
done

[[ -n "$SRC_DIR" ]] || die "Could not find shimx64.efi under EFI/ on $ESP_PART — is this a Vanilla OS stick?"

echo "Source EFI directory: $SRC_DIR"

# ── check if fallback already exists ─────────────────────────────────────────
BOOT_DIR="$MOUNTPOINT/EFI/BOOT"
if [[ -f "$BOOT_DIR/BOOTX64.EFI" ]]; then
    echo "EFI/BOOT/BOOTX64.EFI already exists — nothing to do."
    exit 0
fi

# ── create fallback directory and copy files ──────────────────────────────────
mkdir -p "$BOOT_DIR"

cp "$SRC_DIR/shimx64.efi"  "$BOOT_DIR/BOOTX64.EFI"
cp "$SRC_DIR/grubx64.efi"  "$BOOT_DIR/grubx64.efi"
cp "$SRC_DIR/grub.cfg"     "$BOOT_DIR/grub.cfg"

echo "Created fallback bootloader:"
ls -lh "$BOOT_DIR"
echo
echo "Done. The stick should now boot on machines that only look for EFI/BOOT/BOOTX64.EFI."
