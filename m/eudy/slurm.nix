{ lib, ... }:

{
  services.slurm = {
    client.enable = lib.mkForce false;
  };
}
