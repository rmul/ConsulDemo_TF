resource "cloudstack_instance" "consuldemo" {
    count = "${var.cs_consuldemo_count}"
    name = "${var.cs_instance_name}-${count.index}"
    service_offering= "${var.cs_instance_type}"
    network = "${cloudstack_network.consuldemo.name}"
    template = "${var.cs_instance_template}"
    zone ="${var.cs_vpc_zone}"
    expunge = true
}

resource "cloudstack_port_forward" "consuldemo" {
    count = "${var.cs_consuldemo_count}"
    ipaddress = "${cloudstack_ipaddress.consuldemo.ipaddress}"

    forward {
        protocol = "tcp"
        private_port = 22
        public_port = 443
        virtual_machine = "${cloudstack_instance.bastion.name}"
    }

    forward {
        protocol = "tcp"
        private_port = 80
        public_port = 80
        virtual_machine = "${cloudstack_instance.bastion.name}"
    }
    depends_on = ["cloudstack_instance.bastion"]
}