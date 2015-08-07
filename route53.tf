# Some route53 specifics to make it easier to find web hosts.




resource "aws_route53_record" "consuldemo1" {
    zone_id    = "${var.route53_public_horizon.zone_id}"
    name       = "consuldemo1.${var.domain_name.sub}.${var.domain_name.zone}"
    type       = "A"
    ttl        = "60"
    records    = ["${aws_instance.ConsulDemo1.public_ip}"]
}
resource "aws_route53_record" "consuldemo2" {
    zone_id    = "${var.route53_public_horizon.zone_id}"
    name       = "consuldemo2.${var.domain_name.sub}.${var.domain_name.zone}"
    type       = "A"
    ttl        = "60"
    records    = ["${aws_instance.ConsulDemo2.public_ip}"]
}
resource "aws_route53_record" "consuldemo3" {
    zone_id    = "${var.route53_public_horizon.zone_id}"
    name       = "consuldemo3.${var.domain_name.sub}.${var.domain_name.zone}"
    type       = "A"
    ttl        = "60"
    records    = ["${aws_instance.ConsulDemo3.public_ip}"]
}


