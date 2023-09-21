{ config, lib, pkgs, ... }:

# See also: https://github.com/NixOS/nixpkgs/pull/112010
# And: https://github.com/NixOS/nixpkgs/pull/115839

with lib;

{
  users = {
    users."slurm-exporter" = {
      description = "Prometheus slurm exporter service user";
      isSystemUser = true;
      group = "slurm-exporter";
    };
    groups = {
      "slurm-exporter" = {};
    };
  };

  systemd.services."prometheus-slurm-exporter" = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Restart = mkDefault "always";
      PrivateTmp = mkDefault true;
      WorkingDirectory = mkDefault "/tmp";
      DynamicUser = mkDefault true;
      User = "slurm-exporter";
      Group = "slurm-exporter";
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
