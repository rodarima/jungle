{ options, ... }:

let

  bscpkgsSrc = builtins.fetchTarball "https://pm.bsc.es/gitlab/rarias/bscpkgs/-/archive/master/bscpkgs-master.tar.gz";
  bscpkgs = import "${bscpkgsSrc}/overlay.nix";

in

{
  nix.nixPath =
    # Prepend default nixPath values.
    options.nix.nixPath.default ++
    # Append our nixpkgs-overlays.
    [ "nixpkgs-overlays=/config/overlays-compat/" ]
  ;

  nixpkgs.overlays = [
    bscpkgs
  ];
}
