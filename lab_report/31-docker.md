
## Docker

_(Section by Boris Kirikov)_

__Docker__ is a group of technologies and programs that introduce container, allow running containers, storing and managing them.

### Containers

Keeping service __installations inside VMs__ become is very convenient way for deployment:

  * If it works on developers machine, than it will work the same way everywhere
  * Compilation, building, compilation, packaging, installation, configuration and other processes that form the way from development to
    production are simplified and done always in the same environment.
  * Environment becomes part of the deployment
  * Build systems and package managers often can help providing dependencies, but they are often limited to one platform (Java - Maven,
    Python - Pip, JS - Npm)
  * And all the deploy is contained in one file: VM drive image

But VMs are typically rather big containing a lot of components for different use-cases: complete kernel, variety of drivers, libraries, 
user-space utils and basic services. This means a lot of overhead when packaging service or application with it's own operating system.

This lead to idea of minimizing overhead of base images. Surely the base image only needs kernel, drivers used by VM solution, network 
services and management tools. Of cause, para-virtualization can be used. And so on.

The extreme of this idea is __OS-level virtualization__ and containers. In this case there is no computation overhead and no extra kernel, 
because instances use directly the host's kernel. Of cause host should support this feature. 

The simplest implementation of this idea is UNIX chroot that basically just isolates fs sub-tree. So it is not a secure solution. Another 
classic solution is FreeBSD jail, that provides much more isolation and adds management features.

Nowadays Docker is very popular and widely supported solution for OS-level virtualization. And kubernetes can use docker as container
driver.

### Images and containers

The two basic concepts of docker that should not be messed up are images and containers. An image is like virtual drive for VMs. It is
file system. Container is like VM instance. It is application that has state and was booted from some container.

### Metadata

Docker (and kubernetes too) use "attached dictionaries" of metadata for simplifying and automation of management. This means that to 
objects (images, containers, volumes, networks, etc) labels can be attached. Label is basically a key-value pare of two strings, that 
can be tags, version/author information, scope or just everything. 

For docker there are guidelines for using labels. Because docker images are way to distribute software and are mostly used by third-party
users, namespace conventions for labels are suggested. They work like packages in java: reverse DNS notation of owned domain dot key name.

### Layered FS

One of the reasons why docker became so popular is that it works with containers like git with repositories. Instead of storing complete
disk images it stores versions of images as difference layers. It minimizes use of storage and network, allows keeping different versions
and quickly update images from registers.

The Docker storage driver stacks diff layers and provide a single unified view. When changes happen, they are written to the new layer on
top of existing image.

### Registry and repository

When comparing docker to git, there are repositories and registries. Repository contains different versions in tree of layers of image,
just like git contains code in tree of commits. Registry is a place that keeps repositories, just like GitHub. Examples of public
registries are Docker Hub, Quay, GCR and AWS Container Registry. Just like git, docker enumerates versions with hashes and have tags 
pointing to specific versions.

### Docker daemon

Docker uses server-client model. Server is docker daemon, dockerd. And client may be a CLI application `docker` or compose (see later)
etc. So dockerd is the service that runs containers. It provides REST API for communication with clients. There are different ways of
running dockerd: as a standalone program, as systemd service and even as a windows service. Also different channels can be selected for
communication: by default unix sockets are used, but tcp can also be used.

### Docker and Windows

Docker is designed for Linux based systems, but it is also available for Windows and Mac OS. This is possible because virtualization.

__Docker Machine__ is a tool for installing and using Docker on virtual hosts. This does not limit to running Docker on other platforms
but also allows to use it in data centers or with cloud providers. `docker-machine` CLI is used to install and control docker daemon
on virtual hosts.

Modern way of installing Docker for Windows is not Docker Machine, but the idea is still the same. VM with Linux  is created
and CLI is used for hosting containers. The great difference is that dockerd is now windows native application, but still Linux kernel
([Alpine Linux](https://alpinelinux.org/) distribution aka MobyLinuxVM) is used. And Docker for Windows features nice installer 
and some GUI tools for configuration.

Also recently appeared option to run windows native containers. That means running windows applications inside native containers without
any extra virtualization.

The only virtualization platform currently supported for Windows is Hyper-V. That means Hyper-V feature should be enabled on computer.
To enable it:

  1. Log in as administrator
  2. Go to Control Panel -> Programs -> Turn Windows features on and off -> Enable Hyper-V Platform. Enabling management tools is not
     required but it simplifies troubleshooting process if something goes wrong
  3. Reboot the computer (reboots twice)

After that Docker for Windows can be downloaded from official [download page](https://download.docker.com/win/stable/InstallDocker.msi)
and installed. After that in Hyper-V management console new VM appears.

Docker allows to copy files (often configurations) to container's RW layer. This is often convenient and needed to correctly run 
some containers. Because files should be copied from host's FS to VM first, there should be file sharing enabled. This can be done in
Docker GUI settings.

### Docker CLI

Basic commands are:

  * `docker pull <repository>` to download repository from registry
  * version or tag can be specified as `<repository>:<tag>`
  * changing tag: `docker tag <repository> <new_repository>`
  * `docker ps` list containers
  * `docker rm <container>` delete container
  * `docker images` list images
  * `docker rmi <image>` delete image
  * `docker run --name <container> <repository>` run container from repository. Options:
    * `-p <port>:<map>` map port to local port
    * `-v <path>:<path>` map local file to container
    * `-e <key>=<value>` set environment variable
    * `--network <net>` connect to network
  * `docker attach <container>` attach to running container
  * `docker exec -it <container> bash` run bash in container
  * `docker logs <container>` get logs for container
  * `docker stop <container>` and `docker <kill> container`
  * `docker network ls` to show networks
  * `docker network inspect  <net>` to get information about network
  * `docker network create --driver <driver> <net>`


### Networking

Networking in docker is more complicated than it could be because of legacy features. Docker has built-in networks: `bridge`, `host` and
`none`. And also allows user-defined networks: `bridge`, `docker_gwbridge` and `overlay`. Connecting containers to none networks means running 
them without interfaces except loopback. Connecting to host network means using the same network as host.

Built-in bridge (interface `docker0` of the host) and user-defined bridge create new virtual internal network, sets subnet and gateway.

Built-in bridge is a legacy bridge and it does not support discovery, but support links. Before networking there were to network 
mechanisms for containers: binding ports to host (exposing service) and links. Link create tunnel from one container to another and 
provides connection information with environmental variables and entry in hosts file. 

User defined bridges do not support links. Containers added to network can immediately connect to other containers. Discovery 
for user defined bridges is provided by built-in DNS server.

`docker_gw` network is created and connected automatically if container does not have external network/internet connectivity. `overlay` 
networks are used in swarm mode and overlay cluster network.


### Swarm

Swarm is another relatively-new feature of Docker that is basic cluster management. It's list of features is quite similar to kubernetes's,
including: cluster networking and DNS, load balancers, scaling and self-maintenance according to declarative specifications. 

Swarm allows to use cluster as one big docker engine, while Kubernetes has much more complex structure. Swarm has the same API as
docker. Load balancing, grouping and exposing is done by another piece of software called Compose.

Detailed comparison of Swarm and Kubernetes can be found [here](https://platform9.com/blog/compare-kubernetes-vs-docker-swarm/).


### Example: running Keycloak


This example shows how to run Keycloak in docker container in MB316.

~~~~~
docker pull jboss/keycloak
docker run --name keyserver -p 0.0.0.0:8081:8080 -d -e KEYCLOAK_USER=admin -e KEYCLOAK_PASSWORD=admin jboss/keycloak
~~~~~

The service will be available on `http://localhost:8081/`

