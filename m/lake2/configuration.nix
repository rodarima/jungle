{ config, pkgs, lib, modulesPath, ... }:

{
  imports = [
    ../common/main.nix
    ../common/monitoring.nix
  ];

  boot.loader.grub.device = "/dev/disk/by-id/wwn-0x55cd2e414d53563a";

  environment.systemPackages = with pkgs; [
    ceph
  ];

  services.slurm = {
    client.enable = lib.mkForce false;
  };

  services.ceph = {
    enable = true;
    global = {
      fsid = "9c8d06e0-485f-4aaf-b16b-06d6daf1232b";
      monHost = "10.0.42.40";
      monInitialMembers = "10.0.42.40";
      publicNetwork = "10.0.42.40/24";
      clusterNetwork = "10.0.42.40/24";
    };
    osd = {
      enable = true;
      # One daemon per NVME disk
      daemons = [ "4" "5" "6" "7" ];
      extraConfig = {
        "osd crush chooseleaf type" = "0";
        "osd journal size" = "10000";
        "osd pool default min size" = "2";
        "osd pool default pg num" = "200";
        "osd pool default pgp num" = "200";
        "osd pool default size" = "3";
      };
    };
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
