{ ... }:

{
  networking = {
    hostName = "xeon07";

    useDHCP = false;
    defaultGateway = "10.0.40.30";
    nameservers = ["8.8.8.8"];
    interfaces.eno1.useDHCP = false;
    interfaces.eno1.ipv4.addresses = [ {
      address = "10.0.40.7";
      prefixLength = 24;
    } ];

    proxy = {
      default = "http://localhost:23080/";
      noProxy = "127.0.0.1,localhost,internal.domain";
    };

    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 80 443 ];
    };
  };
}
