{ pkgs, nixpkgs, bscpkgs, theFlake,  ... }:

{
  nixpkgs.overlays = [
    bscpkgs.bscOverlay
    (import ../../../pkgs/overlay.nix)
  ];

  nix = {
    nixPath = [
      "nixpkgs=${nixpkgs}"
      "jungle=${theFlake.outPath}"
    ];

    registry = {
      nixpkgs.flake = nixpkgs;
      jungle.flake = theFlake;
    };

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      sandbox = "relaxed";
      trusted-users = [ "@wheel" ];
      flake-registry = pkgs.writeText "global-registry.json"
        ''{"flakes":[],"version":2}'';
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}