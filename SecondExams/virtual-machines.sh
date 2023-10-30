#!/bin/bash


#initialize vagrant machine to pull a vagrant file
vagrant init

cat <<EOL > Vagrantfile
Vagrant.configure("2") do |config|
    config.vm.define "master" do |master|    
    master.vm.box = "spox/ubuntu-arm"
    master.vm.box_version = "1.0.0"
    master.vm.network "private_network", ip: "192.168.56.30"
    master.vm.hostname = "master"
    master.vm.provider "vmware_desktop" do |v|
      v.allowlist_verified = true
      v.ssh_info_public = true
        # v.gui = true
    end
    master.vm.provision "shell", inline: <<-SHELL
    # sudo mv /etc/apt/sources.list /tmp/
     sudo apt clean
     sudo apt update
     sudo apt upgrade
     sudo systemctl stop ufw

    SHELL
  end
    config.vm.define "slave" do |slave|
    slave.vm.box = "spox/ubuntu-arm"
    slave.vm.box_version = "1.0.0"
    slave.vm.network "private_network", ip: "192.168.56.31"
    slave.vm.hostname = "slave"
    slave.vm.provider "vmware_desktop" do |v|
      v.allowlist_verified = true
      v.ssh_info_public = true
        # v.gui = true
    end
    slave.vm.provision "shell", inline: <<-SHELL
    #  sudo mv /etc/apt/sources.list /tmp/
     sudo apt clean
     sudo apt update
     sudo systemctl stop ufw

    SHELL
  end
end
EOL

#bring up both machines
vagrant up master

vagrant up slave
