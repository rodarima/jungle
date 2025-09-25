{ config, pkgs, ... }:

{
  networking.nat = {
    enable = true;
    enableIPv6 = false;
    externalInterface = "eno0";
    internalInterfaces = [ "wg0" ];
  };

  networking.firewall = {
    allowedUDPPorts = [ 666 ];
  };

  age.secrets.wgRaccoon.file = ../../secrets/wg-raccoon.age;

  # Enable WireGuard
  networking.wireguard.enable = true;
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.106.0.236/24" ];
      listenPort = 666;
      privateKeyFile = config.age.secrets.wgRaccoon.path;
      # Public key: QUfnGXSMEgu2bviglsaSdCjidB51oEDBFpnSFcKGfDI=
      peers = [
        {
          name = "fox";
          publicKey = "VfMPBQLQTKeyXJSwv8wBhc6OV0j2qAxUpX3kLHunK2Y=";
          allowedIPs = [ "10.106.0.1/32" ];
          endpoint = "fox.ac.upc.edu:666";
          persistentKeepalive = 25;
        }
        {
          name = "apex";
          publicKey = "VwhcN8vSOzdJEotQTpmPHBC52x3Hbv1lkFIyKubrnUA=";
          allowedIPs = [ "10.106.0.30/32" "10.0.40.0/24" ];
          endpoint = "ssfhead.bsc.es:666";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  networking.hosts = {
    "10.106.0.1"  = [ "fox.wg" ];
    "10.106.0.30" = [ "apex.wg" ];
  };
}
