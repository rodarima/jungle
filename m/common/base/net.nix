{ pkgs, lib, ... }:

{
  networking = {
    enableIPv6 = false;
    useDHCP = false;

    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
    };

    # Make sure we use iptables
    nftables.enable = lib.mkForce false;

    hosts = {
      "84.88.53.236" = [ "ssfhead.bsc.es" "ssfhead" ];
      "84.88.51.152" = [ "raccoon" ];
      "84.88.51.142" = [ "raccoon-ipmi" ];
    };
  };
}
