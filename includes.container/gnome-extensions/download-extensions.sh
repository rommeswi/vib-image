#!/bin/bash

# YAML file containing repositories and assets
YAML_FILE="extensions.yml"

# Check if yq is installed
if ! command -v yq &> /dev/null; then
    echo "Error: yq is not installed. Please install yq to parse the YAML file."
    exit 1
fi

# Parse the YAML file and loop through each repository and asset
repos=$(yq '.repositories' $YAML_FILE)

for i in $(seq 0 $(echo "$repos" | yq 'length-1')); do
    REPO=$(echo "$repos" | yq ".[$i].repo")
    ASSET_NAME=$(echo "$repos" | yq ".[$i].asset")
    
    echo "Processing $REPO for asset $ASSET_NAME..."

    # Fetch the latest release from the GitHub API
    API_URL="https://api.github.com/repos/$REPO/releases/latest"
    ASSET_URL=$(curl -s $API_URL | grep "browser_download_url" | grep "$ASSET_NAME" | cut -d '"' -f 4)

    # Check if we got the asset URL
    if [ -z "$ASSET_URL" ]; then
        echo "Error: Couldn't find the asset URL for $ASSET_NAME in $REPO."
        continue
    fi

    # Download the asset
    curl -L -o "$ASSET_NAME" "$ASSET_URL"

    # Verify if the file was downloaded
    if [ -f "$ASSET_NAME" ]; then
        echo "$ASSET_NAME downloaded successfully from $REPO."
    else
        echo "Error: Failed to download $ASSET_NAME from $REPO."
    fi
done
