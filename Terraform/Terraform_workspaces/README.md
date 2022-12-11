#                       *** Terraform Workspaces ***

We have one code and we need to create 3 environments with that

1. Production(Prod)
2. User Acceptance(UAT)
3. Development(Dev)

There are multiple ways to do it
--one is create three seperate repositories
--another is create different branches as clones
--only changes in the above three environments are variables, can we create 3 different .tfvars files and create this. In this way it wont work,why? Eventhough you are providing 3 different variables for the code but it creates ***one state file**. so it wont create 3 envs insted it overrides everytime you create.

What's the solution is, **terraform workspaces**, as it maintians 3 seperate tf states for the same code with different env tfvars.

**reproducing-the scenario**

terraform apply --var-file .\dev.tfvars --auto-approve
terraform apply --var-file .\uat.tfvars --auto-approve
terraform apply --var-file .\prod.tfvars --auto-approve

when we try to run these above one by one, initially dev environment will be created,
later uat environment will be created by destroying dev environment,
next prod environment will be created by destroying uat environment,

but what we achieved is instead of creating 3 identical environments, we end up creating only one because of one tf-state-file is created irrepective of the environment variables

# terraform [global options] workspace  
new, list, show, select and delete Terraform workspaces.

-- **terraform workspace list** shows the list of workspaces created and it will indicate currently associated workspace with *, when there is no workspace is created it will show "default"

-- **terraform workspace show** shows the workspace created which is currently associated , when there is no workspace is created it will show "default"

-- **terraform workspace new <workspace-name>** it will create new workspace and switch to it

-- **terraform workspace select <workspace-name>** switch from one to another workspace

-- **terraform workspace delete <workspace-name>** del from one to another workspace


Now after creating workspace and select which workspace you want to work with and apply the following

terraform apply --var-file .\dev.tfvars --auto-approve
terraform apply --var-file .\uat.tfvars --auto-approve
terraform apply --var-file .\prod.tfvars --auto-approve

now everytime we apply with different environmental tfvars, terraform workspace automatically creates in that partiular environment.

terraform destroy --var-file .\dev.tfvars --auto-approve
terraform destroy --var-file .\uat.tfvars --auto-approve
terraform destroy --var-file .\prod.tfvars --auto-approve

once complete with the code, destroy the infrastructure

# Important to note here is when we require identical environments then workspaces are useful
# suppose in dev it requires 3 servers, uat reuires 4 and prod reuires 1 then workspaces is not useful