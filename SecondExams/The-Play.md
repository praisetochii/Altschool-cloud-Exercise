# Ansible Playbook: Deploy LAMP Stack and Configure Cron Job

This Ansible playbook automates the deployment of a LAMP (Linux, Apache, MySQL, PHP) stack on a target server with IP address 192.168.20.12. It also sets up a cron job to check the server's uptime every day at 12 am.

## Prerequisites

Ansible installed on host machine

Access to a server with the IP address 19.168.56.30

Necessary permissions to execute tasks on the target server.

## Run the Ansible Playbook:

Execute the playbook on the slave machine using the following command:

![alt](/pictures/ansible-provision.png)

add the playbook in your configuration file ot slave machine.

Upon succesful completion, the site should look like the picture below when you visit with our ip address.

![alt](/SecondExams/pngs/blade.png)
