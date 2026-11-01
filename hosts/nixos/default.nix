# Desktop machine: AMD CPU, NVIDIA GPU, dual boot with Windows.
{ lib, vars, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nvidia.nix
    ../../modules/gaming.nix
    ../../modules/dev-services.nix
    ../../modules/ai.nix
    ./windows-mounts.nix
  ];

# -- Boot -- 
  # max number of configs displayed in systemd-boot menu
  boot.loader.systemd-boot.configurationLimit = 10;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    useOSProber = true;   # finds Windows
  };
  
  boot.loader.efi.canTouchEfiVariables = true;

  # dont require to relogin every reboot for stuff like claude-desktop
  services.displayManager.autoLogin = {
    enable = true;
    user = vars.username;
  };

  networking.hostName = "nixos";

  # nixos version DO NOT CHANGE (the version this machine was first installed with)
  system.stateVersion = "26.05";
}
