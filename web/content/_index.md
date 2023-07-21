![Rainforest](jungle.jpg)

Welcome to the jungle, a set of machines with no imposed rules that are fully
controlled and maintained by their users.

The configuration of all the machines is written in a centralized [git
repository][config] using the Nix language for NixOS. Changes in the
configuration of the machines are introduced by merge requests and pass a review
step before being deployed.

[config]: https://pm.bsc.es/gitlab/rarias/jungle

The machines have access to the large list of packages available in
[Nixpkgs][nixpkgs] and a custom set of packages named [bscpkgs][bscpkgs],
specifically tailored to our needs for HPC machines. Users can install their own
packages and made them system-wide available by opening a merge request.

[nixpkgs]: https://github.com/NixOS/nixpkgs
[bscpkgs]: https://pm.bsc.es/gitlab/rarias/bscpkgs

We have put a lot of effort to guarantee very good reproducibility properties in
the configuration of the machines and the software they use.
