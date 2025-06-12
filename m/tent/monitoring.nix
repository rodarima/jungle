{ config, lib, pkgs, ... }:

{
  imports = [
    ../module/meteocat-exporter.nix
    ../module/upc-qaire-exporter.nix
  ];

  age.secrets.grafanaJungleRobotPassword = {
    file = ../../secrets/jungle-robot-password.age;
    owner = "grafana";
    mode = "400";
  };

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
      smtp = {
        enabled = true;
        from_address = "jungle-robot@bsc.es";
        user = "jungle-robot";
        # Read the password from a file, which is only readable by grafana user
        # https://grafana.com/docs/grafana/latest/setup-grafana/configure-grafana/#file-provider
        password = "$__file{${config.age.secrets.grafanaJungleRobotPassword.path}}";
        host = "mail.bsc.es:465";
        startTLS_policy = "NoStartTLS";
      };
      feature_toggles.publicDashboards = true;
      "auth.anonymous".enabled = true;
      log.level = "warn";
    };
  };

  services.prometheus = {
    enable = true;
    port = 9001;
    retentionTime = "5y";
    listenAddress = "127.0.0.1";
  };

  # We need access to the devices to monitor the disk space
  systemd.services.prometheus-node-exporter.serviceConfig.PrivateDevices = lib.mkForce false;
  systemd.services.prometheus-node-exporter.serviceConfig.ProtectHome = lib.mkForce "read-only";

  # Credentials for IPMI exporter
  age.secrets.ipmiYml = {
    file = ../../secrets/ipmi.yml.age;
    owner = "ipmi-exporter";
  };

  # Create an IPMI group and assign the ipmi0 device
  users.groups.ipmi = {};
  services.udev.extraRules = ''
    SUBSYSTEM=="ipmi", KERNEL=="ipmi0", GROUP="ipmi", MODE="0660"
  '';

  # Add a new ipmi-exporter user that can read the ipmi0 device
  users.users.ipmi-exporter = {
    isSystemUser = true;
    group = "ipmi";
  };

  # Disable dynamic user so we have the ipmi-exporter user available for the credentials
  systemd.services.prometheus-ipmi-exporter.serviceConfig = {
    DynamicUser = lib.mkForce false;
    PrivateDevices = lib.mkForce false;
    User = lib.mkForce "ipmi-exporter";
    Group = lib.mkForce "ipmi";
    RestrictNamespaces = lib.mkForce false;
    # Fake uid to 0 so it shuts up
    ExecStart = let
      cfg = config.services.prometheus.exporters.ipmi;
    in lib.mkForce (lib.concatStringsSep " " ([
      "${pkgs.util-linux}/bin/unshare --map-user 0"
      "${pkgs.prometheus-ipmi-exporter}/bin/ipmi_exporter"
      "--web.listen-address ${cfg.listenAddress}:${toString cfg.port}"
      "--config.file ${lib.escapeShellArg cfg.configFile}"
    ] ++ cfg.extraFlags));
  };

  services.prometheus = {
    exporters = {
      ipmi = {
        enable = true;
        configFile = config.age.secrets.ipmiYml.path;
        #extraFlags = [ "--log.level=debug" ];
        listenAddress = "127.0.0.1";
      };
      node = {
        enable = true;
        enabledCollectors = [ "logind" ];
        port = 9002;
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
        job_name = "local";
        static_configs = [{
          targets = [
            "127.0.0.1:9002" # Node exporter
            #"127.0.0.1:9115" # Blackbox exporter
            "127.0.0.1:9290" # IPMI exporter for local node
            "127.0.0.1:9928" # UPC Qaire custom exporter
            "127.0.0.1:9929" # Meteocat custom exporter
          ];
        }];
      }
      {
        job_name = "blackbox-http";
        metrics_path = "/probe";
        params = { module = [ "http_2xx" ]; };
        static_configs = [{
          targets = [
            "https://www.google.com/robots.txt"
            "https://pm.bsc.es/"
            "https://pm.bsc.es/gitlab/"
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
            replacement = "127.0.0.1:9115";
          }
        ];
      }
      {
        job_name = "blackbox-icmp";
        metrics_path = "/probe";
        params = { module = [ "icmp" ]; };
        static_configs = [{
          targets = [
            "1.1.1.1"
            "8.8.8.8"
            "ssfhead"
            "raccoon"
            "anella-bsc.cesca.cat"
            "upc-anella.cesca.cat"
            "fox.ac.upc.edu"
            "arenys5.ac.upc.edu"
            "arenys0-2.ac.upc.edu"
            "epi01.bsc.es"
            "axle.bsc.es"
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
            replacement = "127.0.0.1:9115";
          }
        ];
      }
      {
        job_name = "ipmi-raccoon";
        metrics_path = "/ipmi";
        static_configs = [
          { targets = [ "127.0.0.1:9290" ]; }
        ];
        params = {
          target = [ "raccoon-ipmi" ];
          module = [ "raccoon" ];
        };
      }
    ];
  };
}
