variable "subnet_id" {
  description = "Subnet ID where the instances will be created."
  type        = string
}

variable "security_group_id" {
  description = "Security Group ID to attach to the instances."
  type        = string
}

variable "key_pair_name" {
  description = "Existing EC2 key pair name."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
}

variable "root_volume_size" {
  description = "Root EBS volume size in GiB."
  type        = number
}

variable "root_volume_type" {
  description = "Root EBS volume type."
  type        = string
}

variable "delete_on_termination" {
  description = "Delete root volume when instance is destroyed."
  type        = bool
}

variable "instance_names" {
  description = "List of instance names."
  type        = list(string)
}

variable "ami_ssm_parameter" {
  description = "SSM public parameter path used to resolve the latest Ubuntu ARM64 AMI."
  type        = string
}
