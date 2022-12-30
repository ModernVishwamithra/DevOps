#                       **Terraform managing secrets using aws_secret_manager**

https://blog.gruntwork.io/a-comprehensive-guide-to-managing-secrets-in-your-terraform-code-1d586955ace1

1. This snippet is used to understand how to save credentials in aws secrets manager instead of giving in environmental variables, plain text in code, encrypted files (refer above link for better understanding)

2. Using AWS console, create secret(uname,pw) as aplain text json format in AWS SECRETS MANAGER

3. "data-secret.tf" file imports the secret manager version in which we have stored credentials

4. As the credentials are in encrypted form by default, we need to import and decode them using "jsondecode" function. This process is done in "**locals.tf***"

5. Till this point we have worked with secrets manager, now we can use that secrets as a crentials to RDS(database)
To create a database (db-instance), we require VPC and subnets(subnet group)

6. We created vpc and 3 subnets with 3 different availability zones(creating subnets in different AZ's is necessary, because when any one AZ is down replica of db will be present in another AZ). Hence i have declared AZ's explicitly in subnet resources

7. After creation, create a db_instance with mysql engine, while creating we need to provide username and password for the database. That was taken from locals.tf file, which imports the manually created one.

#                                ***Terraform auto generates paswword***
https://automateinfra.com/2021/03/24/how-to-create-secrets-in-aws-secrets-manager-using-terraform-in-amazon-account/

8. There is an option to generate credentials automatically by using "***random_password**" plugin. It will generate variable length of password(inclues alphabets, numerical characters, special characters). While generating/creating password for RDS we should not use '(single-quotes), ,(coma), @(at the rate) symbols.(please check the RDS console)

9. Check the "**random-password-secrets.tf**" file, how it generates secrets, stores it in **aws_secret_manager** and import it using **data sources**
 
