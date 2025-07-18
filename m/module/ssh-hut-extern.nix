{
  programs.ssh.extraConfig = ''
    Host apex ssfhead
      HostName ssflogin.bsc.es
    Host hut
      ProxyJump apex
  '';
}
