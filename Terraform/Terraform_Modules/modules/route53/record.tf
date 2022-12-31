resource "aws_route53_record" "nlb" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "${var.recordname}.${data.aws_route53_zone.selected.name}"
  type    = "A"
    alias {
    name                   = var.dns_name
    zone_id                = var.zone_id
    evaluate_target_health = false
  }
}