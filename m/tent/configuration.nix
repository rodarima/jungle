{ config, pkgs, ... }:

{
  imports = [
    ../common/xeon.nix
    ../module/emulation.nix
    ../module/debuginfod.nix
  ];

  # Select the this using the ID to avoid mismatches
  boot.loader.grub.device = "/dev/disk/by-id/wwn-0x55cd2e414d537675";

  networking = {
    hostName = "tent";
    interfaces.eno1.ipv4.addresses = [
      {
        address = "10.0.44.4";
        prefixLength = 24;
      }
    ];

    # Only BSC DNSs seem to be reachable from the office VLAN
    nameservers = [ "84.88.52.35" "84.88.52.36" ];
    defaultGateway = "10.0.44.1";
  };

  nix.settings = {
    extra-substituters = [ "https://jungle.bsc.es/cache" ];
    extra-trusted-public-keys = [ "jungle.bsc.es:pEc7MlAT0HEwLQYPtpkPLwRsGf80ZI26aj29zMw/HH0=" ];
  };

  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [ "systemd" ];
    port = 9002;
    listenAddress = "127.0.0.1";
  };
}
