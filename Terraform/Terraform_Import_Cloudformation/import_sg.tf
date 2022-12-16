resource "aws_security_group" "mytestvpc-sg" {
  vpc_id      = aws_vpc.mytestvpc01.id
  description = "Enable SSH access via port 22"
  name        = "Terraform-cloudconfiguration-import-PublicInstanceSG-D89ZE4JA2010"
  ingress = [
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = ""
      from_port        = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 22
    },
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = ""
      from_port        = 80
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 80
    }
  ]
  tags = {
    "Name" = "MyTestVPC-sg"
  }
  egress {
    cidr_blocks = [
      "0.0.0.0/0",
    ]
    description      = ""
    from_port        = 0
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "-1"
    security_groups  = []
    self             = false
    to_port          = 0
  }

}