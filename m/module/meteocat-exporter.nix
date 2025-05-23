{ config, lib, pkgs, ... }:

with lib;

{
  systemd.services."prometheus-meteocat-exporter" = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Restart = mkDefault "always";
      PrivateTmp = mkDefault true;
      WorkingDirectory = mkDefault "/tmp";
      DynamicUser = mkDefault true;
      ExecStart = "${pkgs.meteocat-exporter}/bin/meteocat-exporter";
    };
  };
}
