{ config, lib, ... }:

{
  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_port = 2342;
        http_addr = "127.0.0.1";
      };
      feature_toggles.publicDashboards = true;
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

  # Required to allow the smartctl exporter to read the nvme0 character device,
  # see the commit message on:
  # https://github.com/NixOS/nixpkgs/commit/12c26aca1fd55ab99f831bedc865a626eee39f80
  services.udev.extraRules = ''
    SUBSYSTEM=="nvme", KERNEL=="nvme[0-9]*", GROUP="disk"
  '';

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
      smartctl.enable = true;
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
            "127.0.0.1:${toString config.services.prometheus.exporters.smartctl.port}"
          ];
        }];
      }
    ];
  };
}
