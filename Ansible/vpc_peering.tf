data "aws_vpc" "ansible_controller_vpc" {
    id = "vpc-0d15fdcea83ad6549"
}

resource "aws_vpc_peering_connection" "ansible_vpc_peering" {
  peer_vpc_id   = data.aws_vpc.ansible_controller_vpc.id
  vpc_id        = aws_vpc.default.id
  auto_accept = true

#   accepter {
#     allow_remote_vpc_dns_resolution = true
#   }

#   requester {
#     allow_remote_vpc_dns_resolution = true
#   }
}