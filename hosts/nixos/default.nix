# Desktop machine: AMD CPU, NVIDIA GPU, dual boot with Windows.
{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nvidia.nix
    ../../modules/gaming.nix
    ../../modules/dev-services.nix
    ../../modules/ai.nix
    ./windows-mounts.nix
  ];

  networking.hostName = "nixos";

  # nixos version DO NOT CHANGE (the version this machine was first installed with)
  system.stateVersion = "26.05";
}
