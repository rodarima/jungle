{ pkgs, ... }:

{
  # Infiniband (IPoIB)
  environment.systemPackages = [ pkgs.rdma-core ];
  boot.kernelModules = [ "ib_umad" "ib_ipoib" ];

  networking = {
    enableIPv6 = false;
    useDHCP = false;
    #defaultGateway = "10.0.40.30";
    nameservers = ["8.8.8.8"];
    proxy = {
      default = "http://localhost:23080/";
      noProxy = "127.0.0.1,localhost,internal.domain";
    };

    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];

      # FIXME: For slurmd as it requests the compute nodes to connect to us
      allowedTCPPortRanges = [ { from=1024; to=65535; } ];
    };

    extraHosts = ''
      10.0.40.30      ssfhead
      84.88.53.236    ssfhead.bsc.es ssfhead
      
      # Node Entry for node: mds01 (ID=72)
      10.0.40.40              mds01 mds01-eth0
      10.0.42.40              mds01-ib0
      10.0.40.141             mds01-ipmi0
      
      # Node Entry for node: oss01 (ID=73)
      10.0.40.41              oss01 oss01-eth0
      10.0.42.41              oss01-ib0
      10.0.40.142             oss01-ipmi0
      
      # Node Entry for node: oss02 (ID=74)
      10.0.40.42              oss02 oss02-eth0
      10.0.42.42              oss02-ib0
      10.0.40.143             oss02-ipmi0
      
      # Node Entry for node: xeon01 (ID=15)
      10.0.40.1               xeon01 xeon01-eth0 owl1
      10.0.42.1               xeon01-ib0
      10.0.40.101             xeon01-ipmi0
      
      # Node Entry for node: xeon02 (ID=16)
      10.0.40.2               xeon02 xeon02-eth0 owl2
      10.0.42.2               xeon02-ib0
      10.0.40.102             xeon02-ipmi0
      
      # Node Entry for node: xeon03 (ID=17)
      10.0.40.3               xeon03 xeon03-eth0
      10.0.42.3               xeon03-ib0
      10.0.40.103             xeon03-ipmi0
      
      # Node Entry for node: xeon04 (ID=18)
      10.0.40.4               xeon04 xeon04-eth0
      10.0.42.4               xeon04-ib0
      10.0.40.104             xeon04-ipmi0
      
      # Node Entry for node: xeon05 (ID=19)
      10.0.40.5               xeon05 xeon05-eth0
      10.0.42.5               xeon05-ib0
      10.0.40.105             xeon05-ipmi0
      
      # Node Entry for node: xeon06 (ID=20)
      10.0.40.6               xeon06 xeon06-eth0
      10.0.42.6               xeon06-ib0
      10.0.40.106             xeon06-ipmi0
      
      # Node Entry for node: xeon07 (ID=21)
      10.0.40.7               xeon07 xeon07-eth0 hut
      10.0.42.7               xeon07-ib0
      10.0.40.107             xeon07-ipmi0
      
      # Node Entry for node: xeon08 (ID=22)
      10.0.40.8               xeon08 xeon08-eth0 eudy
      10.0.42.8               xeon08-ib0
      10.0.40.108             xeon08-ipmi0
    '';
  };
}
