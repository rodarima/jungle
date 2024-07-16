{ pkgs, lib, config, ... }:

{
  age.secrets.gitlabRunnerShellToken.file = ../../secrets/gitlab-runner-shell-token.age;
  age.secrets.gitlabRunnerDockerToken.file = ../../secrets/gitlab-runner-docker-token.age;

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
          https_proxy = "http://localhost:23080";
          http_proxy = "http://localhost:23080";
        };
      };
    in {
      # For pm.bsc.es/gitlab
      gitlab-pm-shell = common-shell // {
        authenticationTokenConfigFile = config.age.secrets.gitlabRunnerShellToken.path;
      };
      gitlab-pm-docker = common-docker // {
        authenticationTokenConfigFile = config.age.secrets.gitlabRunnerDockerToken.path;
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
