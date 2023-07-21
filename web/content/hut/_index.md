---
title: "Hut"
description: "Control node"
date: 2023-06-13T19:36:57+02:00
---

![Hut](hut.jpg)

From the hut we monitor and control other nodes. It consist of one node only,
which is available at `hut` or `xeon07`. It runs the following services:

- Prometheus: to store the monitoring data.
- Grafana: to plot the data in the web browser.
- Slurmctld: to manage the SLURM nodes.
- Gitlab runner: to run CI jobs from Gitlab.

This node is prone to interruptions from all the services it runs, so it is not
a good candidate for low noise executions.
