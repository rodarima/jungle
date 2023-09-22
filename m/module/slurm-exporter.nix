{ config, lib, pkgs, ... }:

# See also: https://github.com/NixOS/nixpkgs/pull/112010
# And: https://github.com/NixOS/nixpkgs/pull/115839

with lib;

{
  systemd.services."prometheus-slurm-exporter" = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Restart = mkDefault "always";
      PrivateTmp = mkDefault true;
      WorkingDirectory = mkDefault "/tmp";
      DynamicUser = mkDefault true;
      ExecStart = ''
        ${pkgs.prometheus-slurm-exporter}/bin/prometheus-slurm-exporter --listen-address "127.0.0.1:9341"
      '';
      Environment = [
        "PATH=${pkgs.slurm}/bin"
        # We need to specify the slurm config to be able to talk to the slurmd
        # daemon.
        "SLURM_CONF=${config.services.slurm.etcSlurm}/slurm.conf"
      ];
    };
  };
}
