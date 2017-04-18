## Preparing configs

_(Section by Volodymyr Lubenets)_

### Lab address and naming schema

We have used pseudo-static IP addressing (IP addresses are predefined by mapping MAC to IP in the DHCP config).

Here is the schema:

* Outer cluster network (physical NIC addresses of the machines) is 172.18.0.0/24.
* DNS/DHCP/Matchbox server (Vagrant VM) resides at 172.18.0.2
* Cluster nodes reside at range 172.18.0.21-24, addresses are given by MACs predefined in config (see the subsection *"Config generator utility"*).
* Test machines are assigned an address by DHCP from pool 172.18.0.50-172.18.0.254

DNS naming convention is %NODE_NAME%.example.com, specifically:

* %NODE_NAME% for the nodes is defined in main generator utility's config.  
By convention, nodes are named nodeN, where N is an ascending number.
* matchbox.example.com is the address of the Matchbox server (vagrant VM).
* cluster.example.com is the alias for the master node record. By default master node is node1 (*"Config generator utility"*), though the master directive can be assigned to any other node.

### Matchbox configs schema

Matchbox is an utility to provide specific OS files and configurations by HTTP request. The use case is simple -- if one wants to boot a number of machines by network (iPXE), each needs a unique config (at least, hostname and SSH keys to access it remotely, also k8s configuration data in our case).

Below is the `tree config/` command output limited to only Matchbox-related configs.

```
config
├── assets
│   ├── coreos
│   │   └── 1235.9.0
│   │       ├── coreos_production_pxe.vmlinuz
│   │       └── coreos_production_pxe_image.cpio.gz
│   └── tls
│       ├── admin.csr
│       ├── admin-key.pem
│       ├── admin.pem
│       ├── admin-req.cnf
│       ├── apiserver.csr
│       ├── apiserver-key.pem
│       ├── apiserver.pem
│       ├── apiserver-req.cnf
│       ├── ca-key.pem
│       ├── ca.pem
│       ├── kube-admin.tar
│       ├── kube-apiserver.tar
│       ├── kubeconfig
│       ├── kube-worker.tar
│       ├── worker.csr
│       ├── worker-key.pem
│       ├── worker.pem
│       └── worker-req.cnf
├── groups
│   ├── node1.json
│   ├── node2.json
│   └── node3.json
├── profiles
│   ├── k8s-controller.json
│   └── k8s-worker.json
└── ignition
    ├── k8s-controller.yaml
    └── k8s-worker.yaml
```

In here, we can see five directories which are related to Matchbox. Let's explain them with a list:

* /assets -- the directory containing TLS certificates for the nodes to communicate inside the cluster securely and the coreOS images for the server to provide on request from booting machines  
* /groups -- each nodeN file contains a profile link and the metadata. Metadata defines the environment variables needed for the etcd cluster to get running and share configuration among other machines (+ ssh keys to access the machine). There is the file for each node. *Summary: MAC to profile mapping*  
* /profiles -- a profile defines which version of the coreOS (found in assets/coreos directory) to provide to the machine depending on its role. Other than that, the profile augments the image with the kernel parameter of the link where to get an *"ignition config"*, which will be fetched and applied to the machine during booting process. Profiles are separated by roles in the cluster (here controller and worker nodes). *Summary: profile to ignition config mapping*  
* /ignition -- the *"Ignition configs"* are the boot time provisioning instrument. In here, it is possible to allocate storage for the system (i.e. ramdisk or HDD partition), download and launch needed services etc. *Summary: boot-time provisioning file*  

One more time summary of the boot process:

1. iPXE request the OS files
2. Request contains MAC
3. Matchbox finds the Group by MAC
4. Matchbox finds Profile by Group
5. Matchbox reads Ignition config name from the Profile and embeds the link to it as a kernel parameter to the image
6. OS file is sent back to requesting machine
7. At the boot time the ignition config is requested by the CoreOS from Matchbox

### Config generator utility

As there are only two roles of the nodes in the cluster (i.e. controller and worker roles), there is no need to write the specific configuration for all the machines. Though, the Group file is resolved by MAC address, along with the Metadata in it.

So, the group files should be constructed based on domain name, IP, MAC and role of the node. The same situation is with the dnsmasq (DNS and DHCP) server -- the node domain names should follow the naming convention.

It has sense to locate this data in a simple json and make the whole config tree based on this data generated automatically.

That is exactly what our script does. It uses the file below and the /templates directory to build the configs by utilizing python-jinja2 templating engine.  
The file depicts the default cluster addressing/naming schema and the directories containing ssh keys, group and dns config templates etc.

**config.json**
```json
{
  "hosts": [
    {
      "mac": "6c:3b:e5:37:cd:75",
      "name": "node4",
      "ip": "172.18.0.24",
      "disabled": true
    },
    {
      "mac": "6c:3b:e5:39:c5:aa",
      "name": "node2",
      "ip": "172.18.0.22"
    },
    {
      "mac": "6c:3b:e5:37:cd:a8",
      "name": "node3",
      "ip": "172.18.0.23"
    },
    {
      "mac": "6c:3b:e5:37:cd:62",
      "name": "node1",
      "ip": "172.18.0.21",
      "master": true
    }
  ],
  "template_dir": "./templates",
  "config_dir": "./config",
  "sshkeys_dir": "./config/sshkeys"
}

```

See `scripts/make_config.py` for the code.


### WOL, SSH, shutdown helpers

We have written a set of helper tools to ease our management of the cluster and startup server launching. Files are found in the root directory of the repo.

Scripts are written in Windows shell (often wrapping python call).

Tools for managing DNS/DHCP/Matchbox initial server:

* build.cmd -- builds the vagrant VM, downloads needed packages, reconfigures network interfaces for bridging
* run.cmd -- loads the containerized dnsmasq and Matchbox servers, embeds configs into them
* clean.cmd -- removes any trace of the environment

Tools for managing the cluster nodes

* wake.cmd -- wakes-on-lan the machines by MACs in config.json
* node-ssh.cmd -- alias for ssh -i "keyfile" %NODE_NAME%.example.com
* shutdown.cmd -- shuts down the node

