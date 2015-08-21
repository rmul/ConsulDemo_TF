# Some route53 specifics to make it easier to find web hosts.




resource "aws_route53_record" "consuldemo" {
    count = "${var.aws_instance_count}"
    zone_id    = "${var.route53_public_horizon.zone_id}"
    name       = "aws-consuldemo-${count.index}.${var.domain_name.sub}.${var.domain_name.zone}"
    type       = "A"
    ttl        = "60"
    records    = ["${element(aws_instance.consuldemo.*.public_ip, count.index)}"]
}


