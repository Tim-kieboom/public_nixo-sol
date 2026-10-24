#!/usr/bin/env bash
# Usage: ./update.sh [host] [flake-input]
# Example: ./update.sh my-host nixpkgs
set -e

host="${1:-$(hostname)}"
input="${2:-}"

echo "Updating Nix flake inputs..."
if [[ -n "$input" ]]; then
  sudo nix flake update "$input"
else
  sudo nix flake update
fi

./rebuild.sh "$host"