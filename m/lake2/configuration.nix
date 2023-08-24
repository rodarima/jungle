{ config, pkgs, lib, modulesPath, ... }:

{
  imports = [
    ../common/main.nix
    (modulesPath + "/installer/netboot/netboot-minimal.nix")
  ];

  # For now we install NixOS in the first nvme disk (nvme0n1), as this node only
  # has one SSD already used for SUSE.
  boot.loader.grub.device = "/dev/disk/by-id/nvme-SNVMe_INTEL_SSDPE2MD02CVFT5281004L2P0KGN";

  environment.systemPackages = with pkgs; [
    ceph
  ];

  services.slurm = {
    client.enable = lib.mkForce false;
  };

  networking = {
    hostName = "lake2";
    interfaces.eno1.ipv4.addresses = [ {
      address = "10.0.40.42";
      prefixLength = 24;
    } ];
    interfaces.ibp5s0.ipv4.addresses = [ {
      address = "10.0.42.42";
      prefixLength = 24;
    } ];
  };
}
