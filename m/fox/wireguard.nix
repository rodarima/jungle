{ config, ... }:

{
  networking.firewall = {
    allowedUDPPorts = [ 666 ];
  };

  age.secrets.wgFox.file = ../../secrets/wg-fox.age;

  networking.wireguard.enable = true;
  networking.wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = {
      # Determines the IP address and subnet of the server's end of the tunnel interface.
      ips = [ "10.100.0.1/24" ];

      # The port that WireGuard listens to. Must be accessible by the client.
      listenPort = 666;

      # Path to the private key file.
      privateKeyFile = config.age.secrets.wgFox.path;
      # Public key: VfMPBQLQTKeyXJSwv8wBhc6OV0j2qAxUpX3kLHunK2Y=

      peers = [
        # List of allowed peers.
        { 
          name = "Apex";
          publicKey = "VwhcN8vSOzdJEotQTpmPHBC52x3Hbv1lkFIyKubrnUA=";
          # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
          allowedIPs = [ "10.100.0.30/32" ];
        }
      ];
    };
  };

  networking.hosts = {
    "10.100.0.30" = [ "apex" ];
  };

  networking.firewall = {
    extraCommands = ''
      # Accept slurm connections to slurmd from apex (via wireguard)
      iptables -A nixos-fw -p tcp -i wg0 -s 10.100.0.30/32 -d 10.100.0.1/32 --dport 6818 -j nixos-fw-accept
    '';
  };
}
