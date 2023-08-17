# Jenkings Part 1
## High available jenkins with multiple masters
![Docker registry](https://github.com/ModernVishwamithra/DevOps/blob/main/Jenkins/pics/jenkins-high-available-architecture.jpg) 

1. We are going to install jenkins(an automation server which does the building, testing, deploying the apps using **pipeline**) in a ec2 server with 't2.medium' and 10GB memory
2. To install jenkins, we require JRE beacuse jenkins is a java application
3. Check the installation instructions [Jenkins Installation](https://www.jenkins.io/doc/book/installing/linux/)
4. Once server is up, connect to it and install the necessary tools

- JDK 17
```bash
sudo apt update
sudo apt install openjdk-17-jre -y
java -version
```

- Unzip - CURL- nfs-common- net-tools- jq
```bash
sudo apt install jq unzip nfs-common net-tools curl -y
```

- Terraform
```bash
cd /usr/local/bin/    
wget https://releases.hashicorp.com/terraform/1.5.5/terraform_1.5.5_linux_386.zip
unzip terraform_1.5.5_linux_386.zip
rm -f terraform_1.5.5_linux_386.zip
```

- Packer
```bash
cd /usr/local/bin/
wget https://releases.hashicorp.com/packer/1.9.2/packer_1.9.2_linux_386.zip
unzip packer_1.9.2_linux_386.zip
rm -f packer_1.9.2_linux_386.zip
```

- Docker
```bash
curl https://get.docker.com | bash
```

5. Now create 'ansibleadmin' user and add laptop public key to authorized keys to this user
```bash
cd ~
sudo useradd -m ansibleadmin --shell /bin/bash
sudo mkdir -p /home/ansibleadmin/.ssh
sudo chown -R ansibleadmin /home/ansibleadmin/
sudo touch /home/ansibleadmin/.ssh/authorized_keys
sudo usermod -aG sudo ansibleadmin
echo 'ansibleadmin ALL=(ALL) NOPASSWD: ALL' | sudo tee -a /etc/sudoers
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDQoXqWrZGnOuJEceBk8q74Aw/gD0ko...........' | sudo tee /home/ansibleadmin/.ssh/authorized_keys
```

6. Once successfully installed and created 'ansibleadmin' user, try to login the instance with 'ansibleadmin' as a user. You can log in successfully, but when we try to run `docker ps` it will show permission denied . to solve this we will add `ansibleadmin` user to 'docker' and 'sudo' groups and reboot the docker daemon and reboot the server
```bash
sudo usermod -aG docker ansibleadmin
sudo usermod -aG root ansibleadmin
systemctl daemon reload
syste,ctl docker restart
```
7. Now create AMI from this instance, once it is available, launch another instance from this AMI and name it as 'Jenkins-Master-2'
8. We need to mount the EFS according the above architecture, so first create EFS 
9. Mount the EFS to Jenkins servers
```bash
mkdir -p /var/lib/jenkins
nano /etc/fstab
```
and append the following mount point of EFS to /var/lib/jenkns
```bash
fs-07fc36592956dfd1d.efs.us-east-1.amazonaws.com:/      /var/lib/jenkins        nfs     defaults        0   0 
```
Once added, check before and after mount
```bash
df -h
mount -a
df -h
```

10. Login to 'Jenkins-master-2' server and perform the step.9
11. install jenkins in both servers [Jenkins Installation](https://www.jenkins.io/doc/book/installing/linux/)
12. Once installed, check the server-1 on port 8080, it will ask you unlock jenkins by using a password. read it and paste it to unlock
```bash
cat /var/lib/jenkins/secrets/initialAdminPassword
cc089f9c1fde44ad8a44dcbe7ef4d06e
```
Skip and continue as admin

13. Now install the custom plugins provided by jenkins, create a new item, enter `testjob1` and select clone git , add the public repo Url, select build step --> 'Execute shell' add the follwing environmental variables and versions of tools we have installed

```bash
echo $BUILD_NUMBER
echo $BUILD_ID
echo $NODE_NAME
echo $WORKSPACE
terraform version
packer version
docker version
```
Save and hit the `build now` option. Now build fails due to lack of permissions for `jenkins` user to read `docker version`. to solve this 

```bash
sudo usermod -aG docker jenkins
sudo usermod -aG root jenkins
```

reboot the server.

14. It shows login page enter 'admin' as user and password is from step.12
15. Now run the build again and it will be success, we can see all the tool versions
16. Now login to another jenkins master-2 in the same port 8080 we can see the same installation options, but one you restart the jenkins
http://ec2-34-230-65-218.compute-1.amazonaws.com:8080/restart, it will show the job which ran in first server. Also when you logout from jenkins we can login using same password as jenkins-master-1.(step.12)
17. But to see the immediate changes in the two servers, we have an option to `reload config`. To do that create a user named `reloadConfig` and set password using the `users` in `Manage jenkins`
18. Create user and login with that user. Hit the 'Configure' button and generate a API token for that user, copy it and paste it aside.
`11aa696744fc002cb3b9894b0442342b7d`
19. download 'jar' file in the jenkins server-1
```bash
#wget http://secondaty-jenkins-public-dns/ip:8080/jnlpJars/jenkins-cli.jar
cd /var/lib/jenkins/
wget http://ec2-52-23-179-146.compute-1.amazonaws.com:8080/jnlpJars/jenkins-cli.jar
```
Now try to build more jobs in master-1, see whether it was reflected when master-2 refresh. It wont reflect. 
20. To reflect, we need to run the following command by providing api token and username as followss
```bash
#java -jar /var/lib/jenkins/jenkins-cli.jar -s http://<secondary-jenkins-publicip>:8080 -auth reloadconfig:token reload-configuration
java -jar /var/lib/jenkins/jenkins-cli.jar -s http://ec2-52-23-179-146.compute-1.amazonaws.com:8080 -auth reloadconfig:11aa696744fc002cb3b9894b0442342b7d reload-configuration
```
21. When we run the above command everytime, jenkins master-2 gets updated, instead of running the command manually we can keept this command in cron expression, so that every minute it will run
```bash
crontab -e
* * * * * java -jar /var/lib/jenkins/jenkins-cli.jar -s http://ec2-52-23-179-146.compute-1.amazonaws.com:8080 -auth reloadconfig:11aa696744fc002cb3b9894b0442342b7d reload-configuration
```
22. Now deploy two servers as jenkins slaves(DEV,PROD) with the custom ami we have created.
23. go to 'Manage Jenkins' in Jenkins master -1 and select nodes and clouds , select add node, 

*Remote root directory* : /home/ansibleadmin
*Lables*: DEV
*Launch method*: Launch agent via SSH
*Host*: private-ip
*Credentials*: ansibleadmin, ssh-private-key(create seperately and add)
*Host Key Verification Strategy*: No verifying Verification Strategy
*Agent*: default option(online)

Save. Do the same for another node but provide label as 'PROD'
24. Go to Testjob1 and configure --> select check box for this option 'Restrict where this project can be run' and give lable as DEV. Save and run the job, it will run the job by identifying the jenkins-slave-dev sever using LABEL 'DEV'. Check the console output of testjob-1, it shows, job run on slave-dev
25. Create another job -->Dshboard--> new Item -->Testjob2  __> copy thre job from -->testjob1--> select check box for this option 'Restrict where this project can be run' and give lable as PROD. Now when you build this job, it runs on slave-dev.