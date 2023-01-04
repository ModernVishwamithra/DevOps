# Packer AMI Automation

Packer is a opensource tool from [Hashicorp](https://developer.hashicorp.com/) which is used to create identical machine images to multiple platforms using single source configuration

Before going into this, please read the [Packer terminology](https://developer.hashicorp.com/packer/docs/terminology)
### Steps to create custom AMI using AWS (Console based)

1. Create a EC2 instance
2. Log in to EC2 instance
3. Install necessary plugins or tools into the instance
4. Shutdown the EC2 instance
5. Create AMI
6. Delete the EC2 instance

The above steps can be automated using packer CLI. To use that download the [Packer binary](https://developer.hashicorp.com/packer/downloads).

We need to create a file either in `.json` or `.hcl` format. Here we are using .json

### Steps to create custom AMI using AWS (Template/code based)

1. Create VPC, subnets, SG, IGW, RT manually in AWS console.
2. Create `packer-vars.json`,`packer.json` files and add the variables to pass to `packer.json` file
3. Copy the values from the console and assign them to respected variables.
4. `Packer.json` is a template file that consists of 
    * `builders` - which uses AWS variable values to launch an EC2 instance. [refer this for clarity](https://developer.hashicorp.com/packer/docs/terminology#builders)
    * `provisioners` - these are the components of packer which do the most work like running scripts/commands, copies files, etc while instance is running [refer this for clarity](https://developer.hashicorp.com/packer/docs/terminology#provisioners).
    
    In this provisioners `first` is shell, which do the following
        - wait for 15 seconds to let instance bootup
        - create a user called `ansibleadmin` which was added to /bin/bash folder
        - created a dir `.ssh` in /home/ansibleadmin/ directory
        - changed the ownership of the directory, given access to this directory to the user `ansibleadmin` 
        - created a folder called `authorized_keys` in /home/ansibleadmin/.ssh directory
        - Apeended `ansibleadmin` user to sudo group
        - disabled the password interaction to sudo user `ansibleadmin` and added to /etc/sudoers, which means users in this sudoers can execute any command
        - added two public-keys, by using which we can login and check the scripts executed successfully or not
        - excute docker script from url [https://get.docker.com]
    
    The `Second` provisioner is `file`, which copies the `docker.service` file from the local machine and copy it in the remote packer image folder /tmp/docker.service

    The `third` provisioner is shell again, but this time it does the following
        - Copy the docker.service file from the temp to /lib/systemd/system/ folder(this folder is responsible to save service files)
        - add the user `ubuntu` to the group `docker` #(usermod -a -G GROUP USER)
        - relod the `daemon` (Reload the systemd manager configuration. This will rerun all generators (see
       systemd.generator(7)), reload all unit files, and recreate the entire
       dependency tree. While the daemon is being reloaded, all sockets systemd
       listens on behalf of user configuration will stay accessible.)
       - restart the docker service

5. We have done with the packer.json template file, now we need to check(validate) that template is correct or not. Copy the downloaded `packer.exe` binary file in the current folder and check it is properly downloaded or not by running this `.\packer.exe`, if you can see some packer commands then it is downloded properly

6. To run the validation, we need to provide credentials for AWS, there are multiple ways to provide to packer [refer this](https://medium.com/techno101/packer-a-complete-guide-with-example-cf062b7495eb)

    - One is `.\packer.exe validate(or build) -var \"aws_access_key=xxxx\" packer.json` and
    `.\packer.exe validate(or build) -var \"aws_secret_key=xxxx\" packer.json`
    - Other way is to provide in packer variables
    - Another is through environmental variables
    - Shared credentials
    - run `aws configure` and provide credentials

7. Now run this command `.\packer.exe validate --var-file packer-vars.json packer.json` to validate the template file. If you get this message `The configuration is valid.` then syntax is correct.

> [Problem] 
>> - "ssh_interface": "public_ip",
>> - "associate_public_ip_address": true,
>> - "security_group_id":"{{user `security_group_id`}}",

> Sometimes life wont goes easy, i tried to build the packer.json file without those 3 lines, everytime i tried to build it shows "Waiting for SSH connection" and gets finished without creatng AMI. I tried multiple ways changed VPC settings, subnets, SG etc beacuse everytime instance is launching it is not assigned with public ip. After `2 hours` of debugging i found the each of above lines in different website. I was almost given up but i tried   one last time.. :-)

8. Run this command `.\packer.exe build --var-file packer-vars.json packer.json` which creates instance, login into it, execute the script, shutdown the instance, create AMI and terminate the instance.

9. Once terminated go to aws console and check in the AMIs tab, we can find the created AMIs "owned by me". Now we have successfully created AMI and we need to use this AMI to deploy infrastructure using terraform.

10. Open `main.tf` and observe the `data` source, by using which we are importing AMI id created recently. By using that AMI ID we will deploy instances. 

11. Here one thing to note is we can give AMI id directy in the code or import it. The probelm with direct hard coding the AMI id is not recommended beacuse if we create another AMI using packer we need to change it manaully again. Second way is useful in the following scenario.Suppose we have created 2 AMIs and we need to take recent one to deploy infrastructure. For that we are using `most_recent = true` which takes the latest created AMIs and also we use `name_regex  = "^AMI_Image_Name"` to filter with name.

12. Another scenario is suppose we have created AMI, We came to know that after deploying infrastructure, DB etc in 100 servers but we came to know that AMI is vulnerable, so we did some modifications and created 2nd AMI. Now if we try to deploy infrastructre, 100 servers will be destroyed and replaced with new(2nd) AMI. Its a data loss. Then the other way is create new 100 servers seperately without deleting the oldone's. Again this solution is not cost-effective and not a acceptable solution. So Somehow we need to do some changes/fixes to the old servers- This is called configuration management. Packer(only used for AMI automation) nor terraform(only used to deploy infra and few changes can be done by using `remote-exec`) won't support this. 

Thats were configuration management tools came into the picture, Majority of the companies uses `Ansible` beacuse it is free and open-source.