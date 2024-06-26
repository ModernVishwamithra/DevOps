#                                       Ansible Part-1

[doc reference](https://docs.ansible.com/ansible-core/devel/index.html)

1. Launch a server with the custom AMI we have created with packer(`ansibleadmin` as user) and add assume role to this instance.

2. Install the ansible controller with the following commands

    --$ sudo apt update
    --$ sudo apt install software-properties-common
    --$ sudo add-apt-repository --yes --update ppa:ansible/ansible
    --$ sudo apt install ansible

Ansible controller can't able to run on windows natively and we can only use winows as a ansible clinet which means we can configure windows as a client machine, though there is concept called WSL(Windows Subsystem for Linux). All the coonections between controller and client uses `SSH` connection

![Ansible Controller Support](https://github.com/ModernVishwamithra/DevOps/blob/main/Ansible/images/ansible-controller.png)

3. Once the installation is done, validate installation by running `ansible --version` command. It shows the ansible configured paths.

4. Ansible configuration file is present in this path `/etc/ansible/ansible.cfg`, by default this file has so many parameters and are in disabled state. We need to enable required parameters, but to edit them we need to unlock the ansible.cfg file(by default it is disbaled) it by running the following command ` ansible-config init --disabled > /etc/ansible/ansible.cfg` we have unlocked it. **Run the above command as root user (sudo su -)**

5. Type `nano /etc/ansible/ansible.cfg` and press `ctl+w` to search the term `host_key_checking`, when you found it by default it is in commented(;) and its value is 'True'. We need to make its value 'False' and uncomment it by removing semicolon(;) infront of it.

6. Similarly search for `remote_user`, uncomment it and set the value as `ansibleadmin`. By setting this value "Ansible controller" connects with the client with this username.

7. Now install `unzip` and [Terraform](https://developer.hashicorp.com/terraform/downloads) binary amd64, unzip it,move the binary to /usr/local/bin and delete the downloaded zip file.

8. In vscode, Create `local_files.tf` and `template.tpl` files, which we already used them in the terraform provisioners. This creates `invfile` that consists of all the public ip's of the instances.

9. In the 'Ansible controller' we need to use terraform to deploy instances(ansible clients) and connect them to ansible controller.

10. Write the terraform code to deploy 3 instances with the custom AMI ID(which was created for packer) and push to github. Install `git` in ansible controller server

11. Generate rsa_pub key using `ssh-keygen` and add that key in the github keys. Clone the repository in the `Ansible controller server` and run the terraform commands `fmr`, `validate`, `plan`, `apply`. 

12. Once infrastructure is deployed, we can observe that a `invfile` is created locally in the `ansible controller` server, if we read that file we can see the public ip's of all the 3 instances.
{
    [allservers]
    ansibleclient01 ansible_port=22 ansible_host=3.15.2.170
    ansibleclient02 ansible_port=22 ansible_host=18.221.99.135
    ansibleclient03 ansible_port=22 ansible_host=18.224.39.155
}

13. Now `Ansible controller` needs to connect to it either individually or all at time. To do that we run a command 
**`ansible -i invfile allservers -m ping`**. Instead of connecting it throws an error for all 3 instances

------
    ansibleclient01 | UNREACHABLE! => {
        "changed": false,
        "msg": "Failed to connect to the host via ssh: Warning: Permanently added '3.15.2.170' (ED25519) to the list of known hosts.\r\nansibleadmin@3.15.2.170: Permission denied (publickey).",
        "unreachable": true
    }
-----

Refer this link to [Manage Mulple SSH keys](https://www.freecodecamp.org/news/how-to-manage-multiple-ssh-keys/)

git 2.10 or later, to support multiple ssh keys configure git with new key using the following command

    -- eval $(ssh-agent) 
-everytime server reboots this ssh-agent service is stopped, we need to restart it by running this command
    
    -- ssh-add ~/.ssh/gitrsa (your_custom_generated_private_key)
-Add your custom private key to the agent. Now try to run git commands it has to work,otherwise run the following command

    -- git config core.sshCommand 'ssh -i ~/.ssh/id_rsa_corp'

`ansible -i invfile allservers -m ping`
    --To run ping on [allservers] group

`ansible -i invfile webservers -m ping`
    --To run ping on [webservers] group only

`ansible -i invfile dbservers -m ping`
    --To run ping on [dbservers] group only

`ansible -i invfile appservers -m ping`
    --To run ping on [appservers] group only

`ansible -i invfile all -m ping`
    ----To run ping on all servers
### Ansible adhoc commands

`ansible -i invfile webservers -a uptime` (Here -a represents arguments)
--This command gets the `uptime` of the webservers only, similary `free` gets you memory usage details

`ansible -i invfile ansibleclient03 -a "cat /etc/passwd"`
--In the "" we can given shell commands to run on targeted clinet/or group of clients/or on all clients

-----

Ansible supports modules, which are nothing but pre-defined libraries. [Ansible modules reference](https://docs.ansible.com/ansible/2.9/modules/list_of_all_modules.html)

--Lets take an example to create a user in host machines, for that go to ansible modules --> System modules --> User Module. Then type this command 

    --ansible -i invfile allservers -m user -a "name=testuser state=present shell=/bin/bash"

It will throw error that permission denied(admin/sudo access is required). To give sudo permisiions add `--become` at the end of the command(its is like sudo su -)

    --ansible -i invfile allservers -m user -a "name=testuser state=present shell=/bin/bash" --become

Similarly test the user created or not by running the following command

    --ansible -i invfile allservers -a "cat /etc/passwd" --become

Similarly delete the user by running the following command

    --ansible -i invfile allservers -m user -a "name=testuser state=absent shell=/bin/bash" --become

We can install packages using package module or you use shell module. The following command installs nginx server in all hosts.

    -- ansible -i invfile allservers -m shell -a "apt install -y nginx" --become
-----

But to install softwares, running multiple commands at a time in the hosts we need to use a concept called `ansible-playbooks`. This is a file in which we use commands/keywords to execute the required scripts or functionality. This file extension may be in ``.ini`` or ``.yaml`` formats. Majority are using `.yaml` format, beacuse it is easy to read and write keywords. Also supports many features just like json.

[Read this article once to get started with `YAML`](https://www.cloudbees.com/blog/yaml-tutorial-everything-you-need-get-started)

-- `ansible-playbook -i invfile nginx_playbook.yaml --syntax-check` 
    checks the syntax

-- `ansible-playbook -i invfile nginx_playbook.yaml --check` 
    Dry run

-- `ansible-playbook -i invfile nginx_playbook.yaml` 
    Runs the playbook

You can also add `tags` to the individual plays or tasks. The advantage is that we can run playbook with specific tags only, it means only the code associated with the tag only will run.

-- `ansible-playbook -i invfile nginx_playbook.yaml --list-tags`
  It lists all the tags

-- `ansible-playbook -i invfile nginx_playbook.yaml --tags install,service`
  It runs the playbook code under which these tags `install` and `service` is associated

Added tags 
 -- syntx : git tag -a <tag> <commit-hash> -m <message>
 -- command: `git tag -a 1.0.0 5514579 -m "Added Tags to End Ansible part 1"; git push origin 1.0.0` (or  for multiple tags `git push origin --tags`)

 ----------------------------------------------------------------------
 #                                      Ansible Part-2 
#### Connecting ansible clients using private IP's.
We can connect ansible clients using private IP's using VPc peering. 
1. Create [vpc_peering.tf](https://github.com/ModernVishwamithra/DevOps/blob/main/Ansible/vpc_peering.tf). Import the Ansible controller VPC using data-source and create a peering connection between the controller VPC and client VPC.

2. Add the controller route in clients route table, similarly clients route in controllers route table (for this we need to import controller route table)

3. Change the code in [template.tpl](https://github.com/ModernVishwamithra/DevOps/blob/main/Ansible/template.tpl) & [local_files.tf](https://github.com/ModernVishwamithra/DevOps/blob/main/Ansible/local_files.tf) to capture private IP's of ansible clients and create new a inventory file with updated code `privateservers`.

4. Now push the code to github, start the controller server, clone the reopsitory/git pull, run the command
  -- ansible -i invfile privateservers -m ping
  ----------------------------------------------------------------------
#### Copy files from Ansible controller local folder to ansible clients
To run multiple commands and for more customizations we use ansible-playbooks
1. Create [nginx_copy.yaml](https://github.com/ModernVishwamithra/DevOps/blob/main/Ansible/Playbooks/nginx_copy.yaml) file and create code to install `nginx server` in all clients. 

2. In Ansible controller server go to tmp folder (`cd /tmp/`) and clone the dockertest1 repo (`git clone -b DevOpsB27 https://github.com/ModernVishwamithra/dockertest1.git`) in that tmp folder. Change the contents of`index.html` file if required.

3. Create code to copy a file from Ansible controller `dockertest1` folder(`src=/tmp/dockertest1/index.html`) to all the clients var folder (`dest=/var/www/html/index.nginx-debian.html`)

4. Push the code to github, perform git pull in controller server and run the command
 -- `ansible-playbook -i invfile nginx_copy.yaml --check-syntax`  - cheks syntax

 -- `ansible-playbook -i invfile nginx_copy.yaml --check` - dry run

 -- `ansible-playbook -i invfile nginx_copy.yaml -vv` - execute command with verbose(shows execution info)

5. Test the clients by accessing them using public IP's, we can observe the updated `index.html` page.
------------------------------------------------------------------------
#### Copy files from Ansible controller remote source to ansible clients using **remote_src=true**
The challenge from the above file copying process is that, maually we are creating local files in ansibel controller and giving its path. Instead we can download the files from remote source and perform the copy operation dynamically using `remore_src`

1. Create [nginx-remote-copy.yaml](https://github.com/ModernVishwamithra/DevOps/blob/main/Ansible/Playbooks/nginx-remote-copy.yaml) and create the same code as [nginx_copy.yaml](https://github.com/ModernVishwamithra/DevOps/blob/main/Ansible/Playbooks/nginx_copy.yaml) with small modifications

2. The modifications are
 - Add a new task : cloning latest repo from git hub
 - Add command `remote_src=true`

3.Git push, git pull and run the command 

-- `ansible-playbook -i invfile nginx-remote-copyy.yaml --check-syntax`  - cheks syntax

 -- `ansible-playbook -i invfile nginx-remote-copy.yaml --check` - dry run

 -- `ansible-playbook -i invfile nginx-remote-copy.yaml -vv` - execute command with verbose(shows execution info)

 4. Test the clients by accessing them using public IP's, we can observe the updated `index.html` page.
------------------------------------------------------------------------
#### Working with **handlers**

Evertime when we run ansible commands, some commands executes like nginx restarts evertime. It needs to be restarted onlty there is any file change. To perform it easily we use `notify` and `handlers`. 

1. In the above code add `tags` to each task and at the end of the file add `handlers` with a name, the commands inside this block runs only file is changed.

2. To identify the changes we use `notify` command with same as `handler's name`. This notify commands identifies any chnages occured in the server then it notifies to handler/calls the handler using its name. Then the handler block commands will be executed.

3. Try to do run 

  -- `ansible-playbook -i invfile nginx-remote-copy.yaml -vv` command without and with changes in index.html file, we can see the nginx server restars only when file is changed.
  
------------------------------------------------------------------------
#### Copy files from Ansible client local folder to ansible controller using ***fetch***

Using `fetch` command in ansible we can copy the particular local file(s) of ansible client to ansible controller

1. Create a simpe playbook in [fetch.yaml](https://github.com/ModernVishwamithra/DevOps/blob/main/Ansible/Playbooks/fetch.yaml) file and use `fetch`command to copy file (`src: /var/www/html/index.nginx-debian.html`) from ansible clients to ansible controller (`dest: /tmp`). Check the /tmp folder before running thie below command

2. Run the ansible command

 -- `ansible-playbook -i invfile fetch.yaml -vv`

3. We can observe that in ansible controller's `/tmp` folder is updated with newly created folders with `anslible client names` and copied information in it.
------------------------------------------------------------------------
# Ansible Part 3

#### Ansible Facts and caching the facts

We can gather the information about entire server, called **facts**. We can either use json file or redis server to catch the facts. 

-- `ansible -i invfile privateservers -m setup`

This command will gives all the information of private servers. But the problem is it will load the facts in memory. If there are more servers then disk performace will be bad.

 -- `ansible --version`
 -- `sudo nano /etc/ansible/ansible.cfg`

To capture the facts we need to add the below lines to enable the facts caching in ansible config file (check the path in above commands).

[defaults]
gathering = smart
fact_caching = jsonfile
fact_caching_connection = /tmp/ansible_facts_folder
fact_caching_timeout = 86400

 Using json file we can capture facts but to improve performance, we cache the facts using REDIS( Remote Dictionary Service) server as well.

[Refer this link to know about caching facts using REDIS](https://dev.to/koh_sh/redis-can-make-ansible-only-a-bit-faster-39g7#:~:text=Ansible%20has%20a%20function%20called,every%20time%20you%20run%20Playbook)
#### Jinja Templates

When we register in a platform(ex technical website), after successful registration we will get a mail with some welcome message atttached with website logo and registered user name (Ex Hi Pavan Kumar). Now think of this situation when everytime new user registers into website, they send this common welcome message to everyone with just change in registered user name. In this scenario where they have an application that provides services to many users, and want some personalization for each user on the platform. **Dynamic templates** help us to serve a unique template containing the content corresponding to the user.

![Dynamic Template](https://github.com/ModernVishwamithra/DevOps/blob/main/Ansible/images/jinja.png)

The figure above shows that a generic template is placed, containing a variable rule on the server-side. When this template is rendered on the client-side, an appropriate value is set instead of the rule. This new value is per the context of the application, i.e., information regarding the currently logged-in user. This kind of dynamic behavior of a template is called **dynamic templating**.

**Jinja** is not only a city in the Eastern Region of Uganda and a Japanese temple, but also a template engine. You commonly use **template engines** for web templates that receive dynamic content from the back end and render it as a static page in the front end.

![Ansible Jinja Template example](https://www.packetcoders.io/content/images/2022/08/image1.png)

But you can use Jinja without a web framework running in the background. 

In [jinja_nginx.yaml](https://github.com/ModernVishwamithra/DevOps/blob/main/Ansible/Playbooks/jinja_nginx.yaml) we are assiging few ansible facts to the variables
 -- `vars:
      custom_heading: "Welcome Ansible Jinja Template Testing"
      todays_date: "{{ ansible_facts['date_time']['date'] }}"
      host_name: "{{ ansible_facts['hostname'] }}"
      fqdn_name: "{{ ansible_facts['fqdn'] }}"
      os_family: "{{ ansible_facts['distribution'] }}"
      os_dest: "{{ ansible_facts['distribution_version'] }}"
      ip_address: "{{ ansible_facts['eth0']['ipv4']['address'] }}"

In [index.j2](https://github.com/ModernVishwamithra/DevOps/blob/main/Ansible/Playbooks/index.j2), this is the jinja template which displays the custom values of the ansible clients. 
    -- <h1>{{ custom_heading }}</h1>
    -- <h1> Todays date is: {{ todays_date }} </h1>
    -- <h1> Server hostname is: {{ host_name }} </h1>
    -- <h1> Server FQDN is: {{ fqdn_name }} </h1>
    -- <h1> Server IP Address is: {{ ip_address }} </h1>
    -- <h1> Server OS Flavor: {{ os_family }} </h1>
    -- <h1> Server OS Version is: {{ os_dest }} </h1>

[scorekeeper.js](https://github.com/ModernVishwamithra/DevOps/blob/main/Ansible/Playbooks/scorekeeper.js) and [style.css](https://github.com/ModernVishwamithra/DevOps/blob/main/Ansible/Playbooks/style.css) are customization files to jinja template

We can observe that the values are different for each ansible clients, but we are using common template to get individual server facts, stored in variables(like a database) and pass those variables to this template(fetching the vaues from database)

This jinja templates has some delimiters that are used in the Jinja syntax:

-- {% ... %} is used for statements. We can include python 
-- {{ ... }} is used for variables.
-- {# ... #} is used for comments.
-- # ... ## is used for line statements. 
#### Loops and conditions

We can also execute scripts multiple times using loops and also use conditions
In [usercreation_with_items.yaml](https://github.com/ModernVishwamithra/DevOps/blob/main/Ansible/Playbooks/usercreation_with_items.yaml) file we tried to create **5 users* when OS family is **Debian* and its version is **22.04*

  -- {
tasks:
      - name: Create Testusers 1,2,3,4,5
        user: >
          name={{ item }}
          shell=/bin/bash
          password='$1$oEe4m6pU$AAiaKEiYrrcOHW3v3oj7d.'
        with_items:
            - debuser1
            - debuser2
            - debuser3
            - debuser4
            - debuser5
        when:
          (ansible_os_family == "Debian") and (ansible_distribution_version =="22.04")
}

We have used `with_items`, acting as a for loop to create 5 debian users and `when` condition to check the os family and its version. Similarly in the same file, when the os family is Redhat it creates 5 redhat users.
#### Installing docker swarm ansible playbook - Register, set_fact, add_hostname
 
 Create seperate template file [docker_template.tpl](https://github.com/ModernVishwamithra/DevOps/blob/main/Ansible/Playbooks/docker_template.tpl) and [docker_localfiles.tf](https://github.com/ModernVishwamithra/DevOps/blob/main/Ansible/Playbooks/docker_localfiles.tf) for docker swarm cluster( 1 Master, 3 workers, 2 managers)

 In [main.tf](https://github.com/ModernVishwamithra/DevOps/blob/main/Ansible/main.tf) create 3 more instances (total 6)
 In [docker_swarm.yaml](https://github.com/ModernVishwamithra/DevOps/blob/main/Ansible/Playbooks/docker_swarm.yaml)
 we install docker on all servers. But the below issue will come, even though docker is running, but it won't able to run docker commands. Its the issue with ubuntu 22.04.
 [issue-unable to run docker swarm init](https://github.com/docker/for-linux/issues/1406)

 Solve the issue as said above or downgrage the ubuntu version and run this [docker_swarm.yaml]

 Here we are using certain 
 [register]
 shows the particular value in output screen
 [set-fact]
 we can not only read the facts of servers, but we can also set custom facts to the server
 [no-log]
 to hide or unhide any particular value in output screen

-----------------------------------------------------------------------------------------------------------
# Ansible Part 4

-----------------------------------------------------------------------------------------------------------
## Dealing with sensitive information - passwords, tokens, etc

### **Ansible vaults**- used to store secrets in encrypted form. We need to provide valut password during encryption and decryption.

1. Create encrypted a file on-demand:

-- `ansible-vault create aws_creds` This will create a file which is empty and we need to provide creds. Create a aws **access_key** and **secret_key** from IAM and add the following lines to aws_creds file, which will be opened in VI editor

[deafult]
aws_access_key=xxx
aws_secret_access_key=yyy

Once entered the contents it will create and encrypt the file. To see the encrypted content use `cat aws_creds`. We can see only encrypted information. 

Also we can encrypt an existing file using this command `ansible-vault encrypt aws_creds`

2. Decrypt a file:

Read the contents of the fle using `cat aws_creds`, echo the contents and pipe the command `ansible-vault decrypt && echo`

example here - when we try to read the aws_creds we got encrypted data, then we decrypted like this by giving vault password.

echo '$ANSIBLE_VAULT;1.1;AES256
33643965616537613338373863313138326431333432326361653933616639376262656534346533
6535313534336162633534346339316133643435393164620a613136353239663462636537396239
35316134633065343131373765613863326230366433333436393934386361393266666266316330
3866386431396538650a356134336331303533373031343630313433386465666464303631363961
64626530363933633533333735396431303963663162313364656363323933313432383835333331
64643265376237303934313436663636373766656634646539336265363232313164346332383463
39386561343035336635336366303464323136326433613035396632656665356266653162616139
31303631393130313433353961363532643463373961356639656261666130613461346466376139
39383731626431316165336238653932623033663431643362353066393930316534' | ansible-vault decrypt && echo

or directly decrept the file usin filename

 -- `ansible-vault decrypt aws_creds`

3. Encrpt a string:

 -- `ansible-vault encrypt_string 'India@123456' --name 'user_password'` 

 This command encrypt string named `user_password` and its value `India@123456`

4. Decrypt a string:

    -- `echo 'Encrypted-data' | ansible-vault decrypt && echo`
    
5. Editing the encrypted file:

If the file is encrypted and changes are required, use the edit command.
 
 -- `ansible-vault edit aws_creds`

6. Reset the file password

Use the ansible-vault rekey command to reset the encrypted file password.

 -- `ansible-vault rekey aws_creds`

7. Decrypting password in a running playbook.

Create a [ansible_vault.yaml](https://github.com/ModernVishwamithra/DevOps/blob/main/Ansible/Playbooks/ansible_vault.yaml) ansible playbook and write the code to perform the following tasks.

 *  create a variable `user_password` which holds the encrypted value "India@123456"(as we created earlier).
 * Create .aws folder (`mkdir -p /root/.aws`)
 * Replace Password Authentication To Yes in ssh config file using `ansible.builtin.lineinfile` module.
 * Notify the handler to restart the SSH service
 * Copy Encrypted File(as we have created `aws_creds` file and encrypted it) To /tmp folder with root permissions
 * Copy Encrypted File(same `aws_creds` file) To .aws folder with root permissions
 * Create an adminuser named `pavan` and assign the password `user_password`
 * Restart the ssh service

Now deploy infrastructure using terraform, run the playbook
 
    -- ansible-playbook -i invfile Playbooks/ansible_vault.yaml --check --ask-vault-pass

    -- ansible-playbook -i invfile Playbooks/ansible_vault.yaml --ask-vault-pass

Once the playbook runs successfully, you can now login to any of the 3 servers, with user-`pavan` and password- `India@123456`

---------
# Ansible Part 5
---------
### Ansible roles

In a ansible-playbook we have multiple plays, if more plays are present in a single playbook then it will be difficiult to read and understand it. Also one play can be reused in another playbook is also a challenge. So to address these two major concerns ansible came up with the concept of [ansible roles](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse_roles.html). 

Roles provide a framework for fully independent, or interdependent collections of variables, tasks, files, templates, and modules.

In Ansible, the role is the primary mechanism for breaking a playbook into multiple files. This simplifies writing complex playbooks, and it makes them easier to reuse. The breaking of playbook allows you to logically break the playbook into reusable components.

Each role is basically limited to a particular functionality or desired output, with all the necessary steps to provide that result either within that role itself or in other roles listed as dependencies.

Roles are not playbooks. Roles are small functionality which can be independently used but have to be used within playbooks. There is no way to directly execute a role. Roles have no explicit setting for which host the role will apply to.

We can create our own roles also we can download existing roles using [Ansible Galaxy](https://galaxy.ansible.com/), in which you can have multiple roles developed by community.

When we install ansible, by default roles folder will be created in this path `/etc/ansible`, so when we want to add, create roles we need to do in this directory.


1. Install `nginxinstall` role 

    -- `ansible-galaxy init /etc/ansible/roles/nginxinstall --offline`

check the directory. We can find a structure like this

    README.md  defaults  files  handlers  meta  tasks  templates  tests  vars 

2. Go to `files` directory, create [scorekeeper.js] and [syle.css] using 
    
    -- `sudo nano scorekeeper.js` - paste the conents here

    -- `sudo nano style.css` - paste the conents here

3. Go to `templates` directory, create [index.j2] jinja template using

    -- `sudo nano index.j2` - paste the conents here

4. Go to `vars` directory, [main.yml] was already created by default. Edit that file using 
    
    -- `sudo nano main.yml`
    
    Copy the `vars` from [playbook_role.yaml](https://github.com/ModernVishwamithra/DevOps/blob/main/Ansible/Playbooks/playbook_role.yaml) and paste the variables in the `main.yaml` file.

5. Go to `tasks` directory, copy the `tasks` from [playbook_role.yaml](https://github.com/ModernVishwamithra/DevOps/blob/main/Ansible/Playbooks/playbook_role.yaml) except handlers

    -- `sudo nano main.yml`

paste in the `main.yaml` file.

6. Go to `handlers` directory, copy the `handlers` from [playbook_role.yaml](https://github.com/ModernVishwamithra/DevOps/blob/main/Ansible/Playbooks/playbook_role.yaml) and paste the variables in the `main.yaml` file.

7. Create [role_nginx.yml](https://github.com/ModernVishwamithra/DevOps/blob/main/Ansible/Playbooks/role_nginx.yml) and add the hosts , root permissions, Role path that we have installed, modified.

8. Deploy the infrastructure using terraform and run the ansible play-book

    -- ansible-playbook -i invfile Playbooks/role_nginx.yml --syntax-check
    -- ansible-playbook -i invfile Playbooks/role_nginx.yml --check
    -- ansible-playbook -i invfile Playbooks/role_nginx.yml -vv

9. The above commands checks the syntax, dry run and finally apply the configuration to all the hosts. Ansible automatically checks the directory, roles in it and apply it to the playbook. Now go to aws console and try to access any server's public ip, you can see the ngninx with jinja template associated with dynamic varibales server data. 

10. Try to add a variable `custom_heading` in [role_nginx.yml] file and apply. We wont be able to see the updated heading, beacuse of the variable precedence. Refer the document [variable precedence](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html) for more carity. 

So we want to change the variable outside of the ansible role, we use  `--extra-vars`(make sure the value of the varibale should be in '' single quotes). 

    ansible-playbook -i invfile Playbook/role-nginx.yml \
        --extra-vars "custom_heading='Testing VAR Precedence'" -e "ip_address='10.1.1.100'" 

The above command just replaces the varibales value i.e `custom_heading` and `ip_addess` as per the given values in all the hosts.

11. Install `mysql` role downloaded from ansible galaxy

    `ansible-galaxy install  --roles-path=/etc/ansible/roles/mysql geerlingguy.mysql`

It was installed in this directory, `/home/ansibleadmin/.ansible/roles/geerlingguy.mysql/`

12. Create sample sql data [dump.sql](https://github.com/ModernVishwamithra/DevOps/blob/main/Ansible/Playbooks/dump.sql) and a playbook [role_mysql.yml](https://github.com/ModernVishwamithra/DevOps/blob/main/Ansible/Playbooks/role_mysql.yml) to perform the following operations:

    * Add mysql role
    * Create a new database
    * Copy the sample data to tmp folder
    * Insert/Import sample data into database

13. Configure the mysql server in all the hosts,
    
    `ansible-playbook -i invfile Playbooks/role_mysql.yml --syntax-check`

    `ansible-playbook -i invfile Playbooks/role_mysql.yml --check`

    `ansible-playbook -i invfile Playbooks/role_mysql.yml -vv`

14. Once successfully installed, log in into any one of the instances, and check the mysql is successfully installed

    -- mysql : Gives you the version if successfully installed
    -- show databases; : It shows the default/created databases, in this we can see `myflixdb` data base
    -- use myflixdb; : Selects the database
    -- show tables; : Displays the tables present in the db
    -- select * from moves; : Displays all the contents of `movies table`

---------
# Ansible Part 6
--------
## Ansible Collections
-------
* Ansible was developed by [RedHat] organization. Ansible is available in two types. One is open-source ansible automation, another is RedHat maintained Ansible tower. People obviously look for free and open-source content. But if that conent is not updated regularly, many people find alternatives. Hence Ansible has a community members from all over the world who can contribute their work to ansible open-source tool.

* But the latest incorporated changes needs to be accepted by all community members for adding them to next release. Till that time thier work won't be available. To solve this challenge, ansible created a central distribution server called [Ansible Galaxy](https://galaxy.ansible.com/).

* In this server, community members share and distribute their work and other people will go though it and use their work. But sharing of the work to be in a common format, called [Collections], before V2.9 it tis called as [roles].

* So Ansible collections are nothing but a distribution format of ansible content like Plug-ins, roles, modules, playbooks. We can download our required collections(like libraries) from galaxy server and use it further. These collections also having proper documentation on how to use them.

* In this example, we install two collections from galaxy by running these two commands

```bash
    ansible-galaxy collection install nginxinc.nginx_core
    ansible-galaxy collection install community.mysql
```
* Create a playbook [collection_role_mysql.yml](https://github.com/ModernVishwamithra/DevOps/blob/main/Ansible/Playbooks/collection_role_mysql.yml) and add the following
 
 - Add roles 
    - geerlingguy.mysql : which we already installed in previous ansible part
    - nginxinc.nginx_core.nginx : This is a role from the downloaded nginx collection
 
 - Include the collections
    - community.mysql
    - nginxinc.nginx_core
 - Create tasks
    - Create new databases with name myflixdb, megastar, superstar
    - Copy sample sql data to tmp folder
    - Imporing database myflixdb ignoring errors
    - Show the movies table data
    - Create user with encryped password(can be genrated from online or libraries available) access to all databases
    - Create user with encrypted password for specific databases.

 * Run the playbook and check the movies data is visble 

 ```bash
 ansible-playbook -i invfile Playbooks/collection_role_mysql.yml --syntax-check
 ansible-playbook -i invfile Playbooks/collection_role_mysql.yml --check
 ansible-playbook -i invfile Playbooks/collection_role_mysql.yml -vv
 ```

 # Ansible Part 7
--------
## Ansible Dynamic inventory

It is easy with ansible inventory file to configure different servers, but it will be challenging when IP addresses frequently changes, or the instances creating dynamically(Auto scaling) etc. To tackle this challenge, a concept called *Dynamic Inventory* built as a ansible plugin. In this process our ansible controller connects to ec2 through `boto3` client using API, in response it gets the all the information about ec2 instances associated with the [tags].

[refer this artile for better understanding](https://devopscube.com/setup-ansible-aws-dynamic-inventory/)
![Dynamic Inventory](https://devopscube.com/wp-content/uploads/2021/07/ansiblee-inventory.png)

1. Install python, pip and boto3 packages

```bash
sudo apt-get install python3 -y
sudo apt-get install python3-pip -y
sudo pip3 install boto3
```
2. Create an inventory directory under /opt and cd into the directory.

```bash
sudo mkdir -p /opt/ansible/inventory
cd /opt/ansible/inventory
```
3. Create a file named aws_ec2.yaml in the inventory directory.
```bash
sudo vi aws_ec2.yaml or sudo nano aws_ec2.yaml
```
and add the following lines

```yaml
---
plugin: aws_ec2
aws_access_key: <YOUR-AWS-ACCESS-KEY-HERE>
aws_secret_key: <YOUR-AWS-SECRET-KEY-HERE>
keyed_groups:
  - key: tags
    prefix: tag
```
If you are using role in the ansible controller to access aws then no need to give access & security keys other we need to provide.

4. Open `/etc/ansible/ansible.cfg` file, Find the [inventory] section and add the following line to enable the ec2 plugin.

```script
enable_plugins = aws_ec2
```

5. Now let’s test the dynamic inventory configuration by listing the ec2 instances.

```bash
ansible-inventory -i /opt/ansible/inventory/aws_ec2.yaml --list | jq
```

This will fetch you all the servers information in json format filtered with the [keyed-groups] which was given in aws_ec2.yaml file [for reference check this file](https://github.com/ModernVishwamithra/DevOps/blob/main/Ansible/Playbooks/aws_ec2_plugin.yaml).

6. Create [dynamic_inventory.yaml](https://github.com/ModernVishwamithra/DevOps/blob/main/Ansible/Playbooks/dynamic_inventory.yaml) and add two roles one is to install nginx and other is mysql. Add play level tags.

7. Using tags We can target the servers to which roles to be installed. First check syntax, perform dry run and run the playbook

```bash
ansible-playbook -i /opt/ansible/inventory/aws_ec2.yaml Playbooks/dynamic_inventory.yaml --syntax-check
ansible-playbook -i /opt/ansible/inventory/aws_ec2.yaml Playbooks/dynamic_inventory.yaml --check --tags nginx
ansible-playbook -i /opt/ansible/inventory/aws_ec2.yaml Playbooks/dynamic_inventory.yaml --tags nginx
ansible-playbook -i /opt/ansible/inventory/aws_ec2.yaml Playbooks/dynamic_inventory.yaml --tags mysqlinstall
ansible-playbook -i /opt/ansible/inventory/aws_ec2.yaml Playbooks/dynamic_inventory.yaml --tags nginx,mysqlinstall
```
The 3rd command will install only nginx, 4th command installs only mysql and both nginx,mysql from [https://github.com/ModernVishwamithra/DevOps/blob/main/Ansible/Playbooks/dynamic_inventory.yaml] playbook.



8. `serial=1` in the playbook means, configure only one server at a time(serial). We also have `pre-tasks` and `post-tasks` where the tasks which we want to excute before or after the main tasks like plugin updation or something like that. Also we need to check in the sandbox environment that one pre-tasks are taking how much time, give timeout/execution time .

`delegate_to` is used to run the command in local ansible controller(its like local exec in terraform)

--------------
# Ansible Part 8

## Ansible Tower

It is very easy sometimes when you run ansible without command line interface but GUI. RedHat acquired ansible and made two different versions one is open source and license. Similarly they made GUI interface previously called as AnsibleX now it is Ansible Tower.

You can install AnsibleX from AMI market place and use its public ip to access the dashboard. 

Watch the videos related to it

- [https://www.youtube.com/watch?v=wZ_mh4-4HPY&list=PLnrmLjoInKWj4a7xu84_Z0_TiVlDCd0wq]

- [https://www.youtube.com/watch?v=ToXoDdUOzj8&list=PLnrmLjoInKWj4a7xu84_Z0_TiVlDCd0wq&index=2]

- [https://www.youtube.com/watch?v=jq_yzGuKPfA&list=PLnrmLjoInKWj4a7xu84_Z0_TiVlDCd0wq&index=8]
