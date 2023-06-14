{ ... }:

{
  services.slurm = {
    server.enable = true;
    partitionName = [
      "xeon Nodes=xeon[01-02,07] Default=YES MaxTime=INFINITE State=UP"
    ];
  };
}
