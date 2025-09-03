{ ... }:

{
  services.nfs.server = {
    enable = true;
    lockdPort = 4001;
    mountdPort = 4002;
    statdPort = 4000;
    exports = ''
      /home 10.0.40.0/24(rw,async,no_subtree_check,no_root_squash)
      /home 10.106.0.0/24(rw,async,no_subtree_check,no_root_squash)
    '';
  };
  networking.firewall = {
    # Check with `rpcinfo -p`
    extraCommands = ''
      # Accept NFS traffic from compute nodes but not from the outside
      iptables -A nixos-fw -p tcp -s 10.0.40.0/24 --dport 111   -j nixos-fw-accept
      iptables -A nixos-fw -p tcp -s 10.0.40.0/24 --dport 2049  -j nixos-fw-accept
      iptables -A nixos-fw -p tcp -s 10.0.40.0/24 --dport 4000  -j nixos-fw-accept
      iptables -A nixos-fw -p tcp -s 10.0.40.0/24 --dport 4001  -j nixos-fw-accept
      iptables -A nixos-fw -p tcp -s 10.0.40.0/24 --dport 4002  -j nixos-fw-accept
      iptables -A nixos-fw -p tcp -s 10.0.40.0/24 --dport 20048 -j nixos-fw-accept
      # Same but UDP
      iptables -A nixos-fw -p udp -s 10.0.40.0/24 --dport 111   -j nixos-fw-accept
      iptables -A nixos-fw -p udp -s 10.0.40.0/24 --dport 2049  -j nixos-fw-accept
      iptables -A nixos-fw -p udp -s 10.0.40.0/24 --dport 4000  -j nixos-fw-accept
      iptables -A nixos-fw -p udp -s 10.0.40.0/24 --dport 4001  -j nixos-fw-accept
      iptables -A nixos-fw -p udp -s 10.0.40.0/24 --dport 4002  -j nixos-fw-accept
      iptables -A nixos-fw -p udp -s 10.0.40.0/24 --dport 20048 -j nixos-fw-accept

      # Accept NFS traffic from wg0
      iptables -A nixos-fw -p tcp -i wg0 -s 10.106.0.0/24 --dport 111   -j nixos-fw-accept
      iptables -A nixos-fw -p tcp -i wg0 -s 10.106.0.0/24 --dport 2049  -j nixos-fw-accept
      iptables -A nixos-fw -p tcp -i wg0 -s 10.106.0.0/24 --dport 4000  -j nixos-fw-accept
      iptables -A nixos-fw -p tcp -i wg0 -s 10.106.0.0/24 --dport 4001  -j nixos-fw-accept
      iptables -A nixos-fw -p tcp -i wg0 -s 10.106.0.0/24 --dport 4002  -j nixos-fw-accept
      iptables -A nixos-fw -p tcp -i wg0 -s 10.106.0.0/24 --dport 20048 -j nixos-fw-accept
      # Same but UDP
      iptables -A nixos-fw -p udp -i wg0 -s 10.106.0.0/24 --dport 111   -j nixos-fw-accept
      iptables -A nixos-fw -p udp -i wg0 -s 10.106.0.0/24 --dport 2049  -j nixos-fw-accept
      iptables -A nixos-fw -p udp -i wg0 -s 10.106.0.0/24 --dport 4000  -j nixos-fw-accept
      iptables -A nixos-fw -p udp -i wg0 -s 10.106.0.0/24 --dport 4001  -j nixos-fw-accept
      iptables -A nixos-fw -p udp -i wg0 -s 10.106.0.0/24 --dport 4002  -j nixos-fw-accept
      iptables -A nixos-fw -p udp -i wg0 -s 10.106.0.0/24 --dport 20048 -j nixos-fw-accept
    '';
  };
}
