{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
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
      owl1    = mkConf "owl1";
      owl2    = mkConf "owl2";
      eudy    = mkConf "eudy";
      koro    = mkConf "koro";
      bay     = mkConf "bay";
      lake2   = mkConf "lake2";
      raccoon = mkConf "raccoon";
    };

    packages.x86_64-linux = self.nixosConfigurations.hut.pkgs // {
      bscpkgs = bscpkgs.packages.x86_64-linux;
      nixpkgs = nixpkgs.legacyPackages.x86_64-linux;
    };
  };
}
