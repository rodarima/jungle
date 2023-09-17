{ config, pkgs, nixpkgs, bscpkgs, agenix, theFlake, ... }:

{
  imports = [
    ./agenix.nix
    ./boot.nix
    ./fs.nix
    ./hw.nix
    ./net.nix
    ./ntp.nix
    ./slurm.nix
    ./ssh.nix
    ./users.nix
    ./watchdog.nix
    ./rev.nix
    ./zsh.nix
  ];

  nixpkgs.overlays = [
    bscpkgs.bscOverlay
    (import ../../pkgs/overlay.nix)
  ];

  system.configurationRevision =
    if theFlake ? rev
    then theFlake.rev
    else throw ("Refusing to build from a dirty Git tree!");

  nix.nixPath = [
    "nixpkgs=${nixpkgs}"
    "jungle=${theFlake.outPath}"
  ];

  nix.settings.flake-registry =
    pkgs.writeText "global-registry.json" ''{"flakes":[],"version":2}'';

  nix.registry.nixpkgs.flake = nixpkgs;
  nix.registry.jungle.flake = theFlake;

  environment.systemPackages = with pkgs; [
    vim wget git htop tmux pciutils tcpdump ripgrep nix-index nixos-option
    nix-diff ipmitool freeipmi ethtool lm_sensors ix cmake gnumake file tree
    ncdu config.boot.kernelPackages.perf ldns
    # From bsckgs overlay
    bsc.osumb
  ];

  programs.direnv.enable = true;

  systemd.services."serial-getty@ttyS0" = {
    enable = true;
    wantedBy = [ "getty.target" ];
    serviceConfig.Restart = "always";
  };

  # Increase limits
  security.pam.loginLimits = [
    {
      domain = "*";
      type = "-";
      item = "memlock";
      value = "1048576"; # 1 GiB of mem locked
    }
  ];

  time.timeZone = "Europe/Madrid";
  i18n.defaultLocale = "en_DK.UTF-8";

  environment.variables = {
    EDITOR = "vim";
    VISUAL = "vim";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.sandbox = "relaxed";
  nix.settings.trusted-users = [ "@wheel" ];
  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.gc.options = "--delete-older-than 30d";

  programs.bash.promptInit = ''
    PS1="\h\\$ "
  '';

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  #system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
