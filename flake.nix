{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/22.11";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    bscpkgs.url = "git+https://pm.bsc.es/gitlab/rarias/bscpkgs.git";
  };

  outputs = { self, nixpkgs, agenix, bscpkgs, ... }: {
    nixosConfigurations = {
      xeon01 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ( {options, ...}: {
            # Sel the nixos-config path to the one of the current flake
            nixpkgs.overlays = [ bscpkgs.bscOverlay ];
            nix.nixPath = [
                "nixpkgs=${nixpkgs}"
                "bscpkgs=${bscpkgs}"
                "nixos-config=${self.outPath}/xeon01/configuration.nix"
                "nixpkgs-overlays=${self.outPath}/overlays-compat"
            ];
            nix.registry.nixpkgs.flake = nixpkgs;
            nix.registry.bscpkgs.flake = bscpkgs;
            system.configurationRevision =
              if self ? rev
              then self.rev
              else throw ("Refusing to build from a dirty Git tree!");
          })
          ./xeon01/configuration.nix
        ];
      };
      xeon07 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ( {options, ...}: {
            # Sel the nixos-config path to the one of the current flake
            nixpkgs.overlays = [ bscpkgs.bscOverlay ];
            nix.nixPath = [
                "nixpkgs=${nixpkgs}"
                "bscpkgs=${bscpkgs}"
                "nixos-config=${self.outPath}/xeon07/configuration.nix"
                "nixpkgs-overlays=${self.outPath}/overlays-compat"
            ];
            nix.registry.nixpkgs.flake = nixpkgs;
            nix.registry.bscpkgs.flake = bscpkgs;
            system.configurationRevision =
              if self ? rev
              then self.rev
              else throw ("Refusing to build from a dirty Git tree!");
          })
          agenix.nixosModules.default
          ./xeon07/configuration.nix
        ];
      };
    };
  };
}
