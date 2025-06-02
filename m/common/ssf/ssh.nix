{
  # Connect to intranet git hosts via proxy
  programs.ssh.extraConfig = ''
    # Connect to BSC machines via hut proxy too
    Host amdlogin1.bsc.es armlogin1.bsc.es hualogin1.bsc.es glogin1.bsc.es glogin2.bsc.es fpgalogin1.bsc.es
      ProxyCommand nc -X connect -x hut:23080 %h %p
  '';
}
