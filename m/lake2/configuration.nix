{ config, pkgs, lib, modulesPath, ... }:

{
  imports = [
    ../common/main.nix
  ];

  boot.loader.grub.device = "/dev/disk/by-id/wwn-0x55cd2e414d53563a";

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
