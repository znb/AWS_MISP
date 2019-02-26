variable "environment" {}
variable "vpc_cidr" {}
variable "vpc_id" {}
variable "public_cidr" {}
variable "tcp_protocol" {}
variable "ssh_port" {}
variable "http_port" {}
variable "https_port" {}
variable "mysql_port" {}
variable "the_world" {}
variable "jumpbox_ip" {}

#
# RDS
#

resource "aws_security_group" "rds_sg" {
  name   = "rds_security_group"
  vpc_id = "${var.vpc_id}"

  tags {
    Environment = "${var.environment}"
  }
}

resource "aws_security_group_rule" "allow_rds_mysql" {
  type              = "ingress"
  security_group_id = "${aws_security_group.rds_sg.id}"
  description       = "Allow incoming MySQL"

  from_port   = "${var.mysql_port}"
  to_port     = "${var.mysql_port}"
  protocol    = "${var.tcp_protocol}"
  cidr_blocks = ["${var.vpc_cidr}"]
}

resource "aws_security_group_rule" "allow_rds_egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.rds_sg.id}"
  description       = "Allow RDS to talk out"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

output "rds_sg" {
  value = "${aws_security_group.rds_sg.id}"
}

#
# MISP
#

resource "aws_security_group" "misp_sg" {
  name   = "misp_security_group"
  vpc_id = "${var.vpc_id}"

  tags {
    Environment = "${var.environment}"
  }
}

resource "aws_security_group_rule" "allow_misp_ssh" {
  type              = "ingress"
  security_group_id = "${aws_security_group.misp_sg.id}"
  description       = "Allow incoming SSH"

  from_port = "${var.ssh_port}"
  to_port   = "${var.ssh_port}"
  protocol  = "${var.tcp_protocol}"

  cidr_blocks = ["${var.jumpbox_ip}"]
}

resource "aws_security_group_rule" "allow_misp_https" {
  type              = "ingress"
  security_group_id = "${aws_security_group.misp_sg.id}"
  description       = "Allow incoming HTTPS"

  from_port = "${var.https_port}"
  to_port   = "${var.https_port}"
  protocol  = "${var.tcp_protocol}"

  cidr_blocks = ["${var.the_world}"]
}

resource "aws_security_group_rule" "misp_egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.misp_sg.id}"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

output "misp_sg" {
  value = "${aws_security_group.misp_sg.id}"
}

resource "aws_security_group" "misp_rds_sg" {
  name   = "misp_rds_security_group"
  vpc_id = "${var.vpc_id}"

  tags {
    Environment = "${var.environment}"
  }
}

resource "aws_security_group_rule" "allow_misp_rds_egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.misp_rds_sg.id}"
  description       = "Allow MISP RDS to talk out"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

output "misp_rds_sg" {
  value = "${aws_security_group.misp_rds_sg.id}"
}
