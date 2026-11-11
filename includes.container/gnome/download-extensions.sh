#!/bin/bash
# Installs every extension listed in extensions.yml from its repository's latest
# GitHub release. Any failure stops the build: an extension that silently fails
# to install is absent from the image with nothing in the build to show it.
set -euo pipefail

YAML_FILE="/gnome/extensions.yml"
EXT_DIR="/usr/share/gnome-shell/extensions"

if [ ! -f "$YAML_FILE" ]; then
  echo "Error: Failed to find $YAML_FILE."
  exit 1
fi

if ! command -v yq &>/dev/null; then
  echo "Error: yq is not installed. Please install yq to parse the YAML file."
  exit 1
fi

echo "Processing Gnome Extensions in $YAML_FILE."
mkdir -p "$EXT_DIR"
WORK_DIR=$(mktemp -d)

count=$(yq '.repositories | length' "$YAML_FILE")
for i in $(seq 0 $((count - 1))); do
  REPO=$(yq -r ".repositories[$i].repo" "$YAML_FILE" | xargs)
  ASSET_NAME=$(yq -r ".repositories[$i].asset" "$YAML_FILE" | xargs)
  echo "Processing $REPO for asset $ASSET_NAME..."

  # Release asset URLs encode @ as %40.
  ENCODED_ASSET_NAME=${ASSET_NAME//@/%40}
  API_URL="https://api.github.com/repos/$REPO/releases/latest"
  ASSET_URL=$(curl -fsS "$API_URL" | jq -r --arg name "$ENCODED_ASSET_NAME" \
    '.assets[].browser_download_url | select(endswith("/" + $name))')
  if [ -z "$ASSET_URL" ]; then
    echo "Error: Couldn't find the asset $ASSET_NAME in the latest release of $REPO."
    exit 1
  fi
  echo "Downloading $ASSET_URL."

  ZIP="$WORK_DIR/$ASSET_NAME"
  UNPACK="$WORK_DIR/unpacked"
  curl -fsSL -o "$ZIP" "$ASSET_URL"
  unzip -q "$ZIP" -d "$UNPACK"
  ASSET_UUID=$(jq -r '.uuid' "$UNPACK/metadata.json")
  if [ -z "$ASSET_UUID" ] || [ "$ASSET_UUID" = "null" ]; then
    echo "Error: $ASSET_NAME has no uuid in metadata.json."
    exit 1
  fi
  rm -rf "${EXT_DIR:?}/$ASSET_UUID"
  mv "$UNPACK" "$EXT_DIR/$ASSET_UUID"

  if [ -d "$EXT_DIR/$ASSET_UUID/schemas" ]; then
    glib-compile-schemas "$EXT_DIR/$ASSET_UUID/schemas"
  fi
  echo "Installed $ASSET_UUID."
done

rm -rf "$WORK_DIR"
