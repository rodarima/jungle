{ ... }:

{
  fileSystems."/nix" = {
    device = "/dev/disk/by-label/optane";
    fsType = "ext4";
    neededForBoot = true;
  };
  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-label/data";
    fsType = "ext4";
  };
}
