{ pkgs, ... }:

{
  # Infiniband (IPoIB)
  environment.systemPackages = [ pkgs.rdma-core ];
  boot.kernelModules = [ "ib_umad" "ib_ipoib" ];

  networking = {
    enableIPv6 = false;
    useDHCP = false;
    defaultGateway = "10.0.40.30";
    nameservers = ["8.8.8.8"];
    proxy = {
      default = "http://localhost:23080/";
      noProxy = "127.0.0.1,localhost,internal.domain,10.0.40.40";
      # Don't set all_proxy as go complains and breaks the gitlab runner, see:
      # https://github.com/golang/go/issues/16715
      allProxy = null;
    };

    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
      extraCommands = ''
        # Prevent ssfhead from contacting our slurmd daemon
        iptables -A nixos-fw -p tcp -s ssfhead --dport 6817:6819 -j nixos-fw-refuse
        # But accept traffic to slurm ports from any other node in the subnet
        iptables -A nixos-fw -p tcp -s 10.0.40.0/24 --dport 6817:6819 -j nixos-fw-accept
        # We also need to open the srun port range
        iptables -A nixos-fw -p tcp -s 10.0.40.0/24 --dport 60000:61000 -j nixos-fw-accept
      '';
    };

    extraHosts = ''
      10.0.40.30      ssfhead
      84.88.53.236    ssfhead.bsc.es ssfhead
      
      # Node Entry for node: mds01 (ID=72)
      10.0.40.40              bay mds01 mds01-eth0
      10.0.42.40              bay-ib mds01-ib0
      10.0.40.141             bay-ipmi mds01-ipmi0
      
      # Node Entry for node: oss01 (ID=73)
      10.0.40.41              oss01 oss01-eth0
      10.0.42.41              oss01-ib0
      10.0.40.142             oss01-ipmi0
      
      # Node Entry for node: oss02 (ID=74)
      10.0.40.42              lake2 oss02 oss02-eth0
      10.0.42.42              lake2-ib oss02-ib0
      10.0.40.143             lake2-ipmi oss02-ipmi0
      
      # Node Entry for node: xeon01 (ID=15)
      10.0.40.1               owl1 xeon01 xeon01-eth0
      10.0.42.1               owl1-ib xeon01-ib0
      10.0.40.101             owl1-ipmi xeon01-ipmi0
      
      # Node Entry for node: xeon02 (ID=16)
      10.0.40.2               owl2 xeon02 xeon02-eth0
      10.0.42.2               owl2-ib xeon02-ib0
      10.0.40.102             owl2-ipmi xeon02-ipmi0
      
      # Node Entry for node: xeon03 (ID=17)
      10.0.40.3               xeon03 xeon03-eth0
      10.0.42.3               xeon03-ib0
      10.0.40.103             xeon03-ipmi0
      
      # Node Entry for node: xeon04 (ID=18)
      10.0.40.4               xeon04 xeon04-eth0
      10.0.42.4               xeon04-ib0
      10.0.40.104             xeon04-ipmi0
      
      # Node Entry for node: xeon05 (ID=19)
      10.0.40.5               koro xeon05 xeon05-eth0
      10.0.42.5               koro-ib xeon05-ib0
      10.0.40.105             koro-ipmi xeon05-ipmi0
      
      # Node Entry for node: xeon06 (ID=20)
      10.0.40.6               xeon06 xeon06-eth0
      10.0.42.6               xeon06-ib0
      10.0.40.106             xeon06-ipmi0
      
      # Node Entry for node: xeon07 (ID=21)
      10.0.40.7               hut xeon07 xeon07-eth0
      10.0.42.7               hut-ib xeon07-ib0
      10.0.40.107             hut-ipmi xeon07-ipmi0
      
      # Node Entry for node: xeon08 (ID=22)
      10.0.40.8               eudy xeon08 xeon08-eth0
      10.0.42.8               eudy-ib xeon08-ib0
      10.0.40.108             eudy-ipmi xeon08-ipmi0
    '';
  };
}
