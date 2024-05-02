{ config, lib, ... }:
{
  age.secrets.jungleRobotPassword = {
    file = ../../secrets/jungle-robot-password.age;
    group = "gitea";
    mode = "440";
  };

  programs.msmtp = {
    enable = true;
    accounts = {
      default = {
        auth = true;
        tls = true;
        tls_starttls = false;
        port = 465;
        host = "mail.bsc.es";
        user = "jungle-robot";
        passwordeval = "cat ${config.age.secrets.jungleRobotPassword.path}";
        from = "jungle-robot@bsc.es";
      };
    };
  };
}
