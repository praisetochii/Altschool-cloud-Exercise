#!/bin/bash

#assign variables
file="Vagrantfile"

#create a directory where the script will be executed
mkdir -p ~/vagranttask

#Change directory to the directory you created
cd ~/vagranttask

#initalize vagrant to pull a vagrantfile
vagrant init bento/ubuntu-20.04-arm64

#delete the last line of the file and edit the file
sed -i '$ d' Vagrantfile

#EDIT THE VAGRANT FILE TO ADD MASTER AND SLAVE

#multi-machine setup
#setup master
cat << EOL >> $file

config.vm.define "master" do |subconfig|
 master.vm.box = "bento/ubuntu-20.04-arm64'"
 master.vm.hostname = "Oga"
 master.vm.network "private_network", type: "dhcp"
 master.vm.provider "vmware_fusion" do |v|
end
EOL

#setup slave

cat << EOL >> $file

config.vm.define "slave" do |subconfig|
 slave.vm.box = "bento/ubuntu-20.04-arm64'"
 slave.vm.hostname = "BoyBoy"
 slave.vm.network "private_network", type: "dhcp"
 master.vm.provider "vmware_fusion" do |v|
end
end
EOL

#bring up the machines
vagrant up

#create a user 'altschool and grant root priveleges
vagrant ssh master -c "sudo useradd -m -s /bin/bash -G sudo altschool"

#adding altschool to sudoers file
vagrant ssh master -c 'echo -e "\naltschool ALL=(ALL:ALL) NOPASSWD: ALL\n" | sudo tee -a /etc/sudoers'

#adding password
vagrant ssh master -c 'echo -e "12345\n12345" | sudo passwd altschool'

#create ssh key for master node as altschool user
vagrant ssh master -c "sudo -u altschool ssh-keygen -t rsa -b 2048 -f /home/altschool/.ssh/id_rsa -N ''"

#get the ip address of slave
slave_ip=$(vagrant ssh slave -c "ip addr show enp0s8 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'" | tr -d '\r')

#set up ssh config for slave hostname in master
vagrant ssh master -c "sudo -u altschool bash -c 'echo -e \"Host slave\n\tHOSTNAME $slave_ip\n\tUser vagrant\" > ~/.ssh/config'"

#you can now ssh into the slave from the machine using
#ssh slave. or access the slave machine via just slave

#copy public key from master to authorized keys in slave
vagrant ssh master -c "sudo -u altschool cat /home/altschool/.ssh/id_rsa.pub" | vagrant ssh slave -c "cat >> ~/.ssh/authorized_keys"

#create content in altschool master
vagrant ssh master -c "sudo -u altschool sudo mkdir -p /mnt/altschool"

vagrant ssh master -c "sudo -u altschool sudo touch /mnt/altschool/newfile /mnt/altschool/oldfile /mnt/altschool/ranfile"

#make directory in slave
vagrant ssh slave -c "sudo mkdir -m 777 -p /mnt/altschool/slave"

#move content to slave from master
vagrant ssh master -c "sudo -u altschool scp -o StrictHostKeyChecking=no -r /mnt/altschool/* slave:/mnt/altschool/slave"

#print running process for both nodes
echo -e "\nMaster Node Running Processes\n===================="
vagrant ssh master -c 'sudo -u altschool ps' 

echo -e "\nSlave Node Running Processes (captured from master node)\n====================="
vagrant ssh master -c 'sudo -u altschool ssh slave ps'

#lamp stack deployment
cat <<EOL > ampinstall.sh
#!/bin/bash
#update packagge list
sudo apt-get update

#install apache server
sudo apt-get install apache2 -y

#enable apache to start on boot
sudo systemctl enable apache2

#start apache
sudo systemctl start apache2

#install mysql server
sudo apt-get install mysql-server -y

#secure mysql installation
sudo mysql_secure_installation <<EOF

n
y
y
y
y
EOF

sudo mysql -u root -p"root" <<MYSQL_SCRIPT
CREATE DATABASE newdb;
CREATE USER 'ToGod'@'localhost' IDENTIFIED BY 'Chukwudume';
GRANT ALL PRIVILEGES ON newdb.* TO 'ToGod'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

#install php
sudo apt-get install php libapache2-mod-php php-mysql -y

#create a test php file
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/info.php

#restart apache to apply changes
sudo systemctl restart apache2
EOL

#give altschool dir all access
vagrant ssh master -c "sudo chmod ugo+w /home/altschool"

#run script on master and slave node
cat ampinstall.sh | vagrant ssh master -c 'sudo -u altschool sudo cat > /home/altschool/ampinstall.sh && sudo -u altschool sudo chmod 777 /home/altschool/ampinstall.sh'
vagrant ssh master -c 'sudo -u altschool scp /home/altschool/ampinstall.sh slave:~/'

vagrant ssh slave -c "sudo chmod 777 ~/ampinstall.sh"

#remove access
vagrant ssh master -c "sudo chmod go-w /home/altschool"

#remove file
rm -rf ampinstall.sh

vagrant ssh master -c "sudo -u altschool /home/altschool/ampinstall.sh"

vagrant ssh slave -c "~/ampinstall.sh"

echo -e "======================================================\n\n\nThe End\n\n\n================================================="