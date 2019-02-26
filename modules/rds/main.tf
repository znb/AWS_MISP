variable "rds_sg" {}
variable "db_subnet_group_name" {}
variable "allocated_storage" {}
variable "storage_type" {}
variable "engine" {}
variable "engine_version" {}
variable "instance_class" {}
variable "publicly_accessible" {}
variable "backup_retention_period" {}
variable "auto_minor_version_upgrade" {}
variable "storage_encrypted" {}
variable "misp_identifier" {}
variable "misp_name" {}
variable "misp_username" {}
variable "misp_password" {}

variable "security_groups" {
  type = "list"
}

#
# MISP
#

resource "aws_db_instance" "misp_rds" {
  db_subnet_group_name       = "${var.db_subnet_group_name}"
  allocated_storage          = "${var.allocated_storage}"
  engine                     = "${var.engine}"
  engine_version             = "${var.engine_version}"
  instance_class             = "${var.instance_class}"
  identifier                 = "${var.misp_identifier}"
  name                       = "${var.misp_name}"
  username                   = "${var.misp_username}"
  password                   = "${var.misp_password}"
  auto_minor_version_upgrade = "${var.auto_minor_version_upgrade}"
  storage_encrypted          = "${var.storage_encrypted}"
  publicly_accessible        = "${var.publicly_accessible}"
  backup_retention_period    = "${var.backup_retention_period}"
  vpc_security_group_ids     = ["${var.rds_sg}"]

  tags {
    Name = "MISP Database"
  }
}

output "misp_rds_endpoint" {
  value = "${aws_db_instance.misp_rds.address}"
}
