let
  keys = import ../keys.nix;
  adminsKeys = builtins.attrValues keys.admins;
  hut = [ keys.hosts.hut ] ++ adminsKeys;
  mon = [ keys.hosts.hut keys.hosts.tent ] ++ adminsKeys;
  tent = [ keys.hosts.tent ] ++ adminsKeys;
  # Only expose ceph keys to safe nodes and admins
  safe = keys.hostGroup.safe ++ adminsKeys;
in
{
  "gitea-runner-token.age".publicKeys = hut;
  "gitlab-runner-docker-token.age".publicKeys = hut;
  "gitlab-runner-shell-token.age".publicKeys = hut;
  "gitlab-bsc-docker-token.age".publicKeys = hut;
  "nix-serve.age".publicKeys = mon;
  "jungle-robot-password.age".publicKeys = mon;
  "ipmi.yml.age".publicKeys = mon;

  "tent-gitlab-runner-pm-docker-token.age".publicKeys = tent;
  "tent-gitlab-runner-pm-shell-token.age".publicKeys = tent;

  "ceph-user.age".publicKeys = safe;
  "munge-key.age".publicKeys = safe;
}
