#!/bin/bash

# YAML file containing repositories and assets
YAML_FILE="/gnome/extensions.yml"

# Check if file exists.
if [ -f "$YAML_FILE" ]; then
  echo "Processing Gnome Extensions in $YAML_FILE."
else
  echo "Error: Failed to find $YAML_FILE."
  exit 1
fi

# Check if yq is installed
if ! command -v yq &>/dev/null; then
  echo "Error: yq is not installed. Please install yq to parse the YAML file."
  exit 1
fi

# Parse the YAML file and loop through each repository and asset
repos=$(yq '.repositories' $YAML_FILE)

mkdir -p /usr/share/gnome-shell/extensions

for i in $(seq 0 $(echo "$repos" | yq 'length-1')); do
  REPO=$(echo "$repos" | yq -r ".[$i].repo")
  ASSET_NAME=$(echo "$repos" | yq -r ".[$i].asset")

  # Make extensions directory

  echo "Processing $REPO for asset $ASSET_NAME..."

  # Encode the @ symbol in the asset name to match URL encoding
  ENCODED_ASSET_NAME=$(echo "$ASSET_NAME" | sed 's/@/%40/g')

  echo "Converted asset name to $ENCODED_ASSET_NAME."

  # Fetch the latest release from the GitHub API
  API_URL="https://api.github.com/repos/$REPO/releases/latest"
  echo "Fetching asset url from $API_URL..."

  ASSET_URL=$(curl -s $API_URL | grep "browser_download_url" | grep "$ENCODED_ASSET_NAME" | grep -v ".asc" | cut -d '"' -f 4)
  echo "Obtained asset url $ASSET_URL."

  # Check if we got the asset URL
  if [ -z "$ASSET_URL" ]; then
    echo "Error: Couldn't find the asset URL for $ASSET_NAME in $REPO."
    continue
  fi

  # Download the asset
  curl -L -o "$ASSET_NAME" "$ASSET_URL"

  # Verify if the file was downloaded
  if [ -f "$ASSET_NAME" ]; then
    echo "$ASSET_NAME downloaded successfully from $REPO, installing."
    mkdir -p /usr/share/gnome-shell/extensions/tmp
    unzip "$ASSET_NAME" -d /usr/share/gnome-shell/extensions/tmp
    ASSET_UUID=$(jq -r '.uuid' /usr/share/gnome-shell/extensions/tmp/metadata.json)
    mv /usr/share/gnome-shell/extensions/tmp "/usr/share/gnome-shell/extensions/$ASSET_UUID"
    rm "$ASSET_NAME"
    cd "/usr/share/gnome-shell/extensions/$ASSET_UUID/schemas"
    glib-compile-schemas .
    if [ -f "gschemas.compiled"]; then
      echo "Extension $ASSET_NAME successfully installed."
    else
      echo "Error installing $ASSET_NAME."
    fi
  else
    echo "Error: Failed to download $ASSET_NAME from $REPO."
  fi
done
