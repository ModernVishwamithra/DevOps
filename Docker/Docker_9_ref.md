# Docker Swarm Secrets
Sensitive information needs to be stored and secured.[Refer this for clarity](https://docs.docker.com/engine/swarm/secrets/)

* We can generate random secrets
```bash
openssl rand -base64 12 | docker secret create db_root_password -
openssl rand -base64 12 | docker secret create db_dba_password -
```
* We can also give our own secrets
```bash
echo "India@123456" | docker secret create india -
```
The above command creates `india` with information `India@123456` in it, also It give you encrypted token/key `wyqwx9gc0r3y364044hopk3aa`

```bash
docker secret ls -- lists the secrets
docker secret inspect india -- shows the information of secrets,like data created,name etc
```

* Create docker service with `secret`
```bash
docker service create --name nginx001 --secret india --replicas 3 --publish 8080:80 nginx:latest
```

* Run the docker exec
```bash
docker exec -it nginx001.2.vzrysiesqqp4ctry067pbtwzx /bin/bash
ls 
```
* It will show `/run` folder, it stores when the service is created and is stored inside a container. It gets deleted when container removed.

* This `/run/` folder consists of `secrets` folder, inside which our secrets variables gets stored. To access it
```bash
cat /run/secret/india
```
* But the problem with the `docker secrets` is that we can't assign secrets to `environmental variables` directly, but in kubernetis we can. Everytime we need to assign like this.

env:
 my_secret_password = /run/secrets/india

* Lets deploy a db application and create the credentials for db and store them in environmental variables. 
```bash
openssl rand -base64 12 | docker secret create db_root_password -
openssl rand -base64 12 | docker secret create db_dba_password -
```

* Create a [docker_secrets_mysql.yml](https://github.com/ModernVishwamithra/DevOps/blob/main/Docker/docker_secrets_mysql.yml).
It has the following
    - It creats mysql db with secrets `db_root_password`,`db_dba_password` passwords
    - It deploy in `manager` node (replicas 1)
    - We are reserving/assigning boundaries(constraints) of RAM memory allocation min-128MB and max-512MB
    - deploy the db on port `3306`
    - creates environment variables and secrets always get from `/run/secrets/` this directory
    - it creates a user defined network `appnet` which allows host-name resolution unlike bridge network and maps while creating service
    - it creates a volume `datavol` to preserve the data even after container is terminated. It maps the volume using bindmount
    - it installs adminer service and allows us in `8888` port
    - we have given created secrets as `external: true` which means that when secrets with that name already exits it will take directly other wise it will create

* Upload the file to github repo and pull the file in docker node `leader` or create a file in `leader` node and paste the conents in that file. now we need to run this file.

* While using individual docker hosts when we try to run `yml` codes using `docker compose`. But all the nodes are in swarm, to deploy that file we need to use `docker stack`
```bash
docker stack deploy  -c <filename with below code> <stack_name> -- syntax
docker stack deploy -c docker_mysql.yml SECRET_TESTING
```
* Once deployed we need to check where the applications are running. check with `docker service ls`
![docker-stack-deploy](https://github.com/ModernVishwamithra/DevOps/blob/main/Docker/images/docker-swarm-stack-deploy.png).

* Now we see adminer service,db in different ports
    - http://ec2-18-219-119-185.us-east-2.compute.amazonaws.com:8080/ - nginx
    - http://ec2-18-219-119-185.us-east-2.compute.amazonaws.com:8888/ - adminer
    - http://ec2-18-219-119-185.us-east-2.compute.amazonaws.com:3306/ - mysql db

* Access adminer service(GUI for db)    
![docker-swarm-adminer-mysqldb](https://github.com/ModernVishwamithra/DevOps/blob/main/Docker/images/docker-swarm-adminer-mysqldb.png)

we need to login into db with username `root` and passwords are stored in secrets. Read them and login with root password. Perform the sql operations using `myflixdb`  sample file
```bash
docker exec -it SECRET_TESTING_db.1.vulsoq3zqb4dtghfacu3cw2lf /bin/bash 
cat /run/secrets/db_dba_password #you will get this "vWDIF+4SI2nVX9E8"
cat /run/secrets/db_root_password  #you will get this "SdFj0VXi8tvt8THm" 
```

* We can remove stack
```bash 
docker stack rm SECRET_TESTING
```
Here including stack, `volume` also gets deleted. If volume is deleted then `db` data also will be deleted.To solve this problem we create volume seperately by giving `external=true` in [docker_secrets_mysql.yml](https://github.com/ModernVishwamithra/DevOps/blob/main/Docker/docker_secrets_mysql.yml) file. This check whether the volume is already exists otherwise it will be created.

But again the problem is there are many managers are present in docker swarm, in which manager the volume is attached?(it will attach randomly). So we need to specify the volume to be attached to specific manager, to do that second time while deploying give `constraints: [node.hostname == ip-10.2.2.3]` in which the leader is running.

```bash
docker volume ls        #check the docker volume before deploying 
docker stack deploy -c docker_mysql.yml SECRET_TESTING #deploy mysql stack
docker stack rm SECRET_TESTING #remove stack 
docker volume ls # check the docker volume
```
It will be available, beacuse of `external=true` this create volume seperately from stack deployment. Hence it is not a part of stack. So even if we remove stack, still the volume persists and db data also persisits. now login to adminer and perform CRUD operations. check the volume data after deleteing the stack.

** It is recommended that we need to use `shared storage systems` instead of `volumes` because in docker swarm we are attaching it to a node/manager/worker. If that particular device is down then volumes can't be accessed
# Docker Swarm Configs
It is used to save non-sensitive information.

* Lets take docker image, in that config files are present(ex-Java config.properties file) where application settings will be available(like ip-address,variables etc). We need to include that file in docker image and need to build it. If that file changes frequently, we need to build the docker image every time just for a file change. This can be a problem and its annoying.

* So we can somehow decouple that config.properties file from docker image, edit the changes and provide the file at the time of creation of service. That where the `Docker Configs` comes to play. 

* Create a docker service, which pulls the nginx docker image from docker hub (or also build docker image locally and provide it) and deploy it on port `8080`. We can see the nginx default page saying "Welcome to nginx!". 
```bash
docker service create --name nginx001 -p 8080:80 nginx:latest
```
* But i want to change that index.html file, now create a seperate file called `index.html` in docker leader and create docker config.
```bash
docker config create myindexfile1 index.html
docker config inspect myindexfile1
[
    {
        "ID": "q11vy7t3rrslqnlxdwk4toocl",
        "Version": {
            "Index": 101
        },
        "CreatedAt": "2023-02-15T11:26:18.023285584Z",
        "UpdatedAt": "2023-02-15T11:26:18.023285584Z",
        "Spec": {
            "Name": "myindexfile1",
            "Labels": {},
            "Data": "PCFET0NUWVBFIGh0bWw+CjxodG1sPgo8Ym9keT4KCjxoMT5QYXZhbjwvaDE+Cgo8cD5UZXN0aW5nIERvY2tlciBjb25maWdzPC9wPgoKPC9ib2R5Pgo8L2h0bWw+Cg=="
        }
    }
]
```
Inspect the config file, which gives you data above json format.If we observe that `Data` key consists of vale which is nothing but `base64` format of `index.html` file. Open any browser and decode that base64 string, you can see the contents of newly changed index.html file

* Now create a service and provide the latest index.html file
```bash
docker service create --name nginx1 --config src=myindexfile1,target=/usr/share/nginx/html/index.html --publish 8080:80 nginx:latest
```
Now if we access its public ip on port 8080 we can see the latest updated index.html file, but again the proble comes that every time we need to update that index.html file, we need to stop the service and start again. Thats not a acceptable solution, so instead of creating service everytime we use `update` flag

```bash
docker config create myindexfile2 index.html 
docker service update --config-rm myindexfile1 --config-add src=myindexfile2,target=/usr/share/nginx/html/index.html nginx1
```
* We can also provide `multiple configs` in a single service
```bash
docker service create --name nginx1 \
 --config src=nginxindex1,target=/usr/share/nginx/html/index.html \
 --config src=nginxconf1,target=/etc/nginx/conf.d/default.conf \
 --publish 9100:80 \
 --publish 9000:88 sreeharshav/rollingupdate:v5
```
* We can also mount certificates as well with cofnig. Create a file with a sample certificate as shown below with filename as hello.pem
-----BEGIN CERTIFICATE-----
MIIESTCCAzGgAwIBAgITBntQXCplJ7wevi2i0ZmY7bibLDANBgkqhkiG9w0BAQsF
CAYGZ4EMAQIBMA0GCSqGSIb3DQEBCwUAA4IBAQAfsaEKwn17DjAbi/Die0etn+PE
gfY/I6s8NLWkxGAOUfW2o+vVowNARRVjaIGdrhAfeWHkZI6q2pI0x/IJYmymmcWa
ZaW/2R7DvQDtxCkFkVaxUeHvENm6IyqVhf6Q5oN12kDSrJozzx7I7tHjhBK7V5Xo
-----END CERTIFICATE-----

docker config create hellocrt hello.pem
docker service create --name nginx3 --config src=hellocrt,target=/etc/ssl/certs/hello.crt --publish 9100:80 sreeharshav/rollingupdate:v5

### Replicas and Global modes

When we are creating a docker service we are providing `replicas <n>`, which creates <n> replicas of containers
```bash
docker service create --name nginx001 --replicas 5 --publish 8080:80 nginx:latest
```
similary there is another mode called `global` which runs the containers in each docker hosts 1:1, instead of running multiple containers in a single docker host
```bash
docker service create --name nginx001 --replicas 5 --publish 8080:80 --mode global nginx:latest
```
replicas 5 - in kubernetes it is called as `replica set`
global - in kubernetes it is called as `daemon set`