{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    bscpkgs.url = "git+https://pm.bsc.es/gitlab/rarias/bscpkgs.git";
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
      hut   = mkConf "hut";
      owl1  = mkConf "owl1";
      owl2  = mkConf "owl2";
      eudy  = mkConf "eudy";
    };

    packages.x86_64-linux.hut = self.nixosConfigurations.hut.pkgs;
  };
}
