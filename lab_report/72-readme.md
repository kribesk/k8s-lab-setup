
## Project Readme

_(Section by Boris Kirikov)_


### Prerequisites

 - At least two machines as cluster nodes, access to BIOS to change boot order
 - Private network for cluster (switch or bridge can be used, some switches may require extra configuration)
 - One Windows machine to boot cluster, with:
    * VirtualBox
    * Vagrant
    * Python + jinja2 + wol for config generation and wake on lan
 - 30-60 min depending on internet access speed

### Starting cluster

  1. Check private network, adjust boot order of nodes to boot from network first
  2. Often on power on NIC is turned off/on and that can be a problem with some switches, check that features like portfast are enabled on switch
     (For cisco switches see `config/S1.txt` example configuration)
  3. On Windows machine install required software
  4. Check that VirtualBox can create and run VMs (for example Hyper-V is disabled)
  5. Find MAC addresses of computers designated as cluster nodes (NIC used for private network)
  6. Edit `config.json` file: array `hosts` should contain description of every host: mac address, name, designated ip address. By default ip addresses
     should be from 172.18.0.0 network. 
  7. Run `python scripts/make_config.py` to generate configs
  8. Edit `build.cmd` to reflect your setup:
      - Change `S:` to letter of SSD drive or just use `C:`
      - Change `CISCO` to name of your NIC used for private network
  9. Edit `Vagrantfile`:
      - Change `S:` again
      - Change `Realtek...` to physical name of NIC used for private network
  10. Run `build.cmd`, check network again and wait a while
  11. Generate cluster certificates with `vagrant ssh` and `/vagrant/scripts/tls/k8s-certgen`. Generate ssh keys with `ssh-keygen` and save to 
      `sshekeys_dir` stated in `config.json`.
  12. Run `run.bat`
  13. Run `wake.cmd`, nodes should power on and start booting from network, process can take 10-15 min
  14. Run `SET KUBECONFIG=%cd%\config\assets\tls\kubeconfig` and `kubectl proxy`, now dashboard is available at `localhost:8001`

