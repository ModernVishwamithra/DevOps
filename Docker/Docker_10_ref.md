# Connecting docker hosts from outside docker cluster

1. Assume that we have deployed 6 docker hosts(6 instances) and 1 instance(ansibleadmin user). While deploying 6 docker hosts we are installing docker inside it by using terraform, ansible playbooks. Now docker is installed inside all 6 docker hosts, when you create services, or docker run or any other docker commands will be running after connecting to any one of the docker hosts(usually leader). 

2. Without connecting to any docker hosts, but still we can perform operations on them from another non docker cluster instance(ansibleadmin). To do that first install docker on that machine(ansibleadmin)
```bash
docker -H ec2-3-143-239-107.us-east-2.compute.amazonaws.com node ls
```
if we try to connect the `docker leader public ip` from `ansibleadmin`, it won't connect. To make this work do as follows.

3. Connect to leader and run `docker node ls`(assumed that we have deployed swarm cluster using ansible playbook, in which docker cluster was formed - docker swarm init, docker swarm join-token worker, docker swarm join-token manager). find the `docker.service` file
```bash
find / -name docker.service
```
4. We can find the file in multiple places, but we need to take this one `/usr/lib/systemd/system/docker.service`.using `nano` edit this file and add `-H tcp://0.0.0.0:2375` to the file as shown in the pic below

