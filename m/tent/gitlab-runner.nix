{ pkgs, lib, config, ... }:

{
  age.secrets.tent-gitlab-runner-pm-shell.file = ../../secrets/tent-gitlab-runner-pm-shell-token.age;
  age.secrets.tent-gitlab-runner-pm-docker.file = ../../secrets/tent-gitlab-runner-pm-docker-token.age;
  age.secrets.tent-gitlab-runner-bsc-docker.file = ../../secrets/tent-gitlab-runner-bsc-docker-token.age;

  services.gitlab-runner = let sec = config.age.secrets; in {
    enable = true;
    settings.concurrent = 5;
    services = {
      # For gitlab.pm.bsc.es
      gitlab-pm-shell = {
        executor = "shell";
        environmentVariables = {
          SHELL = "${pkgs.bash}/bin/bash";
        };
        authenticationTokenConfigFile = sec.tent-gitlab-runner-pm-shell.path;
        preGetSourcesScript = pkgs.writeScript "setup" ''
          echo "This is the preGetSources script running, brace for impact"
          env
        '';
      };
      gitlab-pm-docker = {
        authenticationTokenConfigFile = sec.tent-gitlab-runner-pm-docker.path;
        executor = "docker";
        dockerImage = "debian:stable";
      };

      # For gitlab.bsc.es
      gitlab-bsc-docker = {
        # gitlab.bsc.es still uses the old token mechanism
        registrationConfigFile = sec.tent-gitlab-runner-bsc-docker.path;
        tagList = [ "docker" "tent" "nix" ];
        executor = "docker";
        dockerImage = "alpine";
        dockerVolumes = [
          "/nix/store:/nix/store:ro"
          "/nix/var/nix/db:/nix/var/nix/db:ro"
          "/nix/var/nix/daemon-socket:/nix/var/nix/daemon-socket:ro"
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

  systemd.services.gitlab-runner.serviceConfig = {
    DynamicUser = lib.mkForce false;
    User = "gitlab-runner";
    Group = "gitlab-runner";
    ExecStart = lib.mkForce
      ''${pkgs.gitlab-runner}/bin/gitlab-runner run --config ''${HOME}/.gitlab-runner/config.toml --listen-address "127.0.0.1:9252" --working-directory ''${HOME}'';
  };

  users.users.gitlab-runner = {
    uid = config.ids.uids.gitlab-runner;
    home = "/var/lib/gitlab-runner";
    description = "Gitlab Runner";
    group = "gitlab-runner";
    extraGroups = [ "docker" ];
    createHome = true;
  };
  users.groups.gitlab-runner.gid = config.ids.gids.gitlab-runner;
}
