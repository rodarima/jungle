{ ... }:

{
  services.slurm = {
    client.enable = true;
    controlMachine = "hut";
    clusterName = "jungle";
    nodeName = [
      "owl[1,2]  Sockets=2 CoresPerSocket=14 ThreadsPerCore=2 Feature=owl"
      "hut       Sockets=2 CoresPerSocket=14 ThreadsPerCore=2"
    ];
    extraConfig = ''
      MpiDefault=pmix
      ReturnToService=2
    '';
  };
}
