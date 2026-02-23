#!/usr/bin/env zsh
#
# Install or update plugins from plugins.lock
#
# Usage:
#   ./install-plugins.sh           # Install all at pinned commits
#   ./install-plugins.sh --update  # Pull latest and print new SHAs to update lockfile
#

set -e

LOCKFILE="$(dirname "$0")/plugins.lock"
UPDATE_MODE=false

[[ "$1" == "--update" ]] && UPDATE_MODE=true

while IFS=' ' read -r install_path repo_url commit_sha; do
  # Skip comments and blank lines
  [[ "$install_path" =~ ^#.*$ || -z "$install_path" ]] && continue

  # Expand ~
  install_path="${install_path/#\~/$HOME}"

  plugin_name="$(basename "$install_path")"

  if [[ -d "$install_path" ]]; then
    if $UPDATE_MODE; then
      echo "Updating $plugin_name..."
      git -C "$install_path" pull --quiet
      new_sha=$(git -C "$install_path" rev-parse HEAD)
      echo "  $plugin_name $new_sha"
    else
      # Already installed, checkout pinned commit
      echo "Pinning $plugin_name to $commit_sha"
      git -C "$install_path" fetch --quiet
      git -C "$install_path" checkout --quiet "$commit_sha"
    fi
  else
    echo "Installing $plugin_name..."
    git clone --quiet --recursive "$repo_url" "$install_path"
    if ! $UPDATE_MODE; then
      git -C "$install_path" checkout --quiet "$commit_sha"
      git -C "$install_path" submodule update --quiet --init --recursive
    fi
  fi
done < "$LOCKFILE"

echo "Done."
