{ ... }:

{
  services.slurm = {
    server.enable = true;
    partitionName = [
      "owl Nodes=owl[1-2] Default=YES MaxTime=INFINITE State=UP"
      "all Nodes=owl[1-2],hut Default=NO MaxTime=INFINITE State=UP"
    ];
  };
}
