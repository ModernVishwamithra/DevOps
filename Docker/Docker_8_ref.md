# Docker Ingress Controller

1. Create a Target group with port 8000 as port and create Network Load balancer by attaching this target group.
2. Lets create 3 docker services 
```bash
docker service create --name nginx001 --replicas 3 --publish 8080:80 nginx:latest
docker service create --name nginx002 --replicas 6 --publish 8000:80 sreeharshav/rollingupdate:v5
docker service create --name nginx002 --replicas 3 --publish 8100:80 sreeharshav/testcontainer:v1
```
After deploying load balancer when we access DNS of LB it shows only `8000` port related service running and in the backend it routs to port 80 as it is http/https. Since we have routed all the applications to `port 80` and in the load balancer we already added `listner` which is listening `port 80`. So LB cant able to route multiple services to port 80 all at a time. 

Now if we want to allow other services/applications to route to port 80, we need to create another load balancer. Here is the catch, suppose if we have 100 applications running we need to create 100 load balancers which **increases cost** also **there is a limit of creating LB for every region** and this will be breached. Hence this is not a feasable solution, but accepted solution is `Ingress Controller`

![Ingress controller](https://github.com/ModernVishwamithra/DevOps/blob/main/Docker/images/ingress-controller.png)

When the traffic comes from internet, Route53 routes it to Network Load balancer. Simply NLB forward it to Ingress controller(Traefik), `based on the host name` it routes the traafic to specific application

There are multiple 3rd party tools [Ingress Controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/) are available. Among that we are using [Traefk](https://traefik.io/solutions/docker-swarm-ingress/) 

3. Install [docker visualizer](https://hub.docker.com/r/dockersamples/visualizer/#!) on Leader node
```bash
docker run -it -d -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock dockersamples/visualizer
```
Access it with its public-ip `http://ec2-18-222-60-144.us-east-2.compute.amazonaws.com:8080/`. We can see all the nodes are appeared.

4. Create a `overlay network` 
```bash
docker network create --driver=overlay traefik-net
```
### What is overlay network
![docker_gwbridge](https://github.com/ModernVishwamithra/DevOps/blob/main/Docker/images/gateway_bridge_ingress_networks.png)

Before creating swarm/service When we type `docker network ls` it shows below 

NETWORK ID     NAME      DRIVER    SCOPE
f8995e93f8dd   bridge    bridge    local
0b5bab46d576   host      host      local
7a56dbdf13a1   none      null      local

we have seen about these networks purpose(refer other docs), now after creating docker service two more networks will be created `docker_gwbridge` and `ingress`

NETWORK ID     NAME             DRIVER    SCOPE
f8995e93f8dd   bridge           bridge    local
f8s95e9ff8dd   docker_gwbridge  overlay   swarm
0b5bab46d576   host             host      local
7a56dbdf13a1   none             null      local
9a56dbd812a9   ingress          overlay   swarm

When you initialize a swarm or join a Docker host to an existing swarm, two new networks are created on that Docker host:

 * an overlay network called `ingress`, which handles the control and data traffic related to swarm services. When you create a swarm service and do not connect it to a user-defined overlay network, it connects to the ingress network by default.
 * a bridge network called `docker_gwbridge`, which connects the individual Docker daemon to the other daemons participating in the swarm.

![ingress overlay](https://github.com/ModernVishwamithra/DevOps/blob/main/Docker/images/gateway_bridge_ingress_networks-2.png)
### Traefik
![Ingress controller](https://github.com/ModernVishwamithra/DevOps/blob/main/Docker/images/ingress-controller.png)

5. Stop all the services created earlier and Install [traefik] on `leader`
```bash
docker service rm nginx001 nginx002 nginx003
docker service create \
    --name traefik16 \
    --constraint=node.role==manager \
    --publish 80:80 \
    --publish 9080:8080 \
    --mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock \
    --network traefik-net \
    traefik:v1.6 \
    --docker \
    --docker.swarmmode \
    --docker.domain=traefik \
    --docker.watch \
    --web
```

Here on `8000`, `8100` ports applications are running and on `8080` visualizer is running. Hence we created `traefik` service on `9080`. We can see in the 

6. Now create a new `Target group` with port 80 as a listner. Edit the load balancer listener by adding the latest target group and delete the old target group.

7. Create 3 simple records in the `route53` with the domain names and attach the NLB to it.
    - blue.pavankumarpacharla.xyz
    - green.pavankumarpacharla.xyz
    - orange.pavankumarpacharla.xyz

8. Now We need to create 3 services with different applications

```bash
docker service create \
    --name blue \
    --label traefik.port=80 \
    --network traefik-net \
    --replicas 3 \
    --label traefik.frontend.rule=Host:blue.pavankumarpacharla.xyz \
    sreeharshav/rollingupdate:v5

docker service create \
    --name green \
    --label traefik.port=80 \
    --network traefik-net \
    --replicas 3 \
    --label traefik.frontend.rule=Host:green.pavankumarpacharla.xyz \
    sreeharshav/testcontainer:v1

docker service create \
    --name orange \
    --label traefik.port=80 \
    --network traefik-net \
   --replicas 3 \
    --label traefik.frontend.rule=Host:orange.pavankumarpacharla.xyz \
    nginx:latest

```
based on the hostname, if we access it will show you that particular application running. Here we need to observe `traefik` routes the external traffic to the same port number `80` in which the NLB is listening.

8. We can also attach/create SSL certificates to `traefik`.[need to do r&D]