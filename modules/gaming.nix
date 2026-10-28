{ ... }:

{ 
  # make sure that wayland and the game run on the sam GPU
  services.udev.extraRules = ''
    KERNEL=="card*", KERNELS=="0000:0a:00.0", SUBSYSTEM=="drm", SUBSYSTEMS=="pci", SYMLINK+="dri/gpu-a"
    KERNEL=="card*", KERNELS=="0000:01:00.0", SUBSYSTEM=="drm", SUBSYSTEMS=="pci", SYMLINK+="dri/gpu-b"
  '';

  environment.sessionVariables.AQ_DRM_DEVICES = "/dev/dri/gpu-a:/dev/dri/gpu-b";

  programs.steam.enable = true;
  programs.gamemode.enable = true;
}
