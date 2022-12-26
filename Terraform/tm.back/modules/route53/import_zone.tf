data "aws_route53_zone" "selected" {
  name         = var.domainname
}