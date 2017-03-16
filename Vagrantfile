# -*- mode: ruby -*-
# vi: set ft=ruby :

disk = './lfs.vhd'

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/yakkety64"

    config.vm.provider "virtualbox" do |vb|

      vb.memory = "1024"

    end

    config.vm.network "public_network", bridge: "CISCO"
    config.vm.provision "shell", path: "provision.sh"

end
