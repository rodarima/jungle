{ config, lib, ... }:

{
  services.grafana = {
    enable = true;
    settings.server = {
      http_port = 2342;
      http_addr = "127.0.0.1";
    };
  };

  services.prometheus = {
    enable = true;
    port = 9001;
  };

  systemd.services.prometheus-ipmi-exporter.serviceConfig.DynamicUser = lib.mkForce false;
  systemd.services.prometheus-ipmi-exporter.serviceConfig.PrivateDevices = lib.mkForce false;

  virtualisation.docker.daemon.settings = {
    metrics-addr = "127.0.0.1:9323";
  };

  services.prometheus = {

    exporters = {
      ipmi.enable = true;
      ipmi.group = "root";
      ipmi.user = "root";
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9002;
      };
    };

    scrapeConfigs = [
      {
        job_name = "xeon07";
        static_configs = [{
          targets = [
            "127.0.0.1:${toString config.services.prometheus.exporters.node.port}"
            "127.0.0.1:${toString config.services.prometheus.exporters.ipmi.port}"
            "127.0.0.1:9323"
            "127.0.0.1:9252"
          ];
        }];
      }
    ];
  };
}
