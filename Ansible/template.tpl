[allservers]
ansibleclient01 ansible_port=22 ansible_host=${client01}
ansibleclient02 ansible_port=22 ansible_host=${client02}
ansibleclient03 ansible_port=22 ansible_host=${client03}

[webservers]
ansibleclient01 ansible_port=22 ansible_host=${client01}

[dbservers]
ansibleclient02 ansible_port=22 ansible_host=${client02}

[appservers]
ansibleclient03 ansible_port=22 ansible_host=${client03}