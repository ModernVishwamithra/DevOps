[docker_servers]
ansibleclient01 ansible_port=22 ansible_host=${client01_private}
ansibleclient02 ansible_port=22 ansible_host=${client02_private}
ansibleclient03 ansible_port=22 ansible_host=${client03_private}
ansibleclient04 ansible_port=22 ansible_host=${client04_private}
ansibleclient05 ansible_port=22 ansible_host=${client05_private}
ansibleclient06 ansible_port=22 ansible_host=${client06_private}

[docker_master]
ansibleclient01 ansible_port=22 ansible_host=${client01_private}

[docker_workers]
ansibleclient04 ansible_port=22 ansible_host=${client04_private}
ansibleclient05 ansible_port=22 ansible_host=${client05_private}
ansibleclient06 ansible_port=22 ansible_host=${client06_private}

[docker_managers]
ansibleclient02 ansible_port=22 ansible_host=${client02_private}
ansibleclient03 ansible_port=22 ansible_host=${client03_private}