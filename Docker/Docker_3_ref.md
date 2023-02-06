# Docker Part 3 - Working with docker commands 

### Difference between `CMD` and `ENTRYPOINT`

* Create [Dockerfile](https://github.com/ModernVishwamithra/DevOps/blob/main/Docker/Dockerfile) 
and instructions to perform installing tools, copy the scripting files to destinations.

* Now add this instruction `CMD ["ping", "-c 3", "www.facebook.com"]` without ENDPOINT. 

* when you try to build and run the dockerfie
```bash
docker build -t pavanutils:v1 .
docker run --rm -d --name myutils --publish 8000:80 pavanutils:v1
```
It will ping facebook for 3 times.

* You can override the CMD arguments by passing in command line 
```bash
docker run --rm -d --name myutils --publish 8000:80 pavanutils:v1 ping -c 5 www.facebook.com
docker run --rm -d --name myutils --publish 8000:80 pavanutils:v1 ping -c 2 www.google.com
```
We can see that when we try to run the commands it overdides the default arduguments and pins the facebook for 5 times & google for 2 times.

* Now replace the `CMD` with `ENTRYPOINT` and run the same commands as above, it throws error.Beacuse we can't override the arguments of `ENDPOINT`

* You can use both `CMD` and `ENDPOINT` together. Like
ENTRYPOINT [ "ping", "-c 3" ]
CMD ["www.facebook.com"] 

```bash
docker run --rm -d --name myutils --publish 8000:80 pavanutils:v1
docker run --rm -d --name myutils --publish 8000:80 pavanutils:v1 ping -c 2
docker run --rm -d --name myutils --publish 8000:80 pavanutils:v1 www.google.com
```
When the first command runs, it pins the facebook for 3 times, the second command throws the error beacuse we are trying to override `ENDPOINT` arguments, the third command overrides the `CMD` argument and pings google for 3 times. 

--------

```bash
docker run --rm -d --name myutils --publish 8000:80 pavanutils:v1
```
Observe that we are giving container name and port in which the container needs to run has been specificed. If we try to run the same command again it needs to create another container, but instead it shows error saying that `name aleady exists also port already used`. Hence, We cant use same name and port for running multiple containers
----------

### Passing arguments
* In [Dockerfile](https://github.com/ModernVishwamithra/DevOps/blob/main/Docker/Dockerfile) we have seen the instaruction called `ARG`, which acts as a variable.

* Just like variable precedence in terraform, we can also override the default value of `ARG` by using `build-args`
Suppose in the [Dockerfile](https://github.com/ModernVishwamithra/DevOps/blob/main/Docker/Dockerfile) we have one instruction named `ARG VERSION='1.3.7'`, we can override this argument while building dockerfile as follows

```bash
docker build -t  pavanutils:v2 --build-args VERSION='1.2.9'
```
The above commands replaces the old version with new version

* Similarly we can also override the environmment variables
```bash
docker run --rm -d -e AWS_ACCESS_KEY_ID="xxxxx" -e AWS_SECRET_ACCESS_KEY='yyyyy' --name myutils -p 8080:80 pavanutils:v1
```
This overrides the defalut `ENV` variable values
-----------

### Pushing local built images to docker-hub repository**
[Refer this tutorial](https://www.cloudbees.com/blog/using-docker-push-to-publish-images-to-dockerhub)

Syntax :- docker tag local-image:tag-name username/reponame:tagname
    - docker tag pavanutils:v5 pavan961/myutils:latest
    - docker push pavan961/myutils:latest