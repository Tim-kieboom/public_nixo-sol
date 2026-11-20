#!/usr/bin/env bash
set -euo pipefail

# ─── Config ───────────────────────────────────────────────────────
DAYS=7          # Keep Home Manager / user generations from the last N days
KEEP_SYSTEM=5   # Keep the last N system generations
DRY_RUN=false   # Set to true to preview without deleting

run() {
  if [[ "$DRY_RUN" == true ]]; then
    echo "[dry-run] $*"
  else
    "$@"
  fi
}

echo "=== NixOS Cleanup ==="
echo "Keep: last ${KEEP_SYSTEM} system gens, ${DAYS}d user/home-manager gens"
echo ""

# System generations (keep the last N)
echo "System generations (keeping last ${KEEP_SYSTEM})..."
sudo nix-env -p /nix/var/nix/profiles/system --list-generations
run sudo nix-env -p /nix/var/nix/profiles/system --delete-generations "+${KEEP_SYSTEM}"

# User profile generations (runs as your user, so it does NOT touch the system profile)
echo "User profile generations (older than ${DAYS}d)..."
run nix-collect-garbage --delete-older-than "${DAYS}d"

# Home Manager generations
if command -v home-manager &>/dev/null; then
  echo "Home Manager generations (older than ${DAYS}d)..."
  run home-manager expire-generations "-${DAYS} days"
fi

# Garbage collect the store (NO -d, so remaining generations are preserved)
echo "Garbage collecting store..."
run sudo nix-collect-garbage

# Deduplicate identical files
echo "Optimizing store (hardlink duplicates)..."
run sudo nix-store --optimise

# Refresh bootloader entries so they match the remaining generations
echo "Updating bootloader entries..."
if [[ "$DRY_RUN" == false ]]; then
  sudo nixos-rebuild boot 2>/dev/null || \
    sudo /run/current-system/bin/switch-to-configuration boot 2>/dev/null || \
    echo "  (skipped – no rebuild target found)"
fi

echo ""
echo "System generations remaining:"
sudo nix-env -p /nix/var/nix/profiles/system --list-generations

echo "Cleanup Done"