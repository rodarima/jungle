let
  keys = import ../keys.nix;
  adminsKeys = builtins.attrValues keys.admins;
  hut = [ keys.hosts.hut ] ++ adminsKeys;
  # Only expose ceph keys to safe nodes and admins
  safe = keys.hostGroup.safe ++ adminsKeys;
in
{
  "gitea-runner-token.age".publicKeys = hut;
  "gitlab-runner-docker-token.age".publicKeys = hut;
  "gitlab-runner-shell-token.age".publicKeys = hut;
  "gitlab-bsc-docker-token.age".publicKeys = hut;
  "nix-serve.age".publicKeys = hut;
  "jungle-robot-password.age".publicKeys = hut;
  "ipmi.yml.age".publicKeys = hut;

  "ceph-user.age".publicKeys = safe;
  "munge-key.age".publicKeys = safe;
}
