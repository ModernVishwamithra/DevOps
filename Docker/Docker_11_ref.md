# Portainer.io

* So far we have worked on the `docker cli` to manage the containers and for visualization we have used `docker swarm visualizer`. Sometimes/everytime managing containers through `docker cli` is a cumbersome task, even when we have little time to update and redeploy the containers through cli will be little difficult. Hence [https://www.portainer.io/] comes with a solution to manage containers not only of Docker, but other container orchestration tools like Kubernetes, Nomad as well. [refer this article for clarity](https://thenewstack.io/an-introduction-to-portainer-a-gui-for-docker-management/)

* Portainer is a universal container management tool that can work with both Docker and Kubernetes to make the deployment and management of containerized applications and services easier and more efficient.

* So long story cut short, `portainer` is a GUI based tool to manage the containers. They have BE and CE editions. We are using CE edition. Here is the architecture of it [https://docs.portainer.io/start/architecture]

![portainer-architecture-detailed](https://github.com/ModernVishwamithra/DevOps/blob/main/Docker/images/portainer-architecture-detailed.png)

* With Portainer you can:

    - Reduce the complexity of single and multicluster container deployments.
    - Work with a user-friendly UI.
    - Codify best practices with the help of templates and default configurations.
    - Work more consistently and reliably.
    - Apply centralized access management and permissions.

* Portainer can run in individual docker containers or as a service in docker swarm cluster. Lets install the portainer in docker swarm as stack deploy(i have created two docker hosts among one is worker node)

```bash
curl -L https://downloads.portainer.io/ce2-17/portainer-agent-stack.yml -o portainer-agent-stack.yml
docker stack deploy -c portainer-agent-stack.yml portainer
docker service ls
```
* When we see the services running in docker, there are two services running - `Portainer server` and `Portainer Agent`. We can install `docker swarm visualizer` to check how these services are running

![docker-service-portainer](https://github.com/ModernVishwamithra/DevOps/blob/main/Docker/images/docker-service-portainer.png)

* As per the portainer architecture `portainer server` will be running in `docker manager(leader)` node and `portainer aganet` will be running in all the nodes which collects the information of the logs or establishing communication b/w the all the nodes with portainer server. 

* Now connect to portainer server which is running in the port `9000`
`http://ec2-18-220-50-35.us-east-2.compute.amazonaws.com:9000`, which show the admin page where we need to create new password for `admin` user. Icreated `India@123456` as a password. Login with that credentials and we can seea dashboard. we can do the following with 

* Portainer makes it considerably easier to:

    - Deploy and manage containers.
    - Deploy and manage full-stack applications.
    - Create and manage networks.
    - Create and manage volumes.
    - Create and manage templates.
    - Create and manage services.
    - Create and manage secrets.
    - Create and manage environment variables.
    - Create and manage configs (for non-sensitive information).
    - Pull and manage images from various repositories.
    - Manage users.
    - Create and manage environments.

# Docker Logs

8. If we want to debug our container, we need its logs
```bash
docker ps
docker logs 4087948e5708 -f # <container-id first 16 digits) -follow
```
We can see the logs are displaying when we try to access from different browser. Now we need to access this log which was gatting saved in respective container directory.

```bash
cat /var/lib/docker/containers/4087948e57089115d5961412f88bf215e4889822452aa07cf4198044f197e571/4087948e57089115d5961412f88bf215e4889822452aa07cf4198044f197e571-json.log | jq 
```
* Here one problem occurs when we stop the container 
```bash
docker stop 4087948e5708
```
The logs along with the container gets deleted. Even when we are doing auto-scaling, servers grow and shrink, containers are also gets created and destroyed. If we want to perform soma analytics on the logs generated then it wont be accessible. Hence we need to use central log storage systems by using 3rd party tools like `DataDog`, `Splunk`, `New Relic` etc. 

* But at this point wea re going to discuss about `EFK(Elastic search, Fluent D, Kibana)` which is a centralized log system. `Fluent D` collects the logs and send it to `Elastic search` from that we can create a `GUI` based metrics using `Kibana`. The `EFK` doeas only Logs collections and visualization and it wont perfrom monitoring.

* Where as `DataDog`, `Splunk`, `New Relic` performs log management, monitoring and lot more. Need to do `R&D` to test them. Even we can use our own AWS cloudlogs for log management and we can use built-in AWS monitoring system like `CloudWatch`, for metrics monetorining and visualization. 
