/* ConsulDemo instances */
resource "aws_instance" "ConsulDemo1" {
  instance_type     = "${var.instance_type.consuldemo}"
  ami               = "${var.instance_ami.consuldemo}"
  subnet_id         = "${aws_subnet.a.id}"
  source_dest_check = false
  security_groups   = ["${aws_security_group.default.id}"]
  tags {
    Name     = "consuldemo1"
    Role     = "ConsulDemo first server."
  }
  root_block_device {
  volume_size             = "40"
  delete_on_termination   = true
  }
}

resource "aws_instance" "ConsulDemo2" {
  instance_type     = "${var.instance_type.consuldemo}"
  ami               = "${var.instance_ami.consuldemo}"
  subnet_id         = "${aws_subnet.b.id}"
  source_dest_check = false
  security_groups   = ["${aws_security_group.default.id}"]
  depends_on        = "aws_instance.ConsulDemo1"
  tags {
    Name     = "consuldemo2"
    Role     = "ConsulDemo second server."
  }
  root_block_device {
  volume_size             = "40"
  delete_on_termination   = true
  }
}

resource "aws_instance" "ConsulDemo3" {
  instance_type     = "${var.instance_type.consuldemo}"
  ami               = "${var.instance_ami.consuldemo}"
  subnet_id         = "${aws_subnet.c.id}"
  source_dest_check = false
  security_groups   = ["${aws_security_group.default.id}"]
  depends_on        = "aws_instance.ConsulDemo1"
  tags {
    Name     = "consuldemo3"
    Role     = "ConsulDemo third server."
  }
  root_block_device {
  volume_size             = "40"
  delete_on_termination   = true
  }
}

