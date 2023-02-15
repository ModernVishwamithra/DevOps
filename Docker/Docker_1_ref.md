# Docker Part 1
## Monolithic vs Microservices

To understand the docker, we need to look into the application architecture types first - [Monolithic and Microservices](https://www.atlassian.com/microservices/microservices-architecture/microservices-vs-monolith#:~:text=A%20monolithic%20application%20is%20built,of%20smaller%2C%20independently%20deployable%20services.)

**Monolitic** - This architecture based applications were built as a unified unit and modules of it will be interconnected to each other. We can take banking application as an example, it has several modules - Home, personal,auto:loans, Personal banking, Credit/debit card services etc. These services are coupled with each other and was built using single code base i.e Java, Python etc. There are advantages and limitations of this architecture

**Advantages* - Easy deployment, Easy to Develop, Performance, Simplified testing, Easy debugging

**Limitations* - Slower development speed, Scalability(Individual components can't be scaled), Reliability(A small error can affect entire code), Barrier to technology adoption(changes takes time and risk).

**Micro-services** - This architecture based applications were built as a decentralized modules and are independent on each other. Swiggy,Uber are some exapmles uses this microservices. They are built with different code bases. As the modules inside the applications are independent on each other whch has several notable advantages over limitations.

**Advantages* - Agility, Flexible scaling, Continuous deployment, Highly maintainable and testable, Independently deployable, Technology flexibility, High reliability, Happier teams.

**Limitations* - Development sprawl, Exponential infrastructure costs, Added organizational overhead, Debugging challenges, Lack of standardization, Lack of clear ownership

----------
# Conainers

Containers are packages of software that contain all of the necessary elements to run in any environment. In this way, containers virtualize the operating system and run anywhere, from a private data center to the public cloud or even on a developer’s personal laptop.

![Containarization](https://substackcdn.com/image/fetch/f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fbucketeer-e05bbc84-baa3-437e-9518-adb32be77984.s3.amazonaws.com%2Fpublic%2Fimages%2F14409324-6525-49f9-85b5-ea416d4efffb_2556x1383.jpeg)

Containariaztion is very similar to virtualization with few differences. As we already knows `Hypervisor` creates VMs from the underlying hardware(logically divide hardware into multiple identical hardwares), whereas `container` seperates the software from other containers(softwares) usually in linux using its kernal features called [namespaces and cgroups](https://jvns.ca/blog/2016/10/10/what-even-is-a-container/). 


# Docker container Engine

```bash
apt update && apt install -y net-tools jq unzip
ifconfig
```
If we run `ifconfig` we can see that ethernet(network) port is only `one` 

```bash
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 9001
        inet 10.1.1.48  netmask 255.255.240.0  broadcast 10.1.15.255
        inet6 fe80::26:fbff:fe67:d750  prefixlen 64  scopeid 0x20<link>
        ether 02:26:fb:67:d7:50  txqueuelen 1000  (Ethernet)
        RX packets 19443  bytes 27546348 (27.5 MB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 2651  bytes 304811 (304.8 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 118  bytes 10986 (10.9 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 118  bytes 10986 (10.9 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

but after installing docker we can see a bridge network created by docker. For installing docker

```bash
curl https://get.docker.com | bash
```
run `docker version` command and will get the following O/P

```bash
Client: Docker Engine - Community
 Version:           20.10.23
 API version:       1.41
 Go version:        go1.18.10
 Git commit:        7155243
 Built:             Thu Jan 19 17:36:25 2023
 OS/Arch:           linux/amd64
 Context:           default
 Experimental:      true

Server: Docker Engine - Community
 Engine:
  Version:          20.10.23
  API version:      1.41 (minimum version 1.12)
  Go version:       go1.18.10
  Git commit:       6051f14
  Built:            Thu Jan 19 17:34:14 2023
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.6.15
  GitCommit:        5b842e528e99d4d4c1686467debf2bd4b88ecd86
 runc:
  Version:          1.1.4
  GitCommit:        v1.1.4-0-g5fd4c4d
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0
```

![Docker architecture](https://docs.docker.com/engine/images/architecture.svg)

Usually docker images are stored in docker registry, when we try to use docker client to pull the image it will connect to docker daemon(server) where containers will run.

run `ifconfig`

```bash
docker0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        inet 172.17.0.1  netmask 255.255.0.0  broadcast 172.17.255.255
        ether 02:42:17:d7:31:2c  txqueuelen 0  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 9001
        inet 10.1.1.48  netmask 255.255.240.0  broadcast 10.1.15.255
        inet6 fe80::26:fbff:fe67:d750  prefixlen 64  scopeid 0x20<link>
        ether 02:26:fb:67:d7:50  txqueuelen 1000  (Ethernet)
        RX packets 99456  bytes 144720626 (144.7 MB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 6117  bytes 588476 (588.4 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 180  bytes 18800 (18.8 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 180  bytes 18800 (18.8 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```
When we want connect docker client to local system
```bash
docker ps
```

When we want connect docker client to local system
```bash
docker -H 10.1.1.100 ps
```
When we want see docker images
```bash
docker images
```
You wont find any images in our machine. Usually docker base images (like nginx, mysql etc) are stored in public registry called [Docker Hub](https://hub.docker.com). Its open to public, but to download them we need to signup in their website.

Once downloaded from docker hub, we can customize the image and can be uploaded into private registries(AWS- ECR, Azure - ACR, Google - GCR & Artifats registry, or our own/company server private registry)

![Docker registry](https://github.com/ModernVishwamithra/DevOps/blob/main/Docker/images/doker-registry.png) 

An important thing to remember is that when docker is installed `3` networks will be created default.
```bash
$ docker network ls

NETWORK ID     NAME      DRIVER    SCOPE
f8995e93f8dd   bridge    bridge    local
0b5bab46d576   host      host      local
7a56dbdf13a1   none      null      local

```

What is this bridge network purpose(host and null won't be used much at this point). 

![Docker Port Forwarding](https://github.com/ModernVishwamithra/DevOps/blob/main/Docker/images/docker-port-forwarding.png)

In the above image, it is clearly represents that `docker bridge network` connects as a brige between `eth0` and `docker containers`. When clients wants to connects to these containers through internet, traffic has to pass through `eth0 --> bridge NW --> container image`. Here the challenge is if you observer container 1 and 3 has port numbers as it is having port nmubers same it leads to conflict that to which container has to connect. To address this challenge we have `port forwarding` concept, in which we assign seperate port numbers for each of the containers (8000,8080,9000 like that) then it will be easy for brige network to route the traffic.

[Refer this link for more clarity](https://docs.docker.com/network/bridge/)

------------------