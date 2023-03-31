{ ... }:

{
  # Mount the home via NFS
  fileSystems."/home" = {
    device = "10.0.40.30:/home";
    fsType = "nfs";
    options = [ "nfsvers=3" "rsize=1024" "wsize=1024" "cto" ];
  };
}
