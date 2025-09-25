{ pkgs, ... }:

{
  networking.hosts = {
    # Remote hosts visible from compute nodes
    "10.106.0.236" = [ "raccoon" ];
    "10.0.44.4" = [ "tent" ];
  };
}
