let
  keys = import ../keys.nix;
  adminsKeys = builtins.attrValues keys.admins;
  hut = [ keys.hosts.hut ] ++ adminsKeys;
  # Only expose ceph keys to safe nodes and admins
  safe = keys.hostGroup.safe ++ adminsKeys;
in
{
  "gitlab-bsc-es-token.age".publicKeys = hut;
  "gitea-runner-token.age".publicKeys = hut;
  "ovni-token.age".publicKeys = hut;
  "nosv-token.age".publicKeys = hut;
  "nix-serve.age".publicKeys = hut;

  "ceph-user.age".publicKeys = safe;
  "munge-key.age".publicKeys = safe;
}
