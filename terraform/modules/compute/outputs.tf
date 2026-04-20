output "ubuntu_ami_id" {
  description = "Resolved Ubuntu ARM64 AMI ID."
  value       = nonsensitive(data.aws_ssm_parameter.ubuntu_ami.value)
}

output "instance_ids" {
  description = "Map of instance names to EC2 IDs."
  value       = { for k, v in aws_instance.this : k => v.id }
}

output "instance_public_ips" {
  description = "Map of instance names to public IPs."
  value       = { for k, v in aws_instance.this : k => v.public_ip }
}

output "instance_private_ips" {
  description = "Map of instance names to private IPs."
  value       = { for k, v in aws_instance.this : k => v.private_ip }
}

output "instance_public_dns" {
  description = "Map of instance names to public DNS names."
  value       = { for k, v in aws_instance.this : k => v.public_dns }
}
