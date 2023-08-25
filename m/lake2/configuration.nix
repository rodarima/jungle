{ config, pkgs, lib, modulesPath, ... }:

{
  imports = [
    ../common/main.nix
  ];

  # For now we install NixOS in the first nvme disk (nvme0n1), as this node only
  # has one SSD already used for SUSE.
  boot.loader.grub.device = "/dev/disk/by-path/pci-0000:83:00.0-nvme-1";

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
