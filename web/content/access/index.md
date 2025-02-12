---
title: "Enter the jungle"
description: "Request access to the machines"
---

![Cave](./cave.jpg)

Before requesting access to the jungle machines, you must be able to access the
`ssfhead.bsc.es` node (only available via the intranet or VPN). You can request
access to the login machine using a resource petition in the BSC intranet.

Then, to request access to the machines we will need some information about you:

1. Which machines you want access to ([hut](/hut), [fox](/fox), owl1, owl2, eudy, koro...)
1. Your user name and user id (to match the NFS permissions)
1. Your real name and surname (for identification purposes)
1. The salted hash of your login password, generated with `mkpasswd -m sha-512`
1. An SSH public key of type Ed25519 (can be generated with `ssh-keygen -t ed25519`)

Send an email to <jungle@bsc.es> with the details, or directly open a
merge request in the [jungle
repository](https://pm.bsc.es/gitlab/rarias/jungle/).
