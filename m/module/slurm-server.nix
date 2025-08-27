{ ... }:

{
  imports = [
    ./slurm-common.nix
  ];

  services.slurm.server.enable = true;

  networking.firewall = {
    extraCommands = ''
      # Accept slurm connections to controller from compute nodes
      iptables -A nixos-fw -p tcp -s 10.0.40.0/24 --dport 6817 -j nixos-fw-accept
      # Accept slurm connections from compute nodes for srun
      iptables -A nixos-fw -p tcp -s 10.0.40.0/24 --dport 60000:61000 -j nixos-fw-accept
    '';
  };
}
