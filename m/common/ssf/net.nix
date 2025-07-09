{ pkgs, ... }:

{
  # Infiniband (IPoIB)
  environment.systemPackages = [ pkgs.rdma-core ];
  boot.kernelModules = [ "ib_umad" "ib_ipoib" ];

  networking = {
    defaultGateway = "10.0.40.30";
    nameservers = ["8.8.8.8"];

    firewall = {
      extraCommands = ''
        # Prevent ssfhead from contacting our slurmd daemon
        iptables -A nixos-fw -p tcp -s ssfhead --dport 6817:6819 -j nixos-fw-refuse
        # But accept traffic to slurm ports from any other node in the subnet
        iptables -A nixos-fw -p tcp -s 10.0.40.0/24 --dport 6817:6819 -j nixos-fw-accept
        # We also need to open the srun port range
        iptables -A nixos-fw -p tcp -s 10.0.40.0/24 --dport 60000:61000 -j nixos-fw-accept
      '';
    };
  };
}
