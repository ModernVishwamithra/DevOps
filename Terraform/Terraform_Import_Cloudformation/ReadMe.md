# This folder is created to import the AWS resources which was created already by using CloudFormation template
# We can also use DATASOURCES to import the functionality, but the differences are 
-- by using DATASOURCES, we can use resources which was already existed and create a new resources from it. When we do this all the newly created resources comes under terraform control, already existing resources won't come under terraform control. When we try to destroy resources, it destroys only terraform managed resources

-- By using IMPORT command we can get non-terraform managed resources under terraform control

# syntax for import
terraform import <terraform-resource-name> <resource-id>