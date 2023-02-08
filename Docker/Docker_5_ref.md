# Docker Part 5 - Data Persistance (Data Volumes and Bindmounts)

### Docker Volumes

* All the containers are designed as `stateless`, means when we run a container and do some changes in the container, stop and run the container. The modified data will be erased.

* Pull docker image from docker hub and run the image. Change some names in nginx index.html file. Now stop the container, run the container, the previously changed data will be gone.

* To save these data, `Docker volumes` has been introduced.
* Create a new volume and attach to docker host(EC2 instance)
* Mount that volume to `/DockerData`
```bash
lsblk - list the volumes
fdisk /dev/xvdf - formats the disk
mkfs.ext4 /dev/xvdf1 - creates ext4 volume
mkdir /DockerData
blkid - copy the volume id `UID` of xvdf1
nano /etc/fstab
```
To mount the volume on `/DockerData` save the following in the fstab
`UID without ""  /DockerData      ext4    defaults,discard    0 1`

```bash
mount -a
lsblk
df -h
```

* We can see that volume is mounted on /DockerData directory. Now we need to change the default directory of docker to `/DockerData`

[Refer this link for the process](https://linuxconfig.org/how-to-move-docker-s-default-var-lib-docker-to-another-directory-on-ubuntu-debian-linux)

* Once changed the default directory, check the directory 
```bash
ls /DockerData
```

we can find the docker related directories in that folder. When we want to staore any container data, it is going stored in `volume/_data` subdirectory.

* We can create multiple sub volumes to store seperate data 
```bash
docker volume create testvol1
docker volume create testvol2
docker volume create testvol3
```

* When we run the container, we can attach this volume. For that we initially create a `index.html` file sample data
```bash
cd /Dockerdata/volumes/testvol1/_data/
nano index.html
```
copy the 
```html
<!DOCTYPE html>
<html>
<body>

<h1>Pavan Kumar Pacharla</h1>
<p>Testing Docker Volumes</p>

</body>
</html>
```

* Pull the docker image and attach the testvol1
```bash
docker pull sreeharshav/rollingupdate:v5
docker run --rm -d  --name nginx002 -v testvol1:/usr/share/nginx/html/ -p 8080:80 sreeharshav/rollingupdate:v5
```
    -- testvol1:/usr/share/nginx/html/  which indicates that testvol1 is mounting on /usr/share/nginx/html/
* When you connect docker host `http://ec2-3-22-68-5.us-east-2.compute.amazonaws.com:8080/` you can see html page we created .

* We are using volumes to make data persistance(available even after container deleted/stopped). To test this edit `index.html` file and modify some content. Again reload the server `http://ec2-3-22-68-5.us-east-2.compute.amazonaws.com:8080/`, we can observe the modified changes reflected in the page.

* Lets stop the contatiner.  Check the index.html file , we can see that data changed still remains.
```bash
docker exec -it nginx002 /bin/bash
cat /usr/share/nginx/html/index.html
```
-------------------------------------
* Till now we have worked with `html` files to check data persistance, lets work with some `mysql` database.
* First create a custom volume for mysql
```bash
docker volume create mysql_data
```
* Go to hub.docker.com to find [mysql](https://hub.docker.com/_/mysql). In that official documentation, we can find how to run that docker image. Based on that i have customized like this

```bash
docker run --rm --name mysql01 -v mysql_data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=India@123 -d mysql:latest
docker exec -it mysql01 /bin/bash
mysql -u root -p
```
It will ask you password type `India@123` and it lets you into db.

* Now open `Myflixdb` resource file where it consists of sample data to be created in db. paste that data into the container, it creates db.

* Once data is loaded, check it is copied successfully
```bash
mysql> use myflixdb;show tables;select * from movies;
```
Which shows the movies. now insert some data into it to check the data persistance.

```db
INSERT INTO `movies` VALUES (100,'Pirates of the Caribean 40',' Rob Marshall',2023,1);
INSERT INTO `movies` VALUES (101,'Pirates of the Caribean 41',' Rob Marshall',2023,1);
INSERT INTO `movies` VALUES (103,'Pirates of the Caribean 42',' Rob Marshall',2023,1);
INSERT INTO `movies` VALUES (104,'Pirates of the Caribean 43',' Rob Marshall',2023,1);
INSERT INTO `movies` VALUES (105,'Pirates of the Caribean 44',' Rob Marshall',2023,1);
```
* Lets stop the container, and re-run and check the newly data- exists.

----------------------
* Instead of logging and testing the data by CLI, we can perform CRUD operation using browser GUI. For that we have a docker image called [Adminer](https://hub.docker.com/_/adminer).
* Run the adminer service
```bash
docker run --rm -d --name mysqladminer -p 8080:8080 adminer:latest
```
* To connect adminer and mysql we need `mysql image server ip`
```bash
docker inspect b77e108972c2 - (mysql cointainer id)
```
we get the `"IPAddress": "172.17.0.2"`, copy the ip and paste in the server value in the adminer. 
To login use username as `root` and password as `India@123`. It will log-in and you can perform manual CRUD or command based CRUD operations.

* The problem with the above method is, when we are trying connecting to the db with `ip`. Suppose the `mysql` container deleted and recreated by other person. Data persists but ip address changes. Now again you need to find its ip address and login to adminer again.

* Instead we need to connect mysql server through its `name`. Lets test the ping.
```bash
docker run --rm -d --name utils sreeharshav:utils
docker exec --it utils /bin/bash
ping mysqladminer
```
it shows ` Name or service not known`. Because by default docker uses `bridge` network to communicate with containers and it `won't allow hostname resolutions`

```bash
docke network ls
```

NETWORK ID     NAME      DRIVER    SCOPE
b5d709bb7f69   bridge    bridge    local
0b5bab46d576   host      host      local
7a56dbdf13a1   none      null      local

* Hence we need to create our own network 
```bash
docker network create mysql_nw --driver 
    -- bridge ipvlan macvlan overlay (select bridge for driver)
docker network create mysql_nw --driver bridge
docker network ls

NETWORK ID     NAME       DRIVER    SCOPE
b5d709bb7f69   bridge     bridge    local  -- acts as default gateway
0b5bab46d576   host       host      local  -- shares host ip address
bf7c324ea300   mysql_nw   bridge    local
7a56dbdf13a1   none       null      local  -- no interface will be created
```
* Now we have created `mysql_nw` and we can connect this to any container/many containers
```bash
docker network connect mysql_nw mysql01
docker network connect mysql_nw mysqladminer
docker network connect mysql_nw utils
```

or 

we can directly give in the docker run command

```bash
docker run --rm --name mysql01 -v mysql_data:/var/lib/mysql --network mysql_nw -e MYSQL_ROOT_PASSWORD=India@123 -d mysql:latest
```
We can connect all the containers and successfully communicate with them also in adminer. Login with name `mysql01` instead of ip.

* If you want to delete unused containers/ voulumes
```bash
docker network prune
docker volume prune
```
It will promt y/n to remove them
-----
### Docker bindmounts
Refer this [Volumes and Bindmounts](https://docs.docker.com/storage/volumes/)
