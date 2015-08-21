######### Creating ACL's #########

resource "cloudstack_network_acl" "consuldemo" {
    name = "${var.cs_network_name}"
    vpc = "${cloudstack_vpc.main.name}"
}

resource "cloudstack_network_acl_rule" "consuldemo" {
  aclid = "${cloudstack_network_acl.consuldemo.id}"
  depends_on = "cloudstack_instance.consuldemo"

  rule {
    action = "allow"
    source_cidr  = "${var.cs_safe_ips.anywhere}" # Any 
    protocol = "all"
    traffic_type = "ingress"
  }

  rule {
    action = "allow"
    source_cidr  = "0.0.0.0/0" # The Internet 
    protocol = "all"
    traffic_type = "egress"
  }
}

resource "cloudstack_network" "consuldemo" {
    name = "${var.cs_network_name}"
    cidr = "${var.cs_network_cidr}"
    network_offering = "${var.cs_network_offering}"
    zone = "${var.cs_vpc_zone}"
    vpc = "${cloudstack_vpc.main.name}"
    aclid = "${cloudstack_network_acl.consuldemo.id}"
}

resource "cloudstack_ipaddress" "consuldemo" {
    count = "${var.cs_instance_count}"
    vpc = "${cloudstack_vpc.main.name}"
}

/* output "management-publicip" {
    value = "${cloudstack_ipaddress.management.ipaddress}"
} */