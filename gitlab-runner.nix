{ pkgs, lib, config, ... }:

{
  services.gitlab-runner = {
    enable = true;
    services = {
      # runner for executing stuff on host system (very insecure!)
      # make sure to add required packages (including git!)
      # to `environment.systemPackages`
      shell = {
        # File should contain at least these two variables:
        # `CI_SERVER_URL`
        # `REGISTRATION_TOKEN`
        registrationConfigFile = "/run/secrets/gitlab-runner-registration";
        executor = "shell";
        tagList = [ "nix" "xeon" ];
        environmentVariables = {
          SHELL = "${pkgs.bash}/bin/bash";
        };
      };
    #  # runner for everything else
    #  default = {
    #    # File should contain at least these two variables:
    #    # `CI_SERVER_URL`
    #    # `REGISTRATION_TOKEN`
    #    registrationConfigFile = "/run/secrets/gitlab-runner-registration";
    #    dockerImage = "debian:stable";
    #  };
    };
  };

  #systemd.services.gitlab-runner.serviceConfig.Shell = "${pkgs.bash}/bin/bash";
  systemd.services.gitlab-runner.serviceConfig.DynamicUser = lib.mkForce false;
  systemd.services.gitlab-runner.serviceConfig.User = "gitlab-runner";
  systemd.services.gitlab-runner.serviceConfig.Group = "gitlab-runner";

  users.users.gitlab-runner = {
    uid = config.ids.uids.gitlab-runner;
    #isNormalUser = true;
    home = "/var/lib/gitlab-runner";
    description = "Gitlab Runner";
    group = "gitlab-runner";
    createHome = true;
  };
  users.groups.gitlab-runner.gid = config.ids.gids.gitlab-runner;
}
