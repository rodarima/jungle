{ config, lib, pkgs, ... }:

# See also: https://github.com/NixOS/nixpkgs/pull/112010

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
      Environment = [ "PATH=${pkgs.slurm}/bin" ];
    };
  };
}
