#!/usr/bin/env bash
# usage: ./rebuild.sh [host]   (default: this machine's hostname)
set -e

host="${1:-$(hostname)}"
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "NixOS Rebuilding $host ..."
sudo nixos-rebuild switch --flake "path:$dir#$host"

echo "Rebuild successful!"
