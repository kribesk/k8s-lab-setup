
## CoreOS {#sec:coreos}

_(Section by Volodymyr Lubenets)_

### What is it?

CoreOS is a linux distribution adapted to be used as an OS for a cluster node, particularly the cluster managed by kubernetes platforms and using docker
container approach.

CoreOS distribution differs from classical desktop or server dramatically. It possesses special features which make OS-level virtualization easy and 
possible. Let's take a look on them.

### Special features of CoreOS

* No package manager used. CoreOS is designed to just provide its kernel to virtualized containers, so the native software set of the distribution is not
supposed to be dynamically modified.
* Uses rkt as built-in container runtime. This is a linux native container runtime developed by CoreOS team, which uses linux kernel instruments such as cgroups and namespaces instead of Docker approach (btw, it was used here previously too) [@coreos_rkt]
* Has a special built-in daemon etcd, which was described in *"Kubernetes"* section. Keeping short, it is a program which gets the configs from cluster-wide 
repo and can write to the shared cluster storage dynamically. Other than that, etcd is responsible for service discovery feature allowing other cluster 
members see and use the service running. [@coreos_etcd]
  
  * etcd also provides the HTTP API server which gets JSONs with commands from the orchestrator or can be also managed by its etcdctl

* Ignition and ignition configs. This is a feature which performs the kick-off configuration of the system on its boot. It is really the distinctive feature 
of CoreOS, so more info - in the section below.

### Ignition

The special thing about ignition is that it is executed in the early boot even before initramfs, so it is capable of doing 
such things, as:

* partitioning disks
* formatting partitions
* configuring users
* writing files
* writing network configuration

etc.

So, the point of using ignition is that you don't need to build each distribution for each cluster machine preconfigured and you may make a server which 
will distribute the initial configurations based on IP/hostname of the machine connecting. 
This can reduce the time of getting cluster to work significantly. [@coreos_ignition]

### Supported platforms

With CoreOS, you can build a cluster on practically any computational unit you have, disregarding is that bare metal device, VM possessed by Amazon, 
Google, or your on-site infrastructure or some dynamic number of machines connecting over the internet (PXE boot). [@coreos_supported_platforms]

Every platform will function the same way and it supports ignition configs.
