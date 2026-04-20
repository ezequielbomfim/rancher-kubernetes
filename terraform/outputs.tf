locals {
  ssh_commands = {
    for name, ip in module.compute.instance_public_ips :
    name => "ssh -i ${var.ssh_private_key_path} ubuntu@${ip}"
  }

  ssh_summary = join("\n", concat(
    ["SSH commands for all lab instances:"],
    [for name, cmd in local.ssh_commands : format("- %s: %s", name, cmd)]
  ))
}

output "vpc_id" {
  description = "ID of the created VPC."
  value       = module.network.vpc_id
}

output "public_subnet_id" {
  description = "ID of the created public subnet."
  value       = module.network.public_subnet_id
}

output "internet_gateway_id" {
  description = "ID of the created Internet Gateway."
  value       = module.network.internet_gateway_id
}

output "public_route_table_id" {
  description = "ID of the created public route table."
  value       = module.network.public_route_table_id
}

output "security_group_id" {
  description = "ID of the shared Security Group."
  value       = module.security.security_group_id
}

output "ubuntu_ami_id" {
  description = "Ubuntu ARM64 AMI ID used for the EC2 instances."
  value       = nonsensitive(module.compute.ubuntu_ami_id)
}

output "instance_ids" {
  description = "Map of instance names to EC2 instance IDs."
  value       = module.compute.instance_ids
}

output "instance_public_ips" {
  description = "Map of instance names to public IP addresses."
  value       = module.compute.instance_public_ips
}

output "instance_private_ips" {
  description = "Map of instance names to private IP addresses."
  value       = module.compute.instance_private_ips
}

output "instance_public_dns" {
  description = "Map of instance names to public DNS names."
  value       = module.compute.instance_public_dns
}

output "ssh_commands" {
  description = "Friendly SSH commands for all EC2 instances using the configured private key path."
  value       = local.ssh_commands
}

output "ssh_summary" {
  description = "Multi-line summary with ready-to-use SSH commands for all instances."
  value       = local.ssh_summary
}
