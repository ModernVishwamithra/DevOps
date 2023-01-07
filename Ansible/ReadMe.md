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

4. Ansible configuration file is present in this path `/etc/ansible/ansible.cfg`, by default this file has so many parameters and are in disabled state. We need to enable required parameters, but to edit them we need to unlock the ansible.cfg file(by default it is disbaled) it by running the following command ` ansible-config init --disabled > /etc/ansible/ansible.cfg` we have unlocked it. **Run the above command as root user (sudo su -)**

5. Type `nano /etc/ansible/ansible.cfg` and press `ctl+w` to search the term `host_key_checking`, when you found it by default it is in commented(;) and its value is 'True'. We need to make its value 'False' and uncomment it by removing semicolon(;) infront of it.

6. Similarly search for `remote_user`, uncomment it and set the value as `ansibleadmin`. By setting this value "Ansible controller" connects with the client with this username.

7. Now install `unzip` and [Terraform](https://developer.hashicorp.com/terraform/downloads) binary amd64, unzip it,move the binary to /usr/local/bin and delete the downloaded zip file.

8. In vscode, Create `local_files.tf` and `template.tpl` files, which we already used them in the terraform provisioners. This creates `invfile` that consists of all the public ip's of the instances.

9. In the 'Ansible controller' we need to use terraform to deploy instances(ansible clients) and connect them to ansible controller.

10. Write the terraform code to deploy 3 instances with the custom AMI ID(which was created for packer) and push to github.

11. Generate rsa_pub key using `ssh-keygen` and add that key in the github keys. Clone the repository in the `Ansible controller server` and run the terraform commands `fmr`, `validate`, `plan`, `apply`. 

12. Once infrastructure is deployed, we can observe that a `invfile` is created locally in the `ansible controller` server, if we read that file we can see the public ip's of all the 3 instances.
{
    [allservers]
    ansibleclient01 ansible_port=22 ansible_host=3.15.2.170
    ansibleclient02 ansible_port=22 ansible_host=18.221.99.135
    ansibleclient03 ansible_port=22 ansible_host=18.224.39.155
}

13. Now `Ansible controller` needs to connect to it either individually or all at time. To do that we run a command 
**`ansible -i invfile allservers -m ping`**. Instead of connecting it throws an error for all 3 instances

------
    ansibleclient01 | UNREACHABLE! => {
        "changed": false,
        "msg": "Failed to connect to the host via ssh: Warning: Permanently added '3.15.2.170' (ED25519) to the list of known hosts.\r\nansibleadmin@3.15.2.170: Permission denied (publickey).",
        "unreachable": true
    }
-----

{
    Refer this link to [Manage Mulple SSH keys](https://www.freecodecamp.org/news/how-to-manage-multiple-ssh-keys/)

    git 2.10 or later, to support multiple ssh keys configure git with new key using the following command

    --eval $(ssh-agent) 
        -everytime server reboots this ssh-agent service is stopped, we need to restart it by running this command
    
    --ssh-add ~/.ssh/your_custom_generated_private_key
        -Add your custom private key to the agent
        Now try to run git commands it has to work,otherwise run the following command

    --git config core.sshCommand 'ssh -i ~/.ssh/id_rsa_corp'


}

`ansible -i invfile allservers -m ping`
    --To run ping on [allservers] group

`ansible -i invfile webservers -m ping`
    --To run ping on [webservers] group only

`ansible -i invfile dbservers -m ping`
    --To run ping on [dbservers] group only

`ansible -i invfile appservers -m ping`
    --To run ping on [appservers] group only

`ansible -i invfile all -m ping`
    ----To run ping on all servers
### Ansible adhoc commands

`ansible -i invfile webserver -a uptime` (Here -a represents arguments)
--This command gets the `uptime` of the webservers only, similary `free` gets you memory usage details

`ansible -i invfile ansibleclient03 -a "cat /etc/passwd"`
--In the "" we can given shell commands to run on targeted clinet/or group of clients/or on all clients
-----

Ansible supports modules, which are nothing but pre-defined libraries. [Ansible modules reference](https://docs.ansible.com/ansible/2.9/modules/list_of_all_modules.html)

--Lets take an example to create a user in host machines, for that go to ansible modules --> System modules --> User Module. Then type this command 

    --ansible -i invfile allservers -m user -a "name=testuser state=present shell=/bin/bash"

It will throw error that permission denied(admin/sudo access is required). To give sudo permisiions add `--become` at the end of the command(its is like sudo su -)

    --ansible -i invfile allservers -m user -a "name=testuser state=present shell=/bin/bash" --become

Similarly test the user created or not by running the following command

    --ansible -i invfile allservers -a "cat /etc/passwd" --become

Similarly delete the user by running the following command

    --ansible -i invfile allservers -m user -a "name=testuser state=absent shell=/bin/bash" --become

-----

But to install softwares, running multiple commands at a time in the hosts we need to use a concept called `ansible-playbooks`. This is a file in which we use commands/keywords to execute the required scripts or functionality. This file extension may be in ``.ini`` or ``.yaml`` formats. Majority are using `.yaml` format, beacuse it is easy to read and write keywords. Also supports many features just like json.

[Read this article once to get started with `YAML`](https://www.cloudbees.com/blog/yaml-tutorial-everything-you-need-get-started)