provider "cloudstack" {
    api_url = "${var.cs_api_url}"
    api_key = "${var.cs_api_key}"
    secret_key = "${var.cs_secret_key}"
}

/* Define our vpc */
resource "cloudstack_vpc" "main" {
    name = "${var.cs_vpc_name}"
    cidr = "${var.cs_vpc_cidr_block}"
    vpc_offering = "${var.cs_vpc_offering}"
    zone = "${var.cs_vpc_zone}"
}
