---
title: Server Project Report
author: Boris Kirikov, Volodymyr Lubenets, T5615SN, XAMK
references:
- id: k8s-api
  type: webpage
  URL: https://kubernetes.io/docs/api-reference/v1.5/
  title: Kubernetes API Reference
- id: matchbox
  type: webpage
  URL: https://github.com/coreos/matchbox
  title: Matchbox repository on GitHub
- id: nfs
  type: webpage
  URL: https://help.ubuntu.com/lts/serverguide/network-file-system.html
  title: "Network File System (NFS) on ubuntu help"
- id: nat
  type: webpage
  URL: http://www.revsys.com/writings/quicktips/nat.html
  title: "Quick-Tip: Linux NAT in Four Steps using iptables"
- id: ingress
  type: webpage
  URL: "https://medium.com/@samwalker505/using-kubernetes-ingress-controller-from-scratch-35faeee8eca"
  title: Using Kubernetes Ingress Controller from scratch
- id: minikube
  type: webpage
  URL: http://blog.kubernetes.io/2016/07/minikube-easily-run-kubernetes-locally.html
  title: "Minikube: easily run Kubernetes locally"
- id: keycloak
  type: webpage
  URL: http://www.keycloak.org/
  title: Open Source Identity and Access Management
- id: keycloak-container
  type: webpage
  URL: https://hub.docker.com/r/jboss/keycloak/
  title: Keycloak Docker image
- id: vagrant
  type: webpage
  URL: https://www.vagrantup.com/intro/getting-started/
  title: "Vagrant: getting started"
- id: oslevel-virt
  type: webpage
  URL: "https://en.wikipedia.org/wiki/Operating-system-level_virtualization"
  title: "Operating-system-level virtualization"
- id: docker-net
  type: webpage
  URL: "https://docs.docker.com/engine/userguide/networking/"
  title: "Docker container networking"
- id: docker-swarm
  type: webpage
  URL: "https://docs.docker.com/engine/swarm/"
  title: "Swarm mode overview"
- id: docker-vs-k8s
  type: webpage
  URL: "https://platform9.com/blog/compare-kubernetes-vs-docker-swarm/"
  title: "Container Orchestration Tools: Compare Kubernetes vs Docker Swarm"
- id: docker-machine
  type: webpage
  URL: "https://docs.docker.com/machine/overview/"
  title: "Docker Machine Overview"
- id: docker-cli
  type: webpage
  URL: "https://docs.docker.com/engine/reference/commandline/cli/"
  title: "Use the Docker command line"
- id: docker-meta
  type: webpage
  URL: "https://docs.docker.com/engine/userguide/labels-custom-metadata/"
  title: "Docker object labels"
- id: docker-fs
  type: webpage
  URL: "https://docs.docker.com/engine/userguide/storagedriver/imagesandcontainers/"
  title: "Understand images, containers, and storage drivers"
- id: docker-repo
  type: webpage
  URL: "https://docs.docker.com/registry/"
  title: "Docker Registry"
- id: docker-native
  type: webpage
  URL: "https://docs.docker.com/docker-for-windows/"
  title: "Get started with Docker for Windows"
- id: docker-dockerfile
  type: webpage
  URL: "https://docs.docker.com/engine/reference/builder/"
  title: "Dockerfile reference"
- id: pxe
  type: webpage
  URL: "https://en.wikipedia.org/wiki/Preboot_Execution_Environment"
  title: "Preboot Execution Environment"
- id: docker-dockerd
  type: webpage
  URL: "https://docs.docker.com/engine/reference/commandline/dockerd/"
  title: "dockerd"
- id: docker-win-native
  type: webpage
  URL: "https://blog.docker.com/2016/09/build-your-first-docker-windows-server-container/"
  title: "Build and run your first Docker Windows Server container"
- id: alpine
  type: webpage
  URL: "https://alpinelinux.org/"
  title: "Alpine linux"
- id: ipxe-cmd
  type: webpage
  URL: "http://ipxe.org/cmd"
  title: "Command reference"
- id: bottle
  type: webpage
  URL: "https://bottlepy.org/docs/dev/"
  title: "Bottle: Python Web Framework"
- id: ipxe
  type: webpage
  URL: "http://ipxe.org/"
  title: "iPXE - open source boot firmware"
- id: ipxe-scripting
  type: webpage
  URL: "http://ipxe.org/scripting"
  title: "iPXE Scripting"
- id: dnsmasq
  type: webpage
  URL: "http://www.thekelleys.org.uk/dnsmasq/doc.html"
  title: "Dnsmasq"
- id: bootp
  type: webpage
  URL: "https://en.wikipedia.org/wiki/Bootstrap_Protocol"
  title: "Bootstrap Protocol"
- id: k8s_persistence
  type: webpage
  URL: https://kubernetes.io/docs/concepts/storage/persistent-volumes/
  title: K8s -- persistent volumes
- id: k8s_services
  type: webpage
  URL: https://kubernetes.io/docs/concepts/services-networking/service/
  title: K8s -- services and networking using services
- id: k8s_ingress
  type: webpage
  URL: https://kubernetes.io/docs/concepts/services-networking/ingress/
  title: K8s -- ingresses
- id: nginx_ingress
  type: webpage
  URL: https://github.com/kubernetes/ingress/blob/master/examples/aws/nginx/nginx-ingress-controller.yaml
  title: Nginx custom load balancer example
- id: coreos_supported_platforms
  type: webpage
  URL: https://coreos.com/ignition/docs/0.12.1/supported-platforms.html
  title: CoreOS-compatible platforms
- id: coreos_ignition
  type: webpage
  URL: https://coreos.com/ignition/docs/latest/what-is-ignition.html
  title: CoreOS: what are ignition configs
- id: coreos_rkt
  type: webpage
  URL: https://coreos.com/rkt
  title: CoreOS: what is rkt
- id: coreos_etcd
  type: webpage
  URL: https://coreos.com/etcd
  title: CoreOS: what is etcd
- id: wiki_k8s
  type: webpage
  URL: https://en.wikipedia.org/wiki/Kubernetes
  title: Kubernetes on wikipedia
- id: wiki_cluster_manager
  type: webpage
  URL: https://en.wikipedia.org/wiki/Computer_cluster#Cluster_management
  title: Cluster manager software on wikipedia
- id: k8s_design_doc
  type: webpage
  URL: https://github.com/kubernetes/community/blob/master/contributors/design-proposals/architecture.md
  title: Kubernetes design and architecture
- id: k8s_kubectl
  type: webpage
  URL: https://kubernetes.io/docs/user-guide/kubectl-overview/
  title: Kubectl management tool overview
- id: hypervisor_vs_container
  type: webpage
  URL: http://www.slashroot.in/difference-between-hypervisor-virtualization-and-container-virtualization
  title: Hypervisor-based virtualization compared to containerized one
- id: wiki_hypervisor
  type: webpage
  URL: https://en.wikipedia.org/wiki/Hypervisor
  title: Hypervisor on wikipedia
notice: |
  @k8s-api, @matchbox
csl: ieee-security-and-privacy.csl
link-citations: true
linkReferences: true
autoSectionLabels: true
numberSections: true
---



_All sources referenced in this report can be found on github: [k8s-lab-setup](https://github.com/kribesk/k8s-lab-setup)._

