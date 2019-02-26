variable "availability_zone" {
  default = "eu-west-2a"
}

variable "backup_availability_zone" {
  default = "eu-west-2b"
}

variable "aws_region" {
  default = "eu-west-2"
}

variable "profile" {
  default = "terraform"
}

variable "environment" {
  default = "dfir_misp"
}

variable "instance_type" {
  default = "t2.large"
}

variable "key_name" {
  default = "secret-key-of-doom"
}

variable "instance_ami" {
  default = "PACKER-AMI"
}

variable "iam_instance_role" {
  default = "AmazonEC2RoleforSSM"
}

variable "volume_type" {
  default = "gp2"
}

variable "volume_size" {
  default = 50
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "internet_cidr" {
  default = "0.0.0.0/0"
}

variable "public_cidr" {
  default = "10.0.1.0/24"
}

variable "private_cidr" {
  default = "10.0.2.0/24"
}

variable "backup_private_cidr" {
  default = "10.0.5.0/24"
}

variable "jumpbox_ip" {
  default = "10.0.1.250/32"
}

variable "the_world" {
  default = "0.0.0.0/0"
}

variable "tcp_protocol" {
  default = "tcp"
}

variable "ssh_port" {
  default = "22"
}

variable "http_port" {
  default = "80"
}

variable "https_port" {
  default = "443"
}

variable "mysql_port" {
  default = "3306"
}

variable "mispdashboard_port" {
  default = "8001"
}

#
# RDS
#

variable "allocated_storage" {
  default = 20
}

variable "storage_type" {
  default = "gp2"
}

variable "instance_class" {
  default = "db.t2.small"
}

variable "misp_instance_class" {
  default = "db.t2.medium"
}

variable "publicly_accessible" {
  default = false
}

variable "backup_retention_period" {
  default = 5
}

variable "storage_encrypted" {
  default = true
}

variable "auto_minor_version_upgrade" {
  default = true
}

# MISP RDS
#

variable "engine" {
  default = "mysql"
}

variable "engine_version" {
  default = "5.7.23"
}

variable "misp_allocated_storage" {
  default = 200
}

variable "misp_identifier" {
  default = "misp"
}

variable "misp_name" {
  default = "misp"
}

variable "misp_username" {
  default = "misp"
}

variable "misp_password" {
  default = "hi.mom.buy.me.cake"
}
