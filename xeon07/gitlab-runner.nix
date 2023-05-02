{ pkgs, lib, config, ... }:

{
  age.secrets."secrets/ovni-token".file = ./secrets/ovni-token.age;
  age.secrets."secrets/nosv-token".file = ./secrets/nosv-token.age;

  services.gitlab-runner = {
    enable = true;
    settings.concurrent = 5;
    services = {
      ovni-shell = {
        registrationConfigFile = config.age.secrets."secrets/ovni-token".path;
        executor = "shell";
        tagList = [ "nix" "xeon" ];
        environmentVariables = {
          SHELL = "${pkgs.bash}/bin/bash";
        };
      };
      ovni-docker = {
        registrationConfigFile = config.age.secrets."secrets/ovni-token".path;
        dockerImage = "debian:stable";
        tagList = [ "docker" "xeon" ];
        registrationFlags = [ "--docker-network-mode host" ];
        environmentVariables = {
          https_proxy = "http://localhost:23080";
          http_proxy = "http://localhost:23080";
        };
      };
      nosv-docker = {
        registrationConfigFile = config.age.secrets."secrets/nosv-token".path;
        dockerImage = "debian:stable";
        tagList = [ "docker" "xeon" ];
        registrationFlags = [
          "--docker-network-mode host"
          "--docker-cpus 56"
        ];
        environmentVariables = {
          https_proxy = "http://localhost:23080";
          http_proxy = "http://localhost:23080";
        };
      };
    };
  };

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
