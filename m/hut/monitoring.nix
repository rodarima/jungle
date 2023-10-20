{ config, lib, ... }:

{
  imports = [ ../module/slurm-exporter.nix ];

  services.grafana = {
    enable = true;
    settings = {
      server = {
        domain = "jungle.bsc.es";
        root_url = "%(protocol)s://%(domain)s/grafana";
        serve_from_sub_path = true;
        http_port = 2342;
        http_addr = "127.0.0.1";
      };
      feature_toggles.publicDashboards = true;
      "auth.anonymous".enabled = true;
    };
  };

  # Make grafana alerts also use the proxy
  systemd.services.grafana.environment = config.networking.proxy.envVars;

  services.prometheus = {
    enable = true;
    port = 9001;
    retentionTime = "1y";
    listenAddress = "127.0.0.1";
  };

  systemd.services.prometheus-ipmi-exporter.serviceConfig.DynamicUser = lib.mkForce false;
  systemd.services.prometheus-ipmi-exporter.serviceConfig.PrivateDevices = lib.mkForce false;

  # We need access to the devices to monitor the disk space
  systemd.services.prometheus-node-exporter.serviceConfig.PrivateDevices = lib.mkForce false;
  systemd.services.prometheus-node-exporter.serviceConfig.ProtectHome = lib.mkForce "read-only";

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
      ipmi = {
        enable = true;
        group = "root";
        user = "root";
        configFile = ./ipmi.yml;
        #extraFlags = [ "--log.level=debug" ];
        listenAddress = "127.0.0.1";
      };
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9002;
        listenAddress = "127.0.0.1";
      };
      smartctl = {
        enable = true;
        listenAddress = "127.0.0.1";
      };
      blackbox = {
        enable = true;
        listenAddress = "127.0.0.1";
        configFile = ./blackbox.yml;
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
            "127.0.0.1:${toString config.services.prometheus.exporters.smartctl.port}"
            "127.0.0.1:9341" # Slurm exporter
            "127.0.0.1:${toString config.services.prometheus.exporters.blackbox.port}"
          ];
        }];
      }
      {
        job_name = "ceph";
        static_configs = [{
          targets = [
            "10.0.40.40:9283" # Ceph statistics
            "10.0.40.40:9002" # Node exporter
            "10.0.40.42:9002" # Node exporter
          ];
        }];
      }
      {
        job_name = "blackbox";
        metrics_path = "/probe";
        params = { module = [ "http_2xx" ]; };
        static_configs = [{
          targets = [
            "https://pm.bsc.es/"
            "https://jungle.bsc.es/"
            "https://gitlab.bsc.es/"
          ];
        }];
        relabel_configs = [
          {
            # Takes the address and sets it in the "target=<xyz>" URL parameter
            source_labels = [ "__address__" ];
            target_label = "__param_target";
          }
          {
            # Sets the "instance" label with the remote host we are querying
            source_labels = [ "__param_target" ];
            target_label = "instance";
          }
          {
            # Shows the host target address instead of the blackbox address
            target_label = "__address__";
            replacement = "127.0.0.1:${toString config.services.prometheus.exporters.blackbox.port}";
          }
        ];
      }
      {
        # Scrape the IPMI info of the hosts remotely via LAN
        job_name = "ipmi-lan";
        scrape_interval = "1m";
        scrape_timeout = "30s";
        metrics_path = "/ipmi";
        scheme = "http";
        relabel_configs = [
          {
            # Takes the address and sets it in the "target=<xyz>" URL parameter
            source_labels = [ "__address__" ];
            separator = ";";
            regex = "(.*)(:80)?";
            target_label = "__param_target";
            replacement = "\${1}";
            action = "replace";
          }
          {
            # Sets the "instance" label with the remote host we are querying
            source_labels = [ "__param_target" ];
            separator = ";";
            regex = "(.*)";
            target_label = "instance";
            replacement = "\${1}";
            action = "replace";
          }
          {
            # Sets the fixed "module=lan" URL param
            separator = ";";
            regex = "(.*)";
            target_label = "__param_module";
            replacement = "lan";
            action = "replace";
          }
          {
            # Sets the target to query as the localhost IPMI exporter
            separator = ";";
            regex = ".*";
            target_label = "__address__";
            replacement = "127.0.0.1:9290";
            action = "replace";
          }
        ];

        # Load the list of targets from another file
        file_sd_configs = [
          {
            files = [ "${./targets.yml}" ];
            refresh_interval = "30s";
          }
        ];
      }
    ];
  };
}
