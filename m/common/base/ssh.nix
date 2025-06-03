{ lib, ... }:

let
  keys = import ../../../keys.nix;
  hostsKeys = lib.mapAttrs (name: value: { publicKey = value; }) keys.hosts;
in
{
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  programs.ssh.knownHosts = hostsKeys // {
    "gitlab-internal.bsc.es".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF9arsAOSRB06hdy71oTvJHG2Mg8zfebADxpvc37lZo3";
    "bscpm03.bsc.es".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM2NuSUPsEhqz1j5b4Gqd+MWFnRqyqY57+xMvBUqHYUS";
    "bscpm04.bsc.es".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPx4mC0etyyjYUT2Ztc/bs4ZXSbVMrogs1ZTP924PDgT";
    "glogin1.bsc.es".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFsHsZGCrzpd4QDVn5xoDOtrNBkb0ylxKGlyBt6l9qCz";
    "glogin2.bsc.es".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFsHsZGCrzpd4QDVn5xoDOtrNBkb0ylxKGlyBt6l9qCz";
  };
}
