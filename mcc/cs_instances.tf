resource "cloudstack_instance" "consuldemo" {
    count = "${var.cs_instance_count}"
    name = "${var.cs_instance_name}-${count.index}"
    service_offering= "${var.cs_instance_type}"
    network = "${cloudstack_network.consuldemo.name}"
    template = "${var.cs_instance_template}"
    zone ="${var.cs_vpc_zone}"
    expunge = true
}

resource "cloudstack_port_forward" "consuldemo" {
    count = "${var.cs_instance_count}"
    ipaddress = "${element(cloudstack_ipaddress.consuldemo.*.ipaddress, count.index)}"

    forward {
        protocol = "tcp"
        private_port = 3389
        public_port = 3389
        virtual_machine = "${element(cloudstack_instance.consuldemo.*.name, count.index)}"
    }

    forward {
        protocol = "tcp"
        private_port = 5985
        public_port = 5985
        virtual_machine = "${element(cloudstack_instance.consuldemo.*.name, count.index)}"
    }

    forward {
        protocol = "tcp"
        private_port = 8500
        public_port = 8500
        virtual_machine = "${element(cloudstack_instance.consuldemo.*.name, count.index)}"
    }

    forward {
        protocol = "tcp"
        private_port = 8302
        public_port = 8302
        virtual_machine = "${element(cloudstack_instance.consuldemo.*.name, count.index)}"
    }
}

resource "null_resource" "consulconfig" {
    count = "${var.cs_instance_count}"
    depends_on = "cloudstack_instance.consuldemo"
    connection {
      host= "${element(cloudstack_ipaddress.consuldemo.*.ipaddress, count.index)}"
      type = "winrm"
      timeout = "30m"
      user = "${lookup(var.cs_instance_user,var.cs_instance_template)}"
      password = "${lookup(var.cs_instance_pwd,var.cs_instance_template)}"
    }
    provisioner "remote-exec" {
      inline = [
	      "net start W32Time",
	      "w32tm /config /manualpeerlist:nl.pool.ntp.org /syncfromflags:manual /update",
	      "w32tm /resync",
	      "netsh advfirewall set allprofiles state off",
	      "powershell -command \"iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))\"",
	      "SET PATH=%PATH%;%ALLUSERSPROFILE%\\chocolatey\\bin",
	      "choco install -y google-chrome-x64",
	      "choco install -y curl",
	      "choco install -y wget",
	      "choco install -y baretail",
	      "reg add \"HKCR\\*\\shell\\Open with BareTail\\command\" /ve /f /t REG_SZ /d \"C:\ProgramData\chocolatey\lib\baretail\tools\baretail.exe \\\"%%1\\\"\"",
	      "choco install -y sublimetext3",
	      "choco install -y conemu",
	      "choco install -y git",
	      "choco install -y nssm",
	      "choco install -y 7zip",
	      "choco install -y 7zip.commandline",
	      "choco install -y chef-client",
	      "setx /M path \"%path%;C:\\opscode\\chef\\embedded\\bin\"",
	      "SET PATH=%PATH%;C:\\opscode\\chef\\embedded\\bin",
	      "curl -o c:\0.5.2_windows_386.zip https://dl.bintray.com/mitchellh/consul/0.5.2_windows_386.zip --insecure -L",
	      "curl -o c:\0.5.2_web_ui.zip https://dl.bintray.com/mitchellh/consul/0.5.2_web_ui.zip --insecure -L",
	      "7za x -y c:\0.5.2_windows_386.zip -oc:\consul\bin",
	      "7za x -y c:\0.5.2_web_ui.zip -oc:\consul\ui",
	      "mkdir c:\consul\data",
	      "mkdir c:\consul\config",
	      "mkdir c:\consul\var\log",
	      "curl -o C:\consul\config\config.json https://raw.githubusercontent.com/rmul/flapflap/master/cs_config.json --insecure -L",
	      "sed -i.repl -e 's/#NODENAME#/${var.cs_instance_name}-${count.index}/g' -e 's/#PRIVATEIP#/${element(cloudstack_instance.consuldemo.*.ipaddress, count.index)}/g' -e 's/#PUBLICIP#/${element(cloudstack_ipaddress.consuldemo.*.ipaddress, count.index)}/g' -e 's/#DC#/ConsulDemo/g' C:\consul\config\config.json",
	      "nssm install Consul c:\consul\bin\consul.exe agent --config-dir c:\consul\config",
	      "nssm set Consul AppStdout C:\consul\var\log\consul.log",
	      "nssm set Consul AppStderr C:\consul\var\log\consul_error.log",
	      "nssm set Consul AppStdoutCreationDisposition 4",
	      "nssm set Consul AppStderrCreationDisposition 4",
	      "nssm set Consul AppRotateFiles 1",
	      "nssm set Consul AppRotateOnline 1",
	      "nssm set Consul AppRotateBytes 1048576",
	      "sc start Consul"
        ]
    }
}