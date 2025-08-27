{ ... }:

{
  imports = [
    ./slurm-common.nix
  ];

  services.slurm.server.enable = true;
}
