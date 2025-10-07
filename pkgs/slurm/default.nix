{ slurm }:

slurm.overrideAttrs (old: {
  patches = (old.patches or []) ++ [
    # See https://bugs.schedmd.com/show_bug.cgi?id=19324
    # Still unmerged as of 2025-10-03, another corpo-cancer.
    ./slurm-rank-expansion.patch
  ];
  # Install also the pam_slurm_adopt library to restrict users from accessing
  # nodes with no job allocated.
  # TODO: Review pam_slurm_adopt, I don't trust their code much.
  postBuild = (old.postBuild or "") + ''
    pushd contribs/pam_slurm_adopt
      make "PAM_DIR=$out/lib/security"
    popd
  '';
  postInstall = (old.postInstall or "") + ''
    pushd contribs/pam_slurm_adopt
      make "PAM_DIR=$out/lib/security" install
    popd
  '';
})
