{ ... }:

{
  services.slurm = {
    client.enable = true;
    server.enable = true;
    controlMachine = "xeon07";
    clusterName = "owl";
    nodeName = [
      "xeon[01-02,07] Sockets=2 CoresPerSocket=14 ThreadsPerCore=2 Feature=xeon"
    ];

    partitionName = [
      "xeon Nodes=xeon[01-02,07] Default=YES MaxTime=INFINITE State=UP"
    ];
  };
}
