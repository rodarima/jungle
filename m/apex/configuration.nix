{ lib, config, pkgs, ... }:

{
  imports = [
    ../common/xeon.nix
    ../common/ssf/hosts.nix
    ../module/ceph.nix
    ./nfs.nix
  ];

  # Don't install grub MBR for now
  boot.loader.grub.device = "nodev";

  boot.initrd.kernelModules = [
    "megaraid_sas" # For HW RAID
  ];

  environment.systemPackages = with pkgs; [
    storcli # To manage HW RAID
  ];

  fileSystems."/home" = {
    device = "/dev/disk/by-label/home";
    fsType = "ext4";
  };

  # No swap, there is plenty of RAM
  swapDevices = lib.mkForce [];

  networking = {
    hostName = "apex";
    defaultGateway = "84.88.53.233";
    nameservers = [ "8.8.8.8" ];

    # Public facing interface
    interfaces.eno1.ipv4.addresses = [ {
      address = "84.88.53.236";
      prefixLength = 29;
    } ];

    # Internal LAN to our Ethernet switch
    interfaces.eno2.ipv4.addresses = [ {
      address = "10.0.40.30";
      prefixLength = 24;
    } ];

    # Infiniband over Omnipath switch (disconnected for now)
    # interfaces.ibp5s0 = {};

    nat = {
      enable = true;
      internalInterfaces = [ "eno2" ];
      externalInterface = "eno1";
    };
  };

  # Use tent for cache
  nix.settings = {
    extra-substituters = [ "https://jungle.bsc.es/cache" ];
    extra-trusted-public-keys = [ "jungle.bsc.es:pEc7MlAT0HEwLQYPtpkPLwRsGf80ZI26aj29zMw/HH0=" ];
  };
}
