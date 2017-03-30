# -*- mode: ruby -*-
# vi: set ft=ruby :

disk = './lfs.vhd'

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/yakkety64"
    config.vm.box_check_update = false

    config.vm.hostname = "matchbox"
    config.vm.network "public_network", bridge: "Realtek PCI GBE Family Controller"
    config.vm.provision "shell", path: "provision.sh"
    config.vm.synced_folder 'S:/coreos', '/vagrant/config/assets/coreos', type: "virtualbox"


    config.vm.provider "virtualbox" do |vb|
      vb.name = "matchbox"
      vb.memory = "1024"
      vb.customize ["modifyvm", :id, "--uartmode1", "disconnected"]
    end

end
