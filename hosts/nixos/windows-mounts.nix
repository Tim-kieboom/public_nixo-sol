# The Windows drives of this machine (by UUID, so they only exist here).
{ vars, ... }:

let
  ntfs = device: {
    inherit device;
    fsType = "ntfs3";
    options = [
      "rw"
      "nofail"                              # don't block boot if its unavailable
      "uid=${toString vars.uid}" "gid=100"  # make files owned by the user
      "windows_names"                       # avoid names Windows can't handle
      "umask=022"                           # give write access
      "x-systemd.automount"                 # mount on first access
    ];
  };
in
{
  fileSystems."/mnt/windows" = ntfs "/dev/disk/by-uuid/1C78DD2B78DD0484";
  fileSystems."/mnt/windows_fdisk" = ntfs "/dev/disk/by-uuid/468A0BDA8A0BC601";
}
