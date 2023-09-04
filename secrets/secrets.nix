let
  keys = import ../keys.nix;
  adminsKeys = builtins.attrValues keys.admins;
  hut = [ keys.hosts.hut ] ++ adminsKeys;
  # Only expose ceph keys to safe nodes and admins
  ceph = keys.hostGroup.safe ++ adminsKeys;
in
{
  "ovni-token.age".publicKeys = hut;
  "nosv-token.age".publicKeys = hut;

  "ceph-user.age".publicKeys = ceph;
}
