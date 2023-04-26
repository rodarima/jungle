{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/22.11";

  outputs = { nixpkgs, ... }: {
    nixosConfigurations = {
      xeon01 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./xeon01/configuration.nix ];
      };
      xeon07 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./xeon07/configuration.nix ];
      };
    };
  };
}
