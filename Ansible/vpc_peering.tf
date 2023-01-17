data "aws_vpc" "ansible_controller_vpc" {
    id = "vpc-0d15fdcea83ad6549"
}

resource "aws_vpc_peering_connection" "ansible_vpc_peering" {
  peer_vpc_id   = data.aws_vpc.ansible_controller_vpc.id
  vpc_id        = aws_vpc.default.id
  auto_accept = true
  accepter {
    allow_remote_vpc_dns_resolution = true
  }
  requester {
    allow_remote_vpc_dns_resolution = true
  }

tags = {
  "Name" = "Controller_Peering"
}
}

#adding route to extisting route table i.e adding controller cidr in client route table
resource "aws_route" "route_client_to_controller" {
  route_table_id            = aws_route_table.terraform-public.id
  destination_cidr_block    = "10.1.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.ansible_vpc_peering.id
  depends_on = [aws_route_table.terraform-public] 
}

data "aws_route_table" "route_table_controller" {
  # Either you can import subnet directely and add it here or directly copy the id here
  subnet_id = "subnet-0b746f61a4e51f567"
}

resource "aws_route" "route_controller_to_client" {
  route_table_id            = data.aws_route_table.route_table_controller.id
  destination_cidr_block    = var.vpc_cidr # or "10.2.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.ansible_vpc_peering.id
  }