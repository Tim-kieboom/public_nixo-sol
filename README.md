# NixOS configuration

Flake-based NixOS + home-manager setup (Hyprland, [sol-shell](https://github.com/Tim-kieboom/sol-shell), Zen browser).

## Layout

| Path | Purpose |
| --- | --- |
| `flake.nix` | inputs and `mkHost`, one `nixosConfigurations.<host>` per machine |
| `vars.nix` | username, name, git email, uid (edit when forking) |
| `modules/common.nix` | desktop, audio, locale, packages every machine gets |
| `modules/{nvidia,gaming,dev-services,ai}.nix` | optional features a host imports |
| `hosts/<host>/` | per-machine: hardware, hostname, stateVersion, drives, `monitors.lua` |
| `home/` | home-manager config (`default.nix`), Hyprland config, fastfetch logo |

## Use on a new computer

1. Install NixOS, then clone this repo (e.g. to `/etc/nixos` or `~/nixos`).
2. `cp -r hosts/nixos hosts/<newhost>` and in it:
   - regenerate hardware: `nixos-generate-config --show-hardware-config > hosts/<newhost>/hardware-configuration.nix`
   - edit `default.nix`: hostname, `system.stateVersion` (the version you installed), and drop modules the machine does not need (e.g. `nvidia.nix`, `ollama`)
   - delete or replace `windows-mounts.nix`
   - set your outputs in `monitors.lua` (`hyprctl monitors`)
3. Add `<newhost> = mkHost "<newhost>";` to `flake.nix` and `git add` the new files (flakes ignore untracked files).
4. Edit `vars.nix`, then `./rebuild.sh <newhost>`.
5. Set the user password once with `passwd`.

Note: `services.displayManager.autoLogin` is on in `modules/common.nix`; disable it on laptops/shared machines.
