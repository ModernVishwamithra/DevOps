# Docker Part 2 - Creating custom docker image

* Create [Dockerfile] and nginix webserver files.
* In [Dockerfile] it is always starts with `FROM` command which tells us to take reference from.
* Give docker instructions to install nginx, terraform on uuntu 20.04 machine
* Once finished, update to github and pull it on the instance. 
* Run docker build coomand `docker build -t pavan/nginx:v1 .` to build the custom image.
* When the docker build is running, additional, read-only layers with auto assigned id's will be created. 
* Instructions `RUN`. `COPY`, `ADD` commands are responsible to create more layers [refer this article for better understanding](https://bobcares.com/blog/docker-layers-explained/#:~:text=The%20Docker%20layers%20are%20the%20fundamental%20building%20blocks,instructions%20create%20a%20layer%20such%3A%20RUN%2C%20COPY%2C%20ADD.)
* Once build is successfull, run the docker command
    - docker run -it pavan/Nginx:v1 
* It creates a container, but it wont run the container initially(we havedn't added CMD/ENTRYPOINT command). It lets you in to tht conainer image and check the versions of the applications installed successfully or not.
* To check this run `docker ps`, we won't find any containers running. 
* Instead we try with `docker run -d pavan/Nginx:v1`. If we check `docker ps -a` we can find that container created and exited status.
* To run the created container we need to use `CMD` or `ENTRYPOINT` instructions, which tells us to run the particular application.
* Remove the previous built image using `docker rmi image-id`, and build the docker image and run the dcoker image `docker run -it pavan/Nginx:v1`, he container will run but it gets default name `human-behaviour_scientist_name`. But we can't connect to this conatiner as we have not port forwarded it(published it)
* To publish and give a name to container
    - `docker run -d --name nginx001 --publish 8080:80 pavan/nginx:v1`
* Now try to run the `docker ps`, we can see container is running.
* In docker instruction we have used `ARG`, insted we can give it directly in running docker command
    - `docker build -it pavan/nginx:v1 --build-agrs VERSION="1.3.7" .`
