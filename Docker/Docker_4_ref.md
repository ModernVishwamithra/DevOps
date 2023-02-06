# Docker Part 4 

### Python flask
* Create a [python-flask] folder and create a [Dockerfile] new docker file 
* Write instructions to build a custom dockerfile which consists of python 3.8 as a base image.
* when we try to enter into conainer
```bash
docker ecec -it myutils:v1 /bin/bash
```

It takes you to default location as container-name. To change the default location we use `WORKDIR` 

* Also everytime we enter into container, it let you in as a root user. To change that we created new user group named `user`  and created new user named `user`

* Remember that we need to giver `USER` instruction at the end of dockerfile, because the previous instructions needs to run with root previleges.

* Now [requirements.txt] file consists of plugin need to be installed for python and flask to work.

* Build the image and run the docker file. 
    - ec2-3-145-169-212.us-east-2.compute.amazonaws.com:5000 
    - ec2-3-145-169-212.us-east-2.compute.amazonaws.com:5000/megastar
    - ec2-3-145-169-212.us-east-2.compute.amazonaws.com:5000/superstar

We can see the pages mentioned in [app.py]


* When we try to enter into conatiner
```bash
docker exec -it flask:v1 /bin/bash
```

It will let you in as `user` and default directory as `app`. Try to access sudo, it throws permission denied.

### Multistage docker file
[Multistage dockerfile](https://earthly.dev/blog/docker-multistage/)

* After reading above article we come to know that the advantage of multistage dockerfile.The article summary tells us that by using mutistage docker file we can reduce the size of the final image and less prone to security threats.

* We will create a simple multistage docker file [Dockerfile.Multi](https://github.com/ModernVishwamithra/DevOps/blob/main/Docker/python-flask/Dockerfile.Multi). 

* As mutistage docker file consists of multiple `FROM`s and the last `FROM` builds the final image. 
* First `FROM`(stage 0) pull python base image and install all the necessary packeges which are place din [requirements.txt](https://github.com/ModernVishwamithra/DevOps/blob/main/Docker/python-flask/requirements.txt) file.

* Second `FROM` (state 1) pulls the [pylint](https://hub.docker.com/r/cytopia/pylint) base image and apply the linting(checks the code effectiveness and give suggestions) on the code which is copied from the previous stage 0.

* Third `FROM` (stage 2) builds the final image. If errors occured we can remodify the code and build again.

```bash
docker build -t multistage:v1 -f Dockerfile.Multi .
```
