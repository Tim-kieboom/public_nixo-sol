# Laptop: Intel CPU + NVIDIA GPU (hybrid graphics), one built-in screen.
#
# Setup on the laptop (see README): generate hardware-configuration.nix next to this
# file, check the TODOs below, then enable the `laptop` line in flake.nix.
{ lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nvidia.nix
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
    configurationLimit = 10;
    extraEntries = ''
      menuentry "Windows" {
        insmod part-gpt
        insmod fat
        insmod chain
        search --fs-uuid --no-floppy --set=root FAB7-0D29
        chainloader /EFI/Microsoft/Boot/bootmgfw.efi
      }
    '';
  };
  
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "laptop";

  # TODO: set to the version the installer wrote in its /etc/nixos/configuration.nix
  system.stateVersion = "26.05";

  # Hybrid graphics: the Intel GPU draws the desktop, the NVIDIA GPU only runs
  # programs started with `nvidia-offload <program>` (saves battery).
  hardware.nvidia.prime = {
    offload.enable = true;
    offload.enableOffloadCmd = true;
    # TODO: check with `lspci | grep -E "VGA|3D"` (01:00.0 -> "PCI:1:0:0").
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  # ask for a password at login on a laptop
  services.displayManager.autoLogin.enable = false;

  # battery / heat
  services.thermald.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  # touchpad
  services.libinput.enable = true;
}
