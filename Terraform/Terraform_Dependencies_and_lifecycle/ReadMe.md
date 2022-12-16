#                                   *** TERRAFORM DEPENDENCIES ***
                        
This directory or folder is used to test the terraform dependencies.
There are two types of dependencies
1. **Implicit dependency** - terraform is built in such a way that it automatically identifies dependencies while creating resources

Examples-
 #when we want to create a subnet resource, we need to provide vpc id, similarly to associate subnet in route table we need to provide subnet id and route table id. these are called implicit dependencies

2. **Explicit dependency** - we need to specify externally to terraform that one resource is dependent on other resource by using *** depends on [<terraform-resource-name>] *** option

Example-
#Each VPC generates logs, those logs are called "Flow Logs", we can store this flowlogs using cloudwatch or use s3 to store logs. Here in this example we have created s3 bucket named *** devopsb27-bucket *** and store them in that bucket. We created dependencies for creating multiple buckets

#                                   *** TERRAFORM LIFECYCLE META ARGUMENT ***
The Resource Behavior page describes the general lifecycle for resources. Some details of that behavior can be customized using the special nested lifecycle block within a resource block body:

resource "azurerm_resource_group" "example" {
  # ...

  lifecycle {
  # create_before_destroy = true 
  --first create resource and then destroy(+/_), by default terraform destroy and creates resource(-/+), we can change this default terraform lifecycle state

  #  prevent_destroy = true
  -- suppose we have a DB server which is very important and we should not allow others or by you knowingly/unknowingly destroy it. we can make this lifecycle meta argument ***prevent_destroy*** to true, it wont destroy this resource programmatically. By manually?- please try and confirm by yourself
 # ignore_changes = [ <which-you-want-ignore> ]
  -- there is a situation that when we have a resource, lets take security group. In that we have allowed inbound port tcp/1433 and deployed. Some other member of another team or your team, asks to change the ports and they changed it manually. If any changes are done manually in console, terrform recognizes it by comparing with code and recreates that resource by deleting manually changed data.
  
  This is a problem that everytime resource is recreating, instead the team member will raise ticket and you need to add the required changes in the code and deploy it. 

  Both the ways are time taking and headache :-)

  One method is we can use **ignore_changes** argument, and add the item to it which you dont to recreate everytime changes done to that item manually. Even terraform also wont recreate it if changes are done manually
  }
}   

 #                                 *** TERRAFORM DEBUGGING AND LOGGING ***

Terraform cab be logged using two variables **TF_LOG** and **TF_LOG_PATH** 

***In powershell***
$env:TF_LOG="<mode>"
$env:TF_LOG_PATH="<log-file-name>"

***In Linux***
export TF_LOG="<mode>"
export TF_LOG_PATH="<log-file-name>"

**mode**
Terraform exposes the TF_LOG environment variable for setting the level of logging verbosity. There are five levels:

--TRACE: the most elaborate verbosity, as it shows every step taken by Terraform and produces enormous outputs with internal logs.
--DEBUG: describes what happens internally in a more concise way compared to TRACE.
--ERROR: shows errors that prevent Terraform from continuing.
--WARN: logs warnings, which may indicate misconfiguration or mistakes, but are not critical to execution.
--INFO: shows general, high-level messages about the execution process.