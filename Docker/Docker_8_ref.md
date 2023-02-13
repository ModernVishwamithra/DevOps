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

There are multiple 3rd party clients [Ingress Controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/) are available. Among that we are using [Traefk](https://traefik.io/solutions/docker-swarm-ingress/) 

3. Install [docker visualizer](https://hub.docker.com/r/dockersamples/visualizer/#!) on Leader node
```bash
docker run -it -d -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock dockersamples/visualizer
```
Access it with its public-ip `http://ec2-18-222-60-144.us-east-2.compute.amazonaws.com:8080/`. We can see all the nodes are appeared.
4. Install [traefik]()