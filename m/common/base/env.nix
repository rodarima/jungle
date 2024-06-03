{ pkgs, config, ... }:

{
  environment.systemPackages = with pkgs; [
    vim wget git htop tmux pciutils tcpdump ripgrep nix-index nixos-option
    nix-diff ipmitool freeipmi ethtool lm_sensors ix cmake gnumake file tree
    ncdu config.boot.kernelPackages.perf ldns
    # From bsckgs overlay
    osumb
  ];

  programs.direnv.enable = true;

  # Increase limits
  security.pam.loginLimits = [
    {
      domain = "*";
      type = "-";
      item = "memlock";
      value = "1048576"; # 1 GiB of mem locked
    }
  ];

  environment.variables = {
    EDITOR = "vim";
    VISUAL = "vim";
  };

  programs.bash.promptInit = ''
    PS1="\h\\$ "
  '';

  time.timeZone = "Europe/Madrid";
  i18n.defaultLocale = "en_DK.UTF-8";
}
