{ lib, ... }:

let
  keys = import ../../../keys.nix;
  hostsKeys = lib.mapAttrs (name: value: { publicKey = value; }) keys.hosts;
in
{
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Connect to intranet git hosts via proxy
  programs.ssh.extraConfig = ''
    Host bscpm02.bsc.es bscpm03.bsc.es gitlab-internal.bsc.es alya.gitlab.bsc.es
      User git
      ProxyCommand nc -X connect -x hut:23080 %h %p

    # Connect to BSC machines via hut proxy too
    Host amdlogin1.bsc.es armlogin1.bsc.es hualogin1.bsc.es glogin1.bsc.es glogin2.bsc.es fpgalogin1.bsc.es
      ProxyCommand nc -X connect -x hut:23080 %h %p
  '';

  programs.ssh.knownHosts = hostsKeys // {
    "gitlab-internal.bsc.es".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF9arsAOSRB06hdy71oTvJHG2Mg8zfebADxpvc37lZo3";
    "bscpm03.bsc.es".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM2NuSUPsEhqz1j5b4Gqd+MWFnRqyqY57+xMvBUqHYUS";
    "glogin1.bsc.es".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFsHsZGCrzpd4QDVn5xoDOtrNBkb0ylxKGlyBt6l9qCz";
    "glogin2.bsc.es".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFsHsZGCrzpd4QDVn5xoDOtrNBkb0ylxKGlyBt6l9qCz";
  };
}
