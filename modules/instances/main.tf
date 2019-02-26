variable "instance_type" {}
variable "instance_ami" {}
variable "iam_instance_role" {}
variable "key_name" {}
variable "volume_type" {}
variable "volume_size" {}
variable "public_subnet_id" {}
variable "misp_sg" {}

variable "security_groups" {
  type = "list"
}

#
# MISP
#

data "template_file" "misp_config" {
  template = "${file("secure/cloud-conf/misp-cloud-conf.tpl")}"

  vars {
    hostname = "misp.example.com"
  }
}

resource "aws_instance" "misp_instance" {
  ami                         = "${var.instance_ami}"
  instance_type               = "${var.instance_type}"
  iam_instance_role           = "${var.iam_instance_role}"
  ebs_optimized               = false
  associate_public_ip_address = true
  subnet_id                   = "${var.public_subnet_id}"
  vpc_security_group_ids      = ["${var.misp_sg}"]
  key_name                    = "${var.key_name}"

  user_data = "${data.template_file.misp_config.rendered}"

  root_block_device {
    volume_type           = "${var.volume_type}"
    volume_size           = "${var.volume_size}"
    delete_on_termination = true
  }

  volume_tags {
    Name = "misp-volume"
  }

  tags = {
    Name  = "misp-instance"
    Owner = "Incident Response"
    Role  = "MISP Server"
  }
}

resource "aws_eip" "misp_instance" {
  instance = "${aws_instance.misp_instance.id}"
  vpc      = true

  tags {
    Name = "misp_eip"
  }
}

output "public_ip" {
  value = "${aws_instance.misp_instance.public_ip}"
}
