# Docker Swarm Secrets

```bash
echo "India@123456" | docker secret create india -
```
Creates `india` It give you encrypted token/key `wyqwx9gc0r3y364044hopk3aa`

docker secret ls
docker secret inspect india

create docker service with `secret`
docker service create --name nginx001 --secret india --replicas 3 --publish 8080:80 nginx:latest

Run the docker exec
docker exec -it nginx001.2.vzrysiesqqp4ctry067pbtwzx /bin/bash
ls 
* It will show `/run` folder, it stores when the service is created and is stored inside a container. It gets deleted when container removed.

* This `/run/` folder consists of `secrets` folder, inside which our secrets variables gets stored. To access it
```bash
cat /run/secret/india
```
* But the problem with the `docker secrets` is that we can't assign secrets to `environmental variables` directly, but in kubernetis we can. Everytime we need to assign like this.

env:
 my_secret_password = /run/secrets/india


# Docker Swarm Configs
