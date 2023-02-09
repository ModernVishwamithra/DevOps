# Docker Part 6

### Docker Compose

It is used for creating mutiple docker elements from a single file.
It helps the developer for testing in his local/cloud machine before deploying it to UAT/DEV
------

# Docker Swarm

docker swarm - to manage 

``bash
docker info
```
By default swarm is inactive
    -  Swarm: inactive

* To enable swarm - initialize swarm

``bash
docker swarm init
```
It generates a swarm token which is used to connect with nodes. 
```
docker swarm join --token SWMTKN-1-0yclblusfsm4gzl73aof4m83ne0sps4r41ypcgcedxuk4sghhj-60l6i9oe6ghb86qup5ici1gy3 10.1.1.48:2377
```
We will work on it later. Now check the `docker info` to make sure that swarm is activated
    - Swarm: active

* Now to connects the nodes, it requires leader. As soon as we initiated docker swarm, the docker host is the leader by default. To check that
```bash
docker node ls
```
ID                            HOSTNAME       STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
------                      -----------      ------     -----------   --------------    -------------
hqixdmf308146fh6hp0ar8i5i *   ip-10-1-1-48   Ready       Active         Leader           20.10.23
------                         -----------   ------     -------         -------         ---------

* Read this first - to understand what is the Raft algorithm and the problem with data consistance across all nodes.
[Raft-Consensus-Algorithm](https://thesecretlivesofdata.com/raft/)
[Swarm-Raft](https://docs.docker.com/engine/swarm/raft/)

Raft tolerates up to (N-1)/2 failures and requires a majority or quorum of (N/2)+1 members to agree on values proposed to the cluster. This means that in a cluster of 5 Managers running Raft, if 3 nodes are unavailable, the system cannot process any more requests to schedule additional tasks. The existing tasks keep running but the scheduler cannot rebalance tasks to cope with failures if the manager set is not healthy.

Cluster wont run if nodes 
Masters -1 (1-1)/2 = 0      -- Clustor wont run
Masters -2 (2-1)/2 = 0.5    -- Usually wont keep even number of masters
Masters -3 (3-1)/2 = 1      -- Clustor tolerates upto 1 node failures
Masters -4 (4-1)/2 = 1.5    -- Usually wont keep even number of masters
Masters -5 (5-1)/2 = 2      -- Clustor tolerates upto 2 node failures

* Create 5 instances(docker-nodes) with docker installed through user data
```bash
#!/bin/bash
curl https://get.docker.com | bash
```
* Now we need to form cluster by joining all the 5 nodes.
```bash
docker swarm join-token manager
```
--     docker swarm join --token SWMTKN-1-0yclblusfsm4gzl73aof4m83ne0sps4r41ypcgcedxuk4sghhj-95y1nfja9d7czuk87wbf26sqc 10.1.1.48:2377

You will get bash command with command. By using this you need to join all the nodes 

* Login into each instance, run that docker swarm join command


* Creates 3 replicas(containers) in docker swarm worker ip = 10.1.0.21
```bash
docker service create --name nginx001 --replicas 3 -p 8080:80 --constraint node.hostname==ip-10-1-0-21 nginx:latest
```
Now we have 1 worker,4 are managers(among 1 is leader).

* Once you start watch the status, we can se except for `worker` node, remianing Mannagers shows `Reacheable`

```bash
watch docker node ls
```

* Start stopping the `Leader` server, immediately you can see another manager becomes leader(Raft algorithm works, election happens). But when you check the application it keeps working. Similarly do again for the Leader instance(stop and see).

* As per the Raft algorithm formula more when masters are 4, less than 2 masters are down then cluster cant run(application remains unimpacted but new application can't be run). To make cluster work again, restart the stopped instances and check the status of the nodes. Again cluster appears.

* The important thing to remember is that we have one worker and 5 managers. Worker node has containers(application) running, if that fails application will be impacted. Instead of having more managers, keep limited managers and make other managers as workers(**This process is called demoting**)

```bash
docker node demote ip-10-1-0-252 ip-10-1-12-246 ip-10-1-13-126 ip-10-1-14-71
```
* We can use [visualizer](https://hub.docker.com/r/dockersamples/visualizer) tool for better monitoring of swarm clusters. Run the docker image in `leader` node

```bash
docker run -it -d -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock dockersamples/visualizer
```

Now you can access this in port 8080 `http://ec2-3-145-81-31.us-east-2.compute.amazonaws.com:8080/`

* Deploy nginx service in docker swarm, remeber that when we are deploying in cluster we need to use `docker service` instead of `docker run`

```bash
docker service create --name nginx001 --replicas 3 -p 8080:80 nginx:latest
```
We can see that docker visualizer can show you the 3 worker nodes hosts the nginx service. We can create more replicas(i mean we can scale up or down the replicas). Here we have scaled up to 12 replicas. We have 1 manager(leader) and 5 worker nodes. Each node gets 2 replicas

```bash
docker service scale nginx001=12
```
* If any one of the node is down, the replicas 12 will be shared by other active nodes. When node is up immediately it won't sahre the resources from other nodes, when we scale up/down it might get shared 

* Docker compose builds images and used for `DEV`, where as docker stack wont builds images, it has already images built and ready to use for `PRODUCTION`

Create [docker-swarm-compose-voting-app.yml](https://github.com/ModernVishwamithra/DevOps/blob/main/Docker/docker-swarm-compose-voting-app.yml) file and upload to git. Do git pull and run

```bash
cd /DevOps/Docker/
docker stack deploy -c docker-swarm-compose-voting-app.yml VOTING
```
We can see multiple applications are running on single node
`http://ec2-3-145-81-31.us-east-2.compute.amazonaws.com:8080/` -- nginx
`http://ec2-3-145-81-31.us-east-2.compute.amazonaws.com:5000/` -- vote buttons (cats vs dogs)
`http://ec2-3-145-81-31.us-east-2.compute.amazonaws.com:5001/` -- vote results