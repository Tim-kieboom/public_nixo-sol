#!/usr/bin/env bash
# Usage: ./update.sh [flake-input]
# Example: ./update.sh my-host nixpkgs
set -e

input="${1:-}"

echo "Updating Nix flake inputs..."
if [[ -n "$input" ]]; then
  sudo nix flake update "$input"
else
  sudo nix flake update
fi

./rebuild.sh 