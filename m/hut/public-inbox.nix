{ lib, ... }:

{
  services.public-inbox = {
    enable = true;
    http = {
      enable = true;
      port = 8081;
      mounts = [ "/lists" ];
    };
    settings.publicinbox = {
      css = [ "${./public-inbox.css}" ];
      wwwlisting = "all";
    };
    inboxes = {
      bscpkgs = {
        url = "https://jungle.bsc.es/lists/bscpkgs";
        address = [ "~rodarima/bscpkgs@lists.sr.ht" ];
        watch = [ "imaps://jungle-robot%40gmx.com@imap.gmx.com/INBOX" ];
        description = "Patches for bscpkgs";
        listid = "~rodarima/bscpkgs.lists.sr.ht";
      };
      jungle = {
        url = "https://jungle.bsc.es/lists/jungle";
        address = [ "~rodarima/jungle@lists.sr.ht" ];
        watch = [ "imaps://jungle-robot%40gmx.com@imap.gmx.com/INBOX" ];
        description = "Patches for jungle";
        listid = "~rodarima/jungle.lists.sr.ht";
      };
    };
  };

  # We need access to the network for the watch service, as we will fetch the
  # emails directly from the IMAP server.
  systemd.services.public-inbox-watch.serviceConfig = {
    PrivateNetwork = lib.mkForce false;
    RestrictAddressFamilies = lib.mkForce [ "AF_UNIX"  "AF_INET" "AF_INET6" ];
    KillSignal = "SIGKILL"; # Avoid slow shutdown

    # Required for chmod(..., 02750) on directories by git, from
    # systemd.exec(8):
    # > Note that this restricts marking of any type of file system object with
    # > these bits, including both regular files and directories (where the SGID
    # > is a different meaning than for files, see documentation).
    RestrictSUIDSGID = lib.mkForce false;
  };
}
