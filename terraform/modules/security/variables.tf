variable "vpc_id" {
  description = "VPC ID where the Security Group will be created."
  type        = string
}

variable "security_group_name" {
  description = "Security Group name."
  type        = string
}

variable "security_group_description" {
  description = "Security Group description."
  type        = string
}

variable "ssh_ingress_cidrs" {
  description = "CIDRs allowed to access SSH."
  type        = list(string)
}
