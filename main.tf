provider "aws" {
  region                  = "${var.aws_region}"
  shared_credentials_file = "secure/terraform"
  profile                 = "${var.profile}"
}

module "network" {
  source                   = "./modules/network"
  vpc_cidr                 = "${var.vpc_cidr}"
  internet_cidr            = "${var.internet_cidr}"
  public_cidr              = "${var.public_cidr}"
  private_cidr             = "${var.private_cidr}"
  backup_private_cidr      = "${var.backup_private_cidr}"
  availability_zone        = "${var.availability_zone}"
  backup_availability_zone = "${var.backup_availability_zone}"
}

module "security-groups" {
  source       = "./modules/security-groups"
  environment  = "${var.environment}"
  vpc_id       = "${module.network.vpc_id}"
  vpc_cidr     = "${var.vpc_cidr}"
  public_cidr  = "${var.public_cidr}"
  jumpbox_ip   = "${var.jumpbox_ip}"
  the_world    = "${var.the_world}"
  tcp_protocol = "${var.tcp_protocol}"
  ssh_port     = "${var.ssh_port}"
  https_port   = "${var.https_port}"
  http_port    = "${var.http_port}"
  mysql_port   = "${var.mysql_port}"
}

module "rds" {
  source                     = "./modules/rds"
  db_subnet_group_name       = "${module.network.db_subnet_group}"
  allocated_storage          = "${var.allocated_storage}"
  storage_type               = "${var.storage_type}"
  engine                     = "${var.engine}"
  engine_version             = "${var.engine_version}"
  instance_class             = "${var.instance_class}"
  auto_minor_version_upgrade = "${var.auto_minor_version_upgrade}"
  publicly_accessible        = "${var.publicly_accessible}"
  storage_encrypted          = "${var.storage_encrypted}"
  backup_retention_period    = "${var.backup_retention_period}"
  security_groups            = ["${module.security-groups.rds_sg}"]
  rds_sg                     = "${module.security-groups.rds_sg}"

  # MISP
  misp_identifier = "${var.misp_identifier}"
  misp_name       = "${var.misp_name}"
  misp_username   = "${var.misp_username}"
  misp_password   = "${var.misp_password}"
}

module "instances" {
  source            = "./modules/instances"
  public_subnet_id  = "${module.network.public_subnet_id}"
  instance_type     = "${var.instance_type}"
  instance_ami      = "${var.instance_ami}"
  iam_instance_role = "${var.iam_instance_role}"
  volume_type       = "${var.volume_type}"
  volume_size       = "${var.volume_size}"
  key_name          = "${var.key_name}"
  security_groups   = ["${module.security-groups.misp_sg}"]
  misp_sg           = "${module.security-groups.misp_sg}"
}
