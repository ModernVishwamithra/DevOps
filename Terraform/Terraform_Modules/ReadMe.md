#***********************Terraform Modules********************#
Modules are nothing but a peice of code that can be resued. It is just like functions, when we want to resuse the code we will keep in functions and we will call that function any number of times. Similarly when we want to use the same code for multiple times we created modules. When we import the module and pass the required parameters it deploy resources, we can use one module output as another module input. 

We have created *modules* folder and 3 environment folders *dev*, *uat* and *prod*
under modules we created seperate folders for different resources
    --network   : code for deploying VPC, PUBLIC & PRIVATE SUBNETS, ROUTING. 
                  we have created **locals.tf** and this file can be used to use variables for this module only. **variables.tf** file is used to declare varibles used in this module.
                  **vpc.tf** it is a basic vpc creation
                  **public_subnets.tf** it creates 3 public subnets
                  **private_subnets.tf** it creates 3 private subnets
                  **routing.tf** it creates private RT with NAT GW attached and public RT with internet gateway attached.
                  **outputs.tf** file is very important as it exports the values which are associated with this module. By using this file we can import the values to another module
    
    --nat_gw    : Elastic IP is created and attached to NAT GW as it will be created
    
    --sg        : We need to allow inbound/ingress and outbound/egress ports. if we observe in the code we 
                have given port values from locals.tf and passing from the variables. In this way we can provide
    
    --route53   :
    
    --compute   :
    --elb       :
    --iam       :