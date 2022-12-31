#                           Provisioners

-- file provisioners - Related to EC2 - usually uses to copy files to remote machine
-- remote-exec - login and execute the file in the remote machine
-- local-exec - execute the script/file from the machine where terraform is running

When you want to copy one file from local machine to remote machine, we can use **provisioner "file"**, for that we need to provide **source**-  from where to get the file, **destination** - where to copy the file, **connection** - giving access to instance using either password or private_key.

Here we have created **"script.sh"** file in local machine, current folder and given that file in terraform file provisioner to copy that into **/tmp** folder of remote machine

As the file is a script file we need to execute the script from terraform, for that we are using **provisioner "remote-exec"** which executes the script form the given path, we also need to provide access the instance through connection block.

But the problem with this method is when script changes, we need to run the updated script in remote machine. But terraform file provisioner associated with instance. If we try to run **terraform apply**, as terraform checks the state file and checks with the resouce files is there any changes, it shows nothing to change.

We clearly know that we updated the "script.sh" file but it is not a resource file, terraform checks only resource files, script file is not resource file, hence it wont update this file. The how to solve this proble.

One thing is we need to re-create the instance by using **terraform taint tf-resource-name**, we taint the instance, when we run **terraform apply** it recreates tainted instance only. Here again problem occured. Suppose if the instance is newly created and nothing is installed it is fine to re-create. but if we installed already some db, or apps then if we try to re-create server then everything in the server will be destroyed. 

So other acceptable solution is **terrform null_resource**