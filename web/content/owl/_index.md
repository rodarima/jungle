---
title: "Owl"
description: "Low system noise"
---

![Owl](owl.jpg)

Much like the silent flight of an owl at night, these nodes are configured to
minimize the system noise and let programs run undisturbed. The list of nodes is
`owl[1-2]` and are available for jobs with SLURM.

The contents of the nix store of the hut node is made available in the owl nodes
when a job is running. This allows jobs to access the same paths that are on hut
to load dependencies.

For now, only the hut node can be used to build new derivations so that they
appear in the compute nodes. This applies to the `nix build`, `nix develop` and
`nix shell` commands.
