# Ansible

[doc reference](https://docs.ansible.com/ansible-core/devel/index.html)

1. Launch a server with the custom AMI we have created with packer(`ansibleadmin` as user) and add assume role to this instance.

2. Install the ansible controller with the following commands

    --$ sudo apt update
    --$ sudo apt install software-properties-common
    --$ sudo add-apt-repository --yes --update ppa:ansible/ansible
    --$ sudo apt install ansible

Ansible controller can't able to run on windows natively and we can only use winows as a ansible clinet which means we can configure windows as a client machine, though there is concept called WSL(Windows Subsystem for Linux). All the coonections between controller and client uses `SSH` connection

![Ansible Controller Support](https://github.com/ModernVishwamithra/DevOps/blob/main/Ansible/images/ansible-controller.png)

3. Once the installation is done, validate installation by running `ansible --version` command. It shows the ansible configured paths.

4. Ansible configuration file is present in this path `/etc/ansible/ansible.cfg`, by default this file has so many parameters and are in disabled state. We need to enable required parameters, but to edit them we need to unlock the ansible.cfg file(by default it is disbaled) it by running the following command ` ansible-config init --disabled > sudo /etc/ansible/ansible.cfg` we have unlocked it. **Run the above command as root user (sudo su -)**

5. Type `sudo nano /etc/ansible/ansible.cfg` and press `ctl+w` to search the term `host_key_checking`, when you found it by default it is in commented(;) and its value is 'True'. We need to make its value 'False' and uncomment it by removing semicolon(;) infront of it.

6. Similarly search for `remote_user`, uncomment it and set the value as `ansibleadmin`. By setting this value "Ansible controller" connects with the client with this username.

7. Now install `unzip` and [Terraform](https://developer.hashicorp.com/terraform/downloads) binary amd64, unzip it,move the binary to /usr/local/bin and delete the downloaded zip file.

8. Create `local_files.tf` and `template.tpl` files, which we already used them in the terraform provisioners. This creates `invfile` that consists of all the public ip's of the instances.

9. In the 'Ansible controller' we need to use terraform to deploy instances(ansible clients) and connect them to ansible controller.

10. Write the terraform code to deploy 3 instances with the custom AMI ID(which was created for packer) and push to github.