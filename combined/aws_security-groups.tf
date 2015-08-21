/* Default security group */
resource "aws_security_group" "default" {
  name        = "ConsulDemo-SecurityGroup"
  description = "Default security group that allows all traffic"
  vpc_id      = "${aws_vpc.default.id}"

/*
  # Allows inbound and outbound traffic from all instances in the VPC.
  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }
  
  # Allows all inbound traffic from the CIDR.
  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["${var.security_group.cidr_blocks}"]
  }
*/

  # Allows all outbound traffic to internet.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "ConsulDemo security group"
  }
}

resource "aws_security_group_rule" "allow_home" {
  type = "ingress"
  from_port = "0"
  to_port = "0"
  protocol = "-1"
  cidr_blocks = ["${var.cs_safe_ips.home}"]
  security_group_id = "${aws_security_group.default.id}"
}

resource "aws_security_group_rule" "allow_office" {
  type = "ingress"
  from_port = "0"
  to_port = "0"
  protocol = "-1"
  cidr_blocks = ["${var.cs_safe_ips.office}"]
  security_group_id = "${aws_security_group.default.id}"
}

resource "aws_security_group_rule" "allow_csinstances" {
  count = "${var.cs_instance_count}"
  type = "ingress"
  from_port = "0"
  to_port = "0"
  protocol = "-1"
  cidr_blocks = ["${element(cloudstack_ipaddress.consuldemo.*.ipaddress, count.index)}/32"]
  security_group_id = "${aws_security_group.default.id}"
}

resource "aws_security_group_rule" "allow_awsinstances" {
  count = "${var.aws_instance_count}"
  type = "ingress"
  from_port = "0"
  to_port = "0"
  protocol = "-1"
  cidr_blocks = ["${element(aws_instance.consuldemo.*.public_ip, count.index)}/32"]
  security_group_id = "${aws_security_group.default.id}"
}

resource "aws_security_group_rule" "allow_csnat" {
  type = "ingress"
  from_port = "0"
  to_port = "0"
  protocol = "-1"
  cidr_blocks = ["${var.cs_nat_ip_range}"]
  security_group_id = "${aws_security_group.default.id}"
}
