{ pkgs, lib, config, ... }:

{
  age.secrets.gitlab-pm-shell.file = ../../secrets/gitlab-runner-shell-token.age;
  age.secrets.gitlab-pm-docker.file = ../../secrets/gitlab-runner-docker-token.age;
  age.secrets.gitlab-bsc-docker.file = ../../secrets/gitlab-bsc-docker-token.age;

  services.gitlab-runner = {
    enable = true;
    settings.concurrent = 5;
    services = let
      common-shell = {
        executor = "shell";
        environmentVariables = {
          SHELL = "${pkgs.bash}/bin/bash";
        };
      };
      common-docker = {
        executor = "docker";
        dockerImage = "debian:stable";
        registrationFlags = [
          "--docker-network-mode host"
        ];
        environmentVariables = {
          https_proxy = "http://hut:23080";
          http_proxy = "http://hut:23080";
        };
      };
    in {
      # For pm.bsc.es/gitlab
      gitlab-pm-shell = common-shell // {
        authenticationTokenConfigFile = config.age.secrets.gitlab-pm-shell.path;
      };
      gitlab-pm-docker = common-docker // {
        authenticationTokenConfigFile = config.age.secrets.gitlab-pm-docker.path;
      };

      gitlab-bsc-docker = {
        # gitlab.bsc.es still uses the old token mechanism
        registrationConfigFile = config.age.secrets.gitlab-bsc-docker.path;
        tagList = [ "docker" "hut" ];
        environmentVariables = {
          # We cannot access the hut local interface from docker, so we connect
          # to hut directly via the ethernet one.
          https_proxy = "http://hut:23080";
          http_proxy = "http://hut:23080";
        };
        executor = "docker";
        dockerImage = "alpine";
        dockerVolumes = [
          "/nix/store:/nix/store:ro"
          "/nix/var/nix/db:/nix/var/nix/db:ro"
          "/nix/var/nix/daemon-socket:/nix/var/nix/daemon-socket:ro"
        ];
        dockerExtraHosts = [
          # Required to pass the proxy via hut
          "hut:10.0.40.7"
        ];
        dockerDisableCache = true;
        registrationFlags = [
          # Increase build log length to 64 MiB
          "--output-limit 65536"
        ];
        preBuildScript = pkgs.writeScript "setup-container" ''
          mkdir -p -m 0755 /nix/var/log/nix/drvs
          mkdir -p -m 0755 /nix/var/nix/gcroots
          mkdir -p -m 0755 /nix/var/nix/profiles
          mkdir -p -m 0755 /nix/var/nix/temproots
          mkdir -p -m 0755 /nix/var/nix/userpool
          mkdir -p -m 1777 /nix/var/nix/gcroots/per-user
          mkdir -p -m 1777 /nix/var/nix/profiles/per-user
          mkdir -p -m 0755 /nix/var/nix/profiles/per-user/root
          mkdir -p -m 0700 "$HOME/.nix-defexpr"
          mkdir -p -m 0700 "$HOME/.ssh"
          cat > "$HOME/.ssh/config" << EOF
          Host bscpm04.bsc.es gitlab-internal.bsc.es
            User git
            ProxyCommand nc -X connect -x hut:23080 %h %p
          Host amdlogin1.bsc.es armlogin1.bsc.es hualogin1.bsc.es glogin1.bsc.es glogin2.bsc.es fpgalogin1.bsc.es
            ProxyCommand nc -X connect -x hut:23080 %h %p
          EOF
          cat >> "$HOME/.ssh/known_hosts" << EOF
          bscpm04.bsc.es ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPx4mC0etyyjYUT2Ztc/bs4ZXSbVMrogs1ZTP924PDgT
          gitlab-internal.bsc.es ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF9arsAOSRB06hdy71oTvJHG2Mg8zfebADxpvc37lZo3
          EOF
          . ${pkgs.nix}/etc/profile.d/nix-daemon.sh
          # Required to load SSL certificate paths
          . ${pkgs.cacert}/nix-support/setup-hook
        '';
        environmentVariables = {
          ENV = "/etc/profile";
          USER = "root";
          NIX_REMOTE = "daemon";
          PATH = "${config.system.path}/bin:/bin:/sbin:/usr/bin:/usr/sbin";
        };
      };
    };
  };

  # DOCKER* chains are useless, override at FORWARD
  networking.firewall.extraCommands = ''
    # Allow docker to use our proxy
    iptables -I FORWARD 1 -p tcp -i docker0 -d hut --dport 23080 -j nixos-fw-accept
    # Block anything else coming from docker
    iptables -I FORWARD 2 -p all -i docker0 -j nixos-fw-log-refuse
  '';

  #systemd.services.gitlab-runner.serviceConfig.Shell = "${pkgs.bash}/bin/bash";
  systemd.services.gitlab-runner.serviceConfig.DynamicUser = lib.mkForce false;
  systemd.services.gitlab-runner.serviceConfig.User = "gitlab-runner";
  systemd.services.gitlab-runner.serviceConfig.Group = "gitlab-runner";
  systemd.services.gitlab-runner.serviceConfig.ExecStart = lib.mkForce
    ''${pkgs.gitlab-runner}/bin/gitlab-runner run --config ''${HOME}/.gitlab-runner/config.toml --listen-address "127.0.0.1:9252" --working-directory ''${HOME}'';

  users.users.gitlab-runner = {
    uid = config.ids.uids.gitlab-runner;
    #isNormalUser = true;
    home = "/var/lib/gitlab-runner";
    description = "Gitlab Runner";
    group = "gitlab-runner";
    extraGroups = [ "docker" ];
    createHome = true;
  };
  users.groups.gitlab-runner.gid = config.ids.gids.gitlab-runner;
}
