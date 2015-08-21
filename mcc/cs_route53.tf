# Some route53 specifics to make it easier to find web hosts.

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_route53_record" "cs-consuldemo" {
    count      = "${var.cs_instance_count}"
    zone_id    = "${var.route53_public_horizon.zone_id}"
    name       = "${element(cloudstack_instance.consuldemo.*.name, count.index)}.${var.domain_name.sub}.${var.domain_name.zone}"
    type       = "A"
    ttl        = "60"
    records    = ["${element(cloudstack_ipaddress.consuldemo.*.ipaddress, count.index)}"]
}
