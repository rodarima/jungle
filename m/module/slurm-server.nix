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

      # Accept slurm connections to controller from fox (via wireguard)
      iptables -A nixos-fw -p tcp -i wg0 -s 10.100.0.1/32 --dport 6817 -j nixos-fw-accept
      # Accept slurm connections from fox for srun (via wireguard)
      iptables -A nixos-fw -p tcp -i wg0 -s 10.100.0.1/32 --dport 60000:61000 -j nixos-fw-accept
    '';
  };
}
