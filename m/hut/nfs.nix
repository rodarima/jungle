{ ... }:

{
  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /nix 10.0.40.0/24(ro,sync,no_subtree_check,root_squash)
  '';
  networking.firewall.allowedTCPPorts = [ 2049 ];
}
