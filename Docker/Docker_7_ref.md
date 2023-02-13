# Docker swarm with terraform - lable and constrains

We can assign lables and constrains to docker swarm nodes.
1. We are going to deploy ansible playbook [docker_swarm.yml](https://github.com/ModernVishwamithra/DevOps/blob/main/Ansible/Playbooks/docker_swarm.yml), which has multiple plays as follows
    * Install Docker and Configure Docker Swarm
    * Enable Docker Swarm
    * Add Workers to Swarm
    * Add Managers to Swarm
    * Deploy Test Application from rollingupdate:v5
2. We have created [docker_template.tpl](https://github.com/ModernVishwamithra/DevOps/blob/main/Ansible/docker_template.tpl),[docker_localfiles.tf](https://github.com/ModernVishwamithra/DevOps/blob/main/Ansible/docker_localfiles.tf) files. Change the VPC-id and subnet -id in [vpc_peering.tf](https://github.com/ModernVishwamithra/DevOps/blob/main/Ansible/vpc_peering.tf)( vpc-id and subnet-id of the resources on which you are running ansible controller.)
3. In [main.tf](https://github.com/ModernVishwamithra/DevOps/blob/main/Ansible/main.tf), enable 6 servers to deploy. Push the modified files to github.
4. Apply the admin-role for ansible-controller, Log-in to ansible controller with ansible-admin, generate rsa keys seperately for github(github_rsa,github_rsa.pub) and for 6 servers(id_rsa,id_rsa.pub). Replace the server rsa keys with laptop keypair[msi-keypair]. Add ssh-key to github and Run the following to add the ssh keys to github
```bash
eval $(ssh-agent)
ssh-add ~/.ssh/github_rsa
```
5. Perform 
```bash
git clone git@github.com:ModernVishwamithra/DevOps.git
cd DevOps/Ansible
terraform init
terraform validate
terraform plan
terraform apply --auto-approve
```
6. Check wheteher the inventory files have created and test the connection
```bash
ansible -i invfile allservers -m ping
ansible -i dockerinvfile docker_servers -m ping
```

It throws error that it fails to establish connection, beacuse when we are trying to connect with ansibleadmin the servers does not have ansible user in it. To solve this we connect them by using `ubuntu` user.
```bash
ansible -i dockerinvfile docker_servers -m ping -u ubuntu
```
Now it shows connection succesful, but we haven't created `ubuntu` user still its connecting. Beacuse when we are deploying servers, the key-pair we attached is `msi-keypair` and the same keys are placed in `ansible-admin` user(refer step 4).
7. As connection is successful, we can run playbook to deploy our application in 6 replicas
```bash
ansible-playbook -i dockerinvfile Playbooks/docker_swarm.yaml -u ubuntu --syntax-check
ansible-playbook -i dockerinvfile Playbooks/docker_swarm.yaml -u ubuntu --check
ansible-playbook -i dockerinvfile Playbooks/docker_swarm.yaml -u ubuntu -vv
```
8. Login to any one docker node and watch the nodes creation
```bash
sudo watch docker node ls
```
which shows you the 6 servers connected to docker swarm and formed as cluster. As we already defined in [docker_template.tpl](https://github.com/ModernVishwamithra/DevOps/blob/main/Ansible/docker_template.tpl) that among 6 servers 1 is Leader(master), 2 are managers and 3 are worker nodes.
![Docker Swarm Nodes](https://github.com/ModernVishwamithra/DevOps/blob/main/Docker/images/docker-swarm-node-ls.png)

9. When we see the above image, it is understood that 
ip-10-2-1-11 - Leader
ip-10-2-2-65, ip-10-2-3-52 - Managers
ip-10-2-1-148, ip-10-2-2-230, ip-10-2-3-59 - Workers

### Docker Lables
Check this reference for more clarity on [Docker Lables](https://docs.docker.com/config/labels-custom-metadata/)
`Lables` can be assigned to docker swarm nodes, with tha lables we can manage easily. 
10. To add a lable to a node
```bash
docker node update --label-add=MANAGER=YES ip-10-2-3-59
docker node update --label-add=WORKER=YES ip-10-2-3-59
docker node update --label-rm=WORKER ip-10-2-3-59
```
11. We can apply constrains on docker nodes. Refer this [Docker Constarints](https://docs.docker.com/engine/reference/commandline/service_create/)
```bash
docker service create --name nginx001 --constraint=node.labels.WORKER==YES --replicas 6 --publish 8080:80 sreeharshav/rollingupdate:v5
```
The above docker commands runs the application on `WORKER` nodes only
