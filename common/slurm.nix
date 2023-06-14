{ ... }:

{
  services.slurm = {
    client.enable = true;
    controlMachine = "hut";
    clusterName = "owl";
    nodeName = [
      "xeon[01-02,07]  Sockets=2 CoresPerSocket=14 ThreadsPerCore=2 Feature=xeon"
    ];
    extraConfig = ''
      MpiDefault=pmix
      ReturnToService=2
    '';
  };
}
