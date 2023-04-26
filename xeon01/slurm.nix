{ ... }:

{
  services.slurm = {
    client.enable = true;
    controlMachine = "xeon07";
    clusterName = "owl";
    nodeName = [
      "xeon[01-02,07] Sockets=2 CoresPerSocket=14 ThreadsPerCore=2 Feature=xeon"
    ];
  };
}
