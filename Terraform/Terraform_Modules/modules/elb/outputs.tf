output elb_listner {
  value       = "${aws_lb_listener.front_end.id}"
}

output elb_id {
  value       = "${aws_lb.test.id}"
}

output elb_dns_name {
  value       = "${aws_lb.test.dns_name}"
}

output elb_zone_id {
  value       = "${aws_lb.test.zone_id}"
}
