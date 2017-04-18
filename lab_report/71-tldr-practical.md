## TL;DR -- what is the practical goal of the project and what we have done

_(Section by Volodymyr Lubenets)_

In this section I would like to introduce the practical part of our project by first providing its goals (and, well, clarify the presentation).

Here it is:

> To automate process of building the configuration, testing and deploying the kubernetes cluster to the existing bare metal server infrastructure represented by 3 MB316 machines

To make it clear, our goal implied building the infrastructure (what, as we see it, is exactly advanced **server** development project) rather than building the service.

### The used software stack

When considering some software running in together on several machines, it is essential to provide the automation for configuring and managing these machines. So, we have built a stack which performs needed tasks.

* Wake-on-LAN script -- to physically start the machines of the cluster.
* Dnsmasq (DHCP + DNS + TFTP server) -- network configuration automation + initial PXE chainload configuration. Containerized, can be later deployed to cluster.
* PXE & iPXE -- network boot agents. iPXE is capable of working with various protocols, including HTTP.
* Matchbox -- the HTTP server which is responsible for delivering the required CoreOS version and configs to the booting machine.
* CoreOS -- Linux distribution supporting containerization and k8s, can be configured with Ignition Configs

All the software needs the configuration files, which also need the unique parameters of machines (i.e. MAC addresses) along with desired configuration for the future cluster nodes.

To automate the process of writing configs, we have built the templating script based on python-jinja2 templating engine.

As the cluster needs management, we have used two tools for it:

* SSH -- for direct node management (read: low-level to the extend of Linux su console)
* Kubectl -- for the cluster control (i.e. making and managing deployments, doing cluster-wide configurations)

We have successfully written the set of scripts to deploy k8s environment by several single commands to the machines.
A bit trickier was to configure shared storages and networking inside the cluster, though we have completed this part.


