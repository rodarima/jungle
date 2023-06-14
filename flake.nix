{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
      xeon02 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ( {options, ...}: {
            # Sel the nixos-config path to the one of the current flake
            nixpkgs.overlays = [ bscpkgs.bscOverlay ];
            nix.nixPath = [
                "nixpkgs=${nixpkgs}"
                "bscpkgs=${bscpkgs}"
                "nixos-config=${self.outPath}/xeon02/configuration.nix"
                "nixpkgs-overlays=${self.outPath}/overlays-compat"
            ];
            nix.registry.nixpkgs.flake = nixpkgs;
            nix.registry.bscpkgs.flake = bscpkgs;
            system.configurationRevision =
              if self ? rev
              then self.rev
              else throw ("Refusing to build from a dirty Git tree!");
          })
          ./xeon02/configuration.nix
        ];
      };
      hut = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ( {options, ...}: {
            # Sel the nixos-config path to the one of the current flake
            nixpkgs.overlays = [ bscpkgs.bscOverlay ];
            nix.nixPath = [
                "nixpkgs=${nixpkgs}"
                "bscpkgs=${bscpkgs}"
                "nixos-config=${self.outPath}/hut/configuration.nix"
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
          ./hut/configuration.nix
        ];
      };
      xeon08 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ( {options, ...}: {
            # Sel the nixos-config path to the one of the current flake
            nixpkgs.overlays = [ bscpkgs.bscOverlay ];
            nix.nixPath = [
                "nixpkgs=${nixpkgs}"
                "bscpkgs=${bscpkgs}"
                "nixos-config=${self.outPath}/xeon08/configuration.nix"
                "nixpkgs-overlays=${self.outPath}/overlays-compat"
            ];
            nix.registry.nixpkgs.flake = nixpkgs;
            nix.registry.bscpkgs.flake = bscpkgs;
            system.configurationRevision =
              if self ? rev
              then self.rev
              else throw ("Refusing to build from a dirty Git tree!");
          })
          ./xeon08/configuration.nix
        ];
      };
    };
  };
}
