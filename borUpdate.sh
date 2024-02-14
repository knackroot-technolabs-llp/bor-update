#!/bin/bash

# Local version
local_output=$(bor version)
local_version=$(echo "$local_output" | grep -oP 'Version: \K[^\s]+')
echo "Local version is: $local_version"

# GitHub API URL for the latest release
api_url="https://api.github.com/repos/maticnetwork/bor/releases/latest"

# Use curl to get the JSON response and jq to extract the version
git_version=$(curl -s "$api_url" | jq -r '.tag_name')
echo "Latest GitHub release version is: $git_version"

# Compare local and GitHub release versions
if [ "v$local_version" != "$git_version" ]; then
    echo "Versions mismatch. Deploying new version..."

    # Use curl to deploy the new version
    deploy_command="curl -L https://raw.githubusercontent.com/maticnetwork/install/main/bor.sh | bash -s $git_version mainnet sentry"
    eval "$deploy_command"

    # restart bor service
    service bor restart
else
    echo "Versions match. No deployment needed."
fi
