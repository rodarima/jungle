{ config, pkgs, ... }:

{
  imports = [
    ../common/main.nix
    ../module/ceph.nix
    ../module/slurm-firewall.nix
    ../module/slurm-hut-nix-store.nix
  ];

  # Select the this using the ID to avoid mismatches
  boot.loader.grub.device = "/dev/disk/by-id/wwn-0x55cd2e414d53566c";

  networking = {
    hostName = "owl1";
    interfaces.eno1.ipv4.addresses = [ {
      address = "10.0.40.1";
      prefixLength = 24;
    } ];
    interfaces.ibp5s0.ipv4.addresses = [ {
      address = "10.0.42.1";
      prefixLength = 24;
    } ];
  };
}
