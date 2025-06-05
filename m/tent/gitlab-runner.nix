{ pkgs, lib, config, ... }:

{
  age.secrets.tent-gitlab-runner-pm-shell.file = ../../secrets/tent-gitlab-runner-pm-shell-token.age;

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
    createHome = true;
  };
  users.groups.gitlab-runner.gid = config.ids.gids.gitlab-runner;
}
