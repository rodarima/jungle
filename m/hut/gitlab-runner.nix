{ pkgs, lib, config, ... }:

{
  age.secrets.ovniToken.file = ../../secrets/ovni-token.age;
  age.secrets.gitlabToken.file = ../../secrets/gitlab-bsc-es-token.age;
  age.secrets.nosvToken.file = ../../secrets/nosv-token.age;

  services.gitlab-runner = {
    enable = true;
    settings.concurrent = 5;
    services = {
      gitlab-bsc-es-shell = {
        registrationConfigFile = config.age.secrets.gitlabToken.path;
        executor = "shell";
        tagList = [ "nix" "xeon" ];
        registrationFlags = [
          # Using space doesn't work, and causes it to misread the next flag
          "--locked='false'"
        ];
        environmentVariables = {
          SHELL = "${pkgs.bash}/bin/bash";
        };
      };
      gitlab-bsc-es-docker = {
        registrationConfigFile = config.age.secrets.gitlabToken.path;
        dockerImage = "debian:stable";
        tagList = [ "docker" "xeon" ];
        registrationFlags = [
          "--locked='false'"
          "--docker-network-mode host"
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
