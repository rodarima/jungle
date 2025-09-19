{ config, ... }:

{
  networking.firewall = {
    allowedUDPPorts = [ 666 ];
  };

  age.secrets.wgApex.file = ../../secrets/wg-apex.age;

  # Enable WireGuard
  networking.wireguard.enable = true;
  networking.wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = {
      ips = [ "10.106.0.30/24" ];
      listenPort = 666;
      privateKeyFile = config.age.secrets.wgApex.path;
      # Public key: VwhcN8vSOzdJEotQTpmPHBC52x3Hbv1lkFIyKubrnUA=
      peers = [
        {
          name = "fox";
          publicKey = "VfMPBQLQTKeyXJSwv8wBhc6OV0j2qAxUpX3kLHunK2Y=";
          allowedIPs = [ "10.106.0.1/32" ];
          endpoint = "fox.ac.upc.edu:666";
          # Send keepalives every 25 seconds. Important to keep NAT tables alive.
          persistentKeepalive = 25;
        }
      ];
    };
  };

  networking.hosts = {
    "10.106.0.1" = [ "fox" ];
  };
}
