output "public_ip" {
  value = "${module.instances.public_ip}"
}

output "misp_rds_endpoint" {
  description = "The connection endpoint"
  value       = "${module.rds.misp_rds_endpoint}"
}
