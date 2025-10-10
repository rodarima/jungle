# Maintainers

## Role of a maintainer
The responsibilities of maintainers are quite lax, and similar in spirit to
[nixpkgs' maintainers][1]:

    The main responsibility of a maintainer is to keep the packages they
    maintain in a functioning state, and keep up with updates. In order to do
    that, they are empowered to make decisions over the packages they maintain.

    That being said, the maintainer is not alone in proposing changes to the
    packages. Anybody (both bots and humans) can send PRs to bump or tweak the
    package.

In practice, this means that when updating or proposing changes to a package,
we will notify maintainers by mentioning them in Gitea so they can test changes
and give feedback.

Since we do bi-yearly release cycles, there is no expectation from maintainers
to update packages at each upstream release. Nevertheless, on each release cycle
we may request help from maintainers when updating or testing their packages.

## Becoming a maintainer


You'll have to add yourself in the `maintainers.nix` list; your username should
match your `bsc.es` email. Then you can add yourself to the `meta.maintainers`
of any package you are interested in maintaining.

[1]: [https://github.com/NixOS/nixpkgs/tree/nixos-25.05/maintainers]
