variable "availability_zone" {}
variable "backup_availability_zone" {}
variable "vpc_cidr" {}
variable "internet_cidr" {}
variable "public_cidr" {}
variable "private_cidr" {}
variable "backup_private_cidr" {}

#
# VPC
#

resource "aws_vpc" "misp_vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = false

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name = "misp_vpc"
  }
}

output "vpc_id" {
  value = "${aws_vpc.misp_vpc.id}"
}

#
# Gateways
#

resource "aws_internet_gateway" "misp_igw" {
  vpc_id = "${aws_vpc.misp_vpc.id}"

  tags {
    Name = "misp_vpc_internet_gateway"
  }
}

resource "aws_nat_gateway" "misp_ngw" {
  allocation_id = "${aws_eip.misp_eip.id}"
  subnet_id     = "${aws_subnet.public_subnet.id}"
  depends_on    = ["aws_internet_gateway.misp_igw"]

  tags {
    Name = "misp_vpc_nat_gateway"
  }
}

#
# EIP
#

resource "aws_eip" "misp_eip" {
  vpc        = true
  depends_on = ["aws_internet_gateway.misp_igw"]

  tags {
    Name = "misp_vpc_eip"
  }
}

#
# Subnets
#

resource "aws_subnet" "public_subnet" {
  vpc_id                  = "${aws_vpc.misp_vpc.id}"
  cidr_block              = "${var.public_cidr}"
  availability_zone       = "${var.availability_zone}"
  map_public_ip_on_launch = true
  depends_on              = ["aws_internet_gateway.misp_igw"]

  tags {
    Name = "misp_public_subnet"
  }

  lifecycle {
    create_before_destroy = true
  }
}

output "public_subnet_id" {
  value = "${aws_subnet.public_subnet.id}"
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = "${aws_vpc.misp_vpc.id}"
  cidr_block              = "${var.private_cidr}"
  availability_zone       = "${var.availability_zone}"
  map_public_ip_on_launch = true

  tags {
    Name = "misp_private_subnet"
  }

  lifecycle {
    create_before_destroy = true
  }
}

output "private_subnet_id" {
  value = "${aws_subnet.private_subnet.id}"
}

resource "aws_subnet" "backup_private_subnet" {
  vpc_id                  = "${aws_vpc.misp_vpc.id}"
  cidr_block              = "${var.backup_private_cidr}"
  availability_zone       = "${var.backup_availability_zone}"
  map_public_ip_on_launch = true
  depends_on              = ["aws_nat_gateway.misp_ngw"]

  tags {
    Name = "misp_backup_private_subnet"
  }

  lifecycle {
    create_before_destroy = true
  }
}

output "backup_private_subnet_id" {
  value = "${aws_subnet.backup_private_subnet.id}"
}

#
# RDS Subnets
#

resource "aws_db_subnet_group" "rds_subnet" {
  name = "db_rds_subnet"

  subnet_ids = ["${aws_subnet.private_subnet.id}",
    "${aws_subnet.backup_private_subnet.id}",
  ]

  tags {
    Name = "misp_rds_subnet_group"
  }

  lifecycle {
    create_before_destroy = true
  }
}

output "db_subnet_group" {
  value = "${aws_db_subnet_group.rds_subnet.id}"
}

#
# Route Tables
#

resource "aws_route" "nat_default_routes" {
  route_table_id         = "${aws_route_table.private_route_table.id}"
  destination_cidr_block = "${var.internet_cidr}"
  nat_gateway_id         = "${aws_nat_gateway.misp_ngw.id}"
}

resource "aws_route" "default_route" {
  route_table_id         = "${aws_route_table.public_route_table.id}"
  destination_cidr_block = "${var.internet_cidr}"
  gateway_id             = "${aws_internet_gateway.misp_igw.id}"
}

resource "aws_route_table" "public_route_table" {
  vpc_id = "${aws_vpc.misp_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.misp_igw.id}"
  }

  tags {
    Name = "misp_vpc_public_route_table"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = "${aws_vpc.misp_vpc.id}"

  tags {
    Name = "misp_vpc_private_route_table"
  }
}

resource "aws_route_table_association" "public_rta" {
  subnet_id      = "${aws_subnet.public_subnet.id}"
  route_table_id = "${aws_route_table.public_route_table.id}"
}

resource "aws_route_table_association" "private_rta" {
  subnet_id      = "${aws_subnet.private_subnet.id}"
  route_table_id = "${aws_route_table.private_route_table.id}"
}

#
# Elasticache network
#

resource "aws_elasticache_subnet_group" "secmonkey_cache_subnet" {
  name       = "secmonkey-cache-subnet"
  subnet_ids = ["${aws_subnet.private_subnet.id}", "${aws_subnet.backup_private_subnet.id}"]
}

output "aws_cache_subnet_group" {
  value = "${aws_elasticache_subnet_group.secmonkey_cache_subnet.id}"
}
