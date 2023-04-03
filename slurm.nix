{ ... }:

{
  services.slurm = {
    client.enable = true;
    controlMachine = "ssfhead";
    clusterName = "owl";
    nodeName = [
      "xeon[01-08] Sockets=2 CoresPerSocket=14 ThreadsPerCore=2 Feature=xeon"
    ];
  };
}
