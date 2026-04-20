variable "aws_region" {
  description = "AWS region where the lab infrastructure will be created."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used in default tags."
  type        = string
  default     = "rancher-k8s-lab"
}

variable "environment" {
  description = "Environment name used in default tags."
  type        = string
  default     = "lab"
}

variable "common_tags" {
  description = "Additional common tags applied to all resources."
  type        = map(string)
  default     = {}
}

variable "vpc_name" {
  description = "Name tag for the VPC."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "public_subnet_name" {
  description = "Name tag for the public subnet."
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet."
  type        = string
}

variable "availability_zone" {
  description = "Availability Zone where the public subnet and instances will be created, for example us-east-1a."
  type        = string
}

variable "internet_gateway_name" {
  description = "Name tag for the Internet Gateway."
  type        = string
}

variable "public_route_table_name" {
  description = "Name tag for the public route table."
  type        = string
}

variable "security_group_name" {
  description = "Name of the shared Security Group."
  type        = string
}

variable "security_group_description" {
  description = "Description of the shared Security Group."
  type        = string
  default     = "Shared security group for the Rancher/Kubernetes lab"
}

variable "ssh_ingress_cidrs" {
  description = "List of CIDR blocks allowed to access the instances using SSH."
  type        = list(string)
  default     = ["160.20.87.154/32"]
}

variable "key_pair_name" {
  description = "Existing AWS EC2 key pair name to be attached to the instances."
  type        = string
  default     = "rancher-kubernetes"
}

variable "ssh_private_key_path" {
  description = "Local path of the private key file used in the SSH command outputs. This does not affect infrastructure creation; it is only used to build friendly SSH output commands."
  type        = string
  default     = "~/.ssh/rancher-kubernetes.pem"
}

variable "instance_type" {
  description = "EC2 instance type used by all lab servers."
  type        = string
  default     = "t4g.medium"
}

variable "root_volume_size" {
  description = "Root EBS volume size in GiB for each instance."
  type        = number
  default     = 50
}

variable "root_volume_type" {
  description = "Root EBS volume type for each instance."
  type        = string
  default     = "gp3"
}

variable "delete_on_termination" {
  description = "Delete the root EBS volume automatically when the instance is destroyed."
  type        = bool
  default     = true
}

variable "instance_names" {
  description = "List containing exactly four EC2 Name tags, one for each lab instance."
  type        = list(string)

  validation {
    condition     = length(var.instance_names) == 4
    error_message = "You must provide exactly four instance names in instance_names."
  }
}

variable "ami_ssm_parameter" {
  description = "SSM public parameter used to resolve the latest Ubuntu ARM64 AMI ID."
  type        = string
  default     = "/aws/service/canonical/ubuntu/server/24.04/stable/current/arm64/hvm/ebs-gp3/ami-id"
}
