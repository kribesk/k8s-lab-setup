
## Starting matchbox on Windows host

_(Section by Boris Kirikov)_

It is recommended to use matchbox and dnsmasq as containers (later it can even run on k8s cluster providing configurations for new machines).

### Why can not use native Docker

Our first attempt was to use native windows docker for running these containers. Windows docker is a native application, but applications still need linux kernel.
That kernel runs in virtual machine and the only supported provider is HyperV. Docker itself configures it: creates VM and virtual switch. 

Docker has it's own mechanisms to expose services to outside (see [@sec:docker-net]), but not all of them are already supported on Windows.
The main problem is DHCP server can not work properly in docker container in Windows. Linux way to run it is `--cap-add=NET_ADMIN` option. Another solution
would be to expose the whole docker VM by changing virtual switch to external. 

The first way is not currently supported, the second breaks Docker's internals.

### Vagrant + VBox

Vagrant is a powerfull development and testing tool for describing VM setups as configuration files. It supports a lot of VM and cloud providers.
VirtualBox is free, open source, simple and yet powerful and feature-rich VM provider. It works smoothly on Windows and is fully supported by Vagrant.

__Note:__ VirtualBox requires Hyper-V be turned off.

Required software (Windows versions):

  * __Vagrant__ can be downloaded from [here](https://releases.hashicorp.com/vagrant/1.9.2/vagrant_1.9.2.msi)
  * __VirtualBox__ can be downloaded from [here](http://download.virtualbox.org/virtualbox/5.1.18/VirtualBox-5.1.18-114002-Win.exe)

This is the recommended configuration. Other host platforms (Linux, macOS) and virtualization providers (KVM, VMware) or cloud can be used.

__Note:__ With the latest version of Vagrant and VirtualBox for Windows there is a bug (newer vbox provides long path suffix itself), this can be fixed by
`/lab_setup/platform.patch` (`/lab_setup/platform.cmd` applies this patch if `patch.exe` is in path).

`build.cmd` script also does several preparations before starting VM:

  - using SSD for VMs can make everything work faster, so disk `S:` is used both to store VirtualBox VMs and CoreOS image
  - if coreos image is present in project folder, it is coppied, otherwise it is downloaded in provisioning script
  - VM uses bridge adapter. Script preconfigures adapter to be used as bridge. The same adapter should be set in
    Vagrantfile, but VBox uses physical name, while netsh uses logical name. We are using CISCO adapter on matchbox host

Before starting vm, script asks to check that cable is connected to chosen adapter, otherwise vagrant can not bridge to it.

We used cisco switch to build isolated network for our cluster. Configuration of switch can be found in `config/S1.txt`. It can be uploaded via serial connection
and suited many models of modern cisco switches.

__Note:__ WOL is only supported on Intel NICs on MB316 computers, that's why we connected switch to general network (white cables) ports. Also changin boot order for
WOL is needed to boot it from network instead of HDD.

After preparations script starts vagrant. The base box image is downloaded automaticly if it is not present, VM settings from Vagrant file are applied and machine is
booted. After that provisioning though shell script is started:

  - Docker and NFS server are installed
  - CoreOS image is downloaded if not present to folder mounted to SSD (`S:`)
  - Docker matchbox and dnsmasq containers are downloaded
  - Network (bridged) is configured staticly
  - NAT is implemented with iptables (NAT is required because cluster nodes need internet connection to download docker and rkt images)
  - NFS server is configured and started (NFS is required to provide cluster with some persistent storage, in production more complex and reliable solutions should be used)

If provision finished without errors, VM is ready and the next step is to run containers. `run.cmd` is used to run/restart both matchbox and dnsmasq with all required
parameters.

The simple way to check if dnsmasq is running is to run `ipconfig /release CISCO` and `ipconfig /renew CISCO` on Windows host (where CISCO is the name of bridged adapter,
remember `build.cmd` set it to DHCP mode and now it should get DHCP lease from dnsmasq container). After that to check that matchbox is running, `curl` or open in 
web browser `http://matchbox.example.com`.

