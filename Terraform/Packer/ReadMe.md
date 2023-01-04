# Packer AMI Automation

Packer is a opensource tool from [Hashicorp](https://developer.hashicorp.com/) which is used to create identical machine images to multiple platforms using single source configuration

### Steps to create custom AMI using AWS (Console based)

1. Create a EC2 instance
2. Log in to EC2 instance
3. Install necessary plugins or tools into the instance
4. Shutdown the EC2 instance
5. Create AMI
6. Delete the EC2 instance

The above steps can be automated using packer CLI. To use that download the [Packer binary](https://developer.hashicorp.com/packer/downloads).

We need to create a file either in .json or .hcl format. Here we are using .json

### Steps to create custom AMI using AWS (Template/code based)

