# Ansible

[doc reference](https://docs.ansible.com/ansible-core/devel/index.html)

1. Launch a server with the custom AMI we have created with packer(`ansibleadmin` as user) and add assume role to this instance.

2. Install the ansible controller with the following commands

    --$ sudo apt update
    --$ sudo apt install software-properties-common
    --$ sudo add-apt-repository --yes --update ppa:ansible/ansible
    --$ sudo apt install ansible

Ansible controller can't able to run on windows natively and we can only use winows as a ansible clinet which means we can configure windows as a client machine, though there is concept called WSL(Windows Subsystem for Linux)

![Ansible Controller Support](https://github.com/ModernVishwamithra/DevOps/blob/main/Ansible/images/ansible-controller.png)

3. 