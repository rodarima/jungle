{ theFlake, ... }:

let
  nixseparatedebuginfod = theFlake.inputs.nixseparatedebuginfod;
in
{
  imports = [
    nixseparatedebuginfod.nixosModules.default
  ];

  services.nixseparatedebuginfod.enable = true;
}