![docker-remote-access](https://github.com/ModernVishwamithra/DevOps/blob/main/Docker/images/docker-remote-access.png)

 * `-H tcp://0.0.0.0:2375` tells that `-H` we can host/connect this `docker leader` across the internet by using any ip addess `tcp://0.0.0.0` on docker default port `2375`

after saving we need to reload the daemon and restart the docker

```bash
systemctl daemon-reload
systemctl restart docker
```
5. Now open ansibleadmin and try to connect to the `dockerleader` 
```bash
docker -H ec2-3-143-239-107.us-east-2.compute.amazonaws.com node ls
```
it will give response this time.

6. Again this gives us a problem that as we have allowed all ip's `-H tcp://0.0.0.0:2375` to connect this docker host. We need to restrict only a particular ip to connect.

By using NACL or SecurityGroup we can restrict allow remote host like CI/CD like Jenkins or Azure DevOps to access Docker Host and deny all others. Without disturbing security group as we have allowed all traffic, we can set rules in NACL. Give the private ip of `ansibleadmin` server in NACL rule to allow.

![docker-host-nacl](https://github.com/ModernVishwamithra/DevOps/blob/main/Docker/images/docker-host-nacl.png)

Now if we try to connect docker host from `ansibleadmin` it will connect, if we try to connect from anyother server apart from docker cluster it won't connect.

But everytime we need to run this big command, insted we short it to `docker` using alias
```bash
docker -H ec2-3-143-239-107.us-east-2.compute.amazonaws.com node ls
docker -H tcp://10.2.13.50:2375 node ls
alias docker='docker -H tcp://10.2.13.50:2375'
docker node ls
```
# Docker node availability

```bash
docker node update  --availability pause node5 # Dont accept new tasks , runs existing. 
docker node update  --availability active node5 # Made node active
docker node update  --availability drain node5 # Reschedule tasks
```
We have 6 docker hosts in all containers are running,(here i have taken only 2 for testing)

* pause - assume that in `docker node 5` we want to do something and we don't want accept any new applications then we pause the node. Still the existing applications will be running. In kubernetes it is called `cordon`
When we scale the service to `2` before pausing the node
![docker-node-pause-1](https://github.com/ModernVishwamithra/DevOps/blob/main/Docker/images/docker-node-pause-1.png)

```bash
docker service scale nginx001=2
docker node update --availability pause ip-10-2-12-234
docker service scale nginx001=5
```
![docker-node-pause-2](https://github.com/ModernVishwamithra/DevOps/blob/main/Docker/images/docker-node-pause-2.png)
Once scaled up to 5, the `paused` node doesn't accepted the new containers, but still its running exixting container.

* drain - When we don't want to run any containers, or we want to reschedule the tasks we use `drain`
```bash
docker node update --availability drain ip-10-2-12-234
```
![docker-node-drain](https://github.com/ModernVishwamithra/DevOps/blob/main/Docker/images/docker-node-drain.png)

We observe that drained worker node gets container deleted from it and added to another node to make replicas=5

* active - When rescheduling, or changing settings in the server is completeda and you want to make node available,up and running in `active` mode
```bash
docker node update --availability active ip-10-2-12-234
```
# Docker resource requirements

We can scale each container to access memory and cpu resources. This is a best practice because sometiimes due to memory leak or unexpected load creates containers to stop running and even it affects the entire docker node(s).

**Limits: max**

**Reservations: min**
```bash
docker service create --name MEMCPUTEST1 --reserve-memory 300M --reserve-cpu 1 --replicas 3 --publish 4000:80 sreeharshav/rollingupdate:v3
```
Here we are running 3 containers, for each container we reserve `300MB` of RAM and `1 CPU core`. The containers can take min 300MB to maximum RAM

```bash
docker service create --name LIMITTEST --limit-cpu .25 --limit-memory 100M --replicas 3 --publish 3000:80 sreeharshav/rollingupdate:v3
```
Here we are running 3 containers, for each container we set limit `100MB` of RAM and `0.25 CPU core`. The containers can take max 100MB. 

```bash
docker service create --name LIMITTEST --limit-cpu .25 --limit-memory 100M --replicas 3 --publish 3000:80 sreeharshav/stress:256m
```
Here we are running 3 containers, for each container we set limit `100MB` of RAM and `0.25 CPU core`. The containers can take max 100MB. We are installing an image called `stress` which puts `256MB` load on each container, but we have limited each container to `100MB`. When we try to create the service it shows nodes are starting, running and keep on looping in those states because the containers requires more RAM due to `stress` so containers wont run. We can check the status of the srvice using `watch docker service ps c8q459duny3d17vnuwrksgz2c`

# Deployment Strategies

Assume that we have deployed a application running in containers(pods in Kubernetes). We want to change something in that application(consider a retailer website like an www.amazon.in), we have made changes. The problem is how you release the updates in the current running environment.
    - Can you stop the running website and update the changes and redeploy it? - Bad customer experience
So how you do it called `Deployment strategies`. It is not only applicable to docker but for all software release cycles.

Majority of the people follows these strategies
1. **Rolling updates or In-place upgrades**
[Read this article for clarity](https://docs.docker.com/engine/reference/commandline/service_update/)

Lets create a service

```bash
docker service create \
 --replicas 10 \
 --publish 8000:80 \
 --name nginx \
 --update-parallelism 1 \
 --update-delay 10s \
 sreeharshav/rollingupdate:v5
```
![docker-rolling-update-drain](https://github.com/ModernVishwamithra/DevOps/blob/main/Docker/images/rollingupdate.gif)

When we want to update the image, the without disturbing the application. There are containers running, when we do service update it creates one new container and delete the old container and it keeps on rolling the updates one by one(update-parallelism 1) witha a delay of 10s(update-delay 10s)

```bash
docker service update --image sreeharshav/testcontainer:v1 nginx
```
[refer devops docker_swarm_commands notes once]
2. Blue-greeen deployment

**Method 1**:
1.	Deploy Two Services with 5 Replicas each using two different images
2.	Service1 -> sreeharshav/rollingupdate:v5 Port-8000
3.	Service2 -> sreeharshav/testcontainer:v1 Port-9000
4.	Deploy AWS Target Group with name service1 and port 8000 and add all swarm machines to it.
5.	Deploy ALB and update DNS Record and check the website is reachable. Make sure ALB has an SSL Certificate which u can get it from AWS ACM.
6.	Now we need to flip the traffic from Service1 to Service2 as part of Blue-Green Deployment.
7.	Create a new Listener ALB with Port HTTPS on 443 and route traffic to Servcie2.
8.	Check the website connectivity from the browser.
9.	Edit the service1 listener which is TCP80 and redirect to port TCP 443.
10.	Check the website is reachable on service2 and all old users also redirected to the new service.

**Method 2**:  BLUE-GREEN-USING-TRAEFIK
Create two services with `blue` and `green`, remove the `blue` and add `green` using service update
docker service create \
	--name blue \
	--label traefik.port=80 \
	--network traefik-net \
	--label traefik.frontend.rule=Host:blue.awstelugu.xyz \
	--replicas 3 sreeharshav/rollingupdate:v1
    
    
docker service create \
	--name green \
	--label traefik.port=80 \
	--network traefik-net \
	--label traefik.frontend.rule=Host:green.awstelugu.xyz \
	--replicas 3 sreeharshav/testcontainer:v1

--ROLL-OUT--    
docker service update --label-add 'traefik.frontend.rule=Host:blue.awstelugu.xyz' green
docker service update --label-rm 'traefik.frontend.rule=Host:green.awstelugu.xyz' green
docker service update --label-rm 'traefik.frontend.rule=Host:blue.awstelugu.xyz' blue
docker service update --label-add 'traefik.frontend.rule=Host:green.awstelugu.xyz' blue

--ROLL-BACK---
docker service update --label-rm 'traefik.frontend.rule=Host:blue.awstelugu.xyz' green
docker service update --label-add 'traefik.frontend.rule=Host:green.awstelugu.xyz' green
docker service update --label-add 'traefik.frontend.rule=Host:blue.awstelugu.xyz' blue
docker service update --label-rm 'traefik.frontend.rule=Host:green.awstelugu.xyz' blue

**Method 3**:
* Lets create a service with 3 replicas running with a load balancer, we want to change the image. The environment which currently running is called as `blue` and here it is attached to route53 DNS record `www.devopsb27.com`. When anyone wants to access this application they will connect to this website.

* To perform the changes, first we create exact replica of `blue` environment and called as `green` environment where we do all the changes. To this we create a DNS record with another load balancer named `green.devopsb27.com` which is internally accessed by developers and testers.

* When everythings works good in `green` environment, we will flip(replace) the DNS record `green.devopsb27.com` with `www.devopsb27.com`. Now `green` environemnt becomes `new blue` environment. We will keep `old blue` enviroment for few days (depends), because if any probelm occured in `new blue` environment we can roll back to `old blue` enviroment. If everything works well after some days we decommission the `old blue` enviroment.
![blue-green-deployment](https://github.com/ModernVishwamithra/DevOps/blob/main/Docker/images/blue-green-deployment.gif)

3. Canary deployment
Just like `blue` and `green` deployment with slight changes. 100 % of Traffic is actually going to `blue`, When we have tested `green` environment and working fine, we allow `10%` of traffic to `green` and `90%` of traffic to `blue` initially. Slowly we move traffic to `green` to make it 100%. In this method we can easily roll back if any problems occured in `green` environment

![canary-deployment](https://github.com/ModernVishwamithra/DevOps/blob/main/Docker/images/canary-deployment.gif)

Deploy the environment as similar to BLUE-GREEN and use the Route53 weights for sending major chunk of traffic to blue and minor chunk to green service. Check the application is working normally when the traffic is diverted to the GREEN. If everything is working well, then disable the traffic to BLUE by making the weight 0 and assigning 255 weight to green.

# Docker stack deploy

In swarm cluster when we are running mutiple services in a container is called `Stack`

* Create [Docker_Swarm_Working-Voting-App.yml](https://github.com/ModernVishwamithra/DevOps/blob/main/Docker/Docker_Swarm_Working-Voting-App.yml) file and add yaml script for multiple services. Upload to git or create yml file in docker host

* Deploy the multiple services in a container as a stack
```bash
docker stack deploy -c Docker_Swarm_Working-Voting-App.yml VOTING
```
It creates stack named `VOTING` and runs multiple services in the container