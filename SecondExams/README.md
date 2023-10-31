# Setting up two Ubuntu-based servers, named “Master” and “Slave”, using Vagrant.

First step to take is to create the directory where you want your script to run and cd into that directory, then create a file to store your script for example <span style="color: red;">vagrant.sh</span>

Open the file with a text editor (nano or vim)

add your shebang (every bash script begins with a shebang line)

initialize a vagrant environment to pull a vagrantfile by running vagrant init

![img](/SecondExams/pngs/intial.png)

Next using herdoc to edit the vagranfile to configure two machines.

![img](/SecondExams/pngs/box-creation.png)

In the picture, the hostname was given which is the name of the machine, the box was specified and the network was set also the master has a network type dhcp while the slave was given a static ip address

then vagrant up to bring up the two machines.

# Machine Configuration

## Master

Hostname: Master

IP Address: "192.168.56.30"

## Slave

Hostname: slave

IP Address: "192.168.56.31"

Provisioning: Ansible playbook (playbook.yaml)