resource "null_resource" "consulconfig1" {
  connection {
    host= "${aws_instance.ConsulDemo1.public_ip}"
    type = "winrm"
    timeout = "30m"
    user = "packer"
    password = "P@ck3r99!"
  }
  provisioner "remote-exec" {
    inline = [
      "net start W32Time",
      "w32tm /config /manualpeerlist:nl.pool.ntp.org /syncfromflags:manual /update",
      "w32tm /resync",
      "netsh advfirewall set allprofiles state off",
      "choco install -y google-chrome-x64",
      "choco install -y curl",
      "choco install -y wget",
      "choco install -y baretail",
      "reg add \"HKCR\\*\\shell\\Open with BareTail\\command\" /ve /t REG_SZ /d \"C:\ProgramData\chocolatey\lib\baretail\tools\baretail.exe \%1\"",
      "choco install -y sublimetext3",
      "choco install -y conemu",
      "choco install -y git",
      "choco install -y nssm",
      "choco install -y 7zip",
      "choco install -y 7zip.commandline",
      "curl -o c:\0.5.2_windows_386.zip https://dl.bintray.com/mitchellh/consul/0.5.2_windows_386.zip --insecure -L",
      "curl -o c:\0.5.2_web_ui.zip https://dl.bintray.com/mitchellh/consul/0.5.2_web_ui.zip --insecure -L",
      "7za x c:\0.5.2_windows_386.zip -oc:\consul\bin",
      "7za x c:\0.5.2_web_ui.zip -oc:\consul\ui",
      "mkdir c:\consul\data",
      "mkdir c:\consul\config",
      "mkdir c:\consul\var\log",
      "curl -o C:\consul\config\config.json https://raw.githubusercontent.com/rmul/flapflap/master/config.json --insecure -L",
      "sed -i.repl -e 's/#NODENAME#/consuldemo1/g' -e 's/#PRIVATEIP#/${aws_instance.ConsulDemo1.private_ip}/g' -e 's/#PUBLICIP#/${aws_instance.ConsulDemo1.public_ip}/g' -e 's/#DC#/ConsulDemo/g' -e 's/#JOINNODE1#/${aws_instance.ConsulDemo2.private_ip}/g' -e 's/#JOINNODE2#/${aws_instance.ConsulDemo3.private_ip}/g' C:\consul\config\config.json",
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

resource "null_resource" "consulconfig2" {
  connection {
    host= "${aws_instance.ConsulDemo2.public_ip}"
    type = "winrm"
    timeout = "30m"
    user = "packer"
    password = "P@ck3r99!"
  }
  provisioner "remote-exec" {
    inline = [
      "net start W32Time",
      "w32tm /config /manualpeerlist:nl.pool.ntp.org /syncfromflags:manual /update",
      "w32tm /resync",
      "netsh advfirewall set allprofiles state off",
      "choco install -y google-chrome-x64",
      "choco install -y curl",
      "choco install -y wget",
      "choco install -y baretail",
      "reg add \"HKCR\\*\\shell\\Open with BareTail\\command\" /ve /t REG_SZ /d \"C:\ProgramData\chocolatey\lib\baretail\tools\baretail.exe \%1\"",
      "choco install -y sublimetext3",
      "choco install -y conemu",
      "choco install -y git",
      "choco install -y nssm",
      "choco install -y 7zip",
      "choco install -y 7zip.commandline",
      "curl -o c:\0.5.2_windows_386.zip https://dl.bintray.com/mitchellh/consul/0.5.2_windows_386.zip --insecure -L",
      "curl -o c:\0.5.2_web_ui.zip https://dl.bintray.com/mitchellh/consul/0.5.2_web_ui.zip --insecure -L",
      "7za x c:\0.5.2_windows_386.zip -oc:\consul\bin",
      "7za x c:\0.5.2_web_ui.zip -oc:\consul\ui",
      "mkdir c:\consul\data",
      "mkdir c:\consul\config",
      "mkdir c:\consul\var\log",
      "curl -o C:\consul\config\config.json https://raw.githubusercontent.com/rmul/flapflap/master/config.json --insecure -L",
      "sed -i.repl -e 's/#NODENAME#/consuldemo2/g' -e 's/#PRIVATEIP#/${aws_instance.ConsulDemo2.private_ip}/g' -e 's/#PUBLICIP#/${aws_instance.ConsulDemo2.public_ip}/g' -e 's/#DC#/ConsulDemo/g' -e 's/#JOINNODE1#/${aws_instance.ConsulDemo3.private_ip}/g' -e 's/#JOINNODE2#/${aws_instance.ConsulDemo1.private_ip}/g' C:\consul\config\config.json",
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

resource "null_resource" "consulconfig3" {
  connection {
    host= "${aws_instance.ConsulDemo3.public_ip}"
    type = "winrm"
    timeout = "30m"
    user = "packer"
    password = "P@ck3r99!"
  }
  provisioner "remote-exec" {
    inline = [
      "net start W32Time",
      "w32tm /config /manualpeerlist:nl.pool.ntp.org /syncfromflags:manual /update",
      "w32tm /resync",
      "netsh advfirewall set allprofiles state off",
      "choco install -y google-chrome-x64",
      "choco install -y curl",
      "choco install -y wget",
      "choco install -y baretail",
      "reg add \"HKCR\\*\\shell\\Open with BareTail\\command\" /ve /t REG_SZ /d \"C:\ProgramData\chocolatey\lib\baretail\tools\baretail.exe \%1\"",
      "choco install -y sublimetext3",
      "choco install -y conemu",
      "choco install -y git",
      "choco install -y nssm",
      "choco install -y 7zip",
      "choco install -y 7zip.commandline",
      "curl -o c:\0.5.2_windows_386.zip https://dl.bintray.com/mitchellh/consul/0.5.2_windows_386.zip --insecure -L",
      "curl -o c:\0.5.2_web_ui.zip https://dl.bintray.com/mitchellh/consul/0.5.2_web_ui.zip --insecure -L",
      "7za x c:\0.5.2_windows_386.zip -oc:\consul\bin",
      "7za x c:\0.5.2_web_ui.zip -oc:\consul\ui",
      "mkdir c:\consul\data",
      "mkdir c:\consul\config",
      "mkdir c:\consul\var\log",
      "curl -o C:\consul\config\config.json https://raw.githubusercontent.com/rmul/flapflap/master/config.json --insecure -L",
      "sed -i.repl -e 's/#NODENAME#/consuldemo3/g' -e 's/#PRIVATEIP#/${aws_instance.ConsulDemo3.private_ip}/g' -e 's/#PUBLICIP#/${aws_instance.ConsulDemo3.public_ip}/g' -e 's/#DC#/ConsulDemo/g' -e 's/#JOINNODE1#/${aws_instance.ConsulDemo1.private_ip}/g' -e 's/#JOINNODE2#/${aws_instance.ConsulDemo2.private_ip}/g' C:\consul\config\config.json",
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