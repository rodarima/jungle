{ lib, ... }:

{
  imports = [
    ./slurm-common.nix
  ];

  systemd.services.slurmd.serviceConfig = {
    # Kill all processes in the control group on stop/restart. This will kill
    # all the jobs running, so ensure that we only upgrade when the nodes are
    # not in use. See:
    # https://github.com/NixOS/nixpkgs/commit/ae93ed0f0d4e7be0a286d1fca86446318c0c6ffb
    # https://bugs.schedmd.com/show_bug.cgi?id=2095#c24
    KillMode = lib.mkForce "control-group";
  };

  services.slurm.client.enable = true;
}
