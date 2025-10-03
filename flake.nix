{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    bscpkgs.url = "git+https://git.sr.ht/~rodarima/bscpkgs";
    bscpkgs.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, agenix, bscpkgs, ... }:
let
  mkConf = name: nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit nixpkgs bscpkgs agenix; theFlake = self; };
    modules = [ "${self.outPath}/m/${name}/configuration.nix" ];
  };
in
  {
    nixosConfigurations = {
      hut     = mkConf "hut";
      tent    = mkConf "tent";
      owl1    = mkConf "owl1";
      owl2    = mkConf "owl2";
      eudy    = mkConf "eudy";
      koro    = mkConf "koro";
      bay     = mkConf "bay";
      lake2   = mkConf "lake2";
      raccoon = mkConf "raccoon";
      fox     = mkConf "fox";
      apex    = mkConf "apex";
      weasel  = mkConf "weasel";
    };

    packages.x86_64-linux = self.nixosConfigurations.hut.pkgs // {
      bscpkgs = bscpkgs.packages.x86_64-linux;
      nixpkgs = nixpkgs.legacyPackages.x86_64-linux;
    };
  };

# TODO: Merge from bscpkgs:
#
#  inputs.nixpkgs.url = "nixpkgs";
#
#  outputs = { self, nixpkgs, ...}:
#    let
#      # For now we only support x86
#      system = "x86_64-linux";
#      pkgs = import nixpkgs {
#        inherit system;
#        overlays = [ self.overlays.default ];
#      };
#    in
#    {
#      bscOverlay = import ./overlay.nix;
#      overlays.default = self.bscOverlay;
#      # full nixpkgs with our overlay applied
#      legacyPackages.${system} = pkgs;
#
#      hydraJobs = {
#        inherit (self.legacyPackages.${system}.bsc-ci) tests pkgs cross;
#      };
#
#      # propagate nixpkgs lib, so we can do bscpkgs.lib
#      inherit (nixpkgs) lib;
#    };
}
