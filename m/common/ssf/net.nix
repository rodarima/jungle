{ pkgs, ... }:

{
  # Infiniband (IPoIB)
  environment.systemPackages = [ pkgs.rdma-core ];
  boot.kernelModules = [ "ib_umad" "ib_ipoib" ];

  networking = {
    defaultGateway = "10.0.40.30";
    nameservers = ["8.8.8.8"];

    proxy = {
      default = "http://hut:23080/";
      noProxy = "127.0.0.1,localhost,internal.domain,10.0.40.40,hut";
      # Don't set all_proxy as go complains and breaks the gitlab runner, see:
      # https://github.com/golang/go/issues/16715
      allProxy = null;
    };

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
