# Laptop: Intel CPU + NVIDIA GPU (hybrid graphics), one built-in screen.
#
# Setup on the laptop (see README): generate hardware-configuration.nix next to this
# file, check the TODOs below, then enable the `laptop` line in flake.nix.
{ ... }:

{
  imports = [
    ./hardware-configuration.nix    # TODO: nixos-generate-config --show-hardware-config > hosts/laptop/hardware-configuration.nix
    ../../modules/nvidia.nix
  ];

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
