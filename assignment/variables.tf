variable "naming_prefix" {
  type        = string
  description = "Naming prefix for resources"
  default     = "angel"
}

variable "env" {
  description = "Environment Name / Workspace Name"
  type        = string
  default     = "Swe"
}


variable "aws_region" {
  type        = string
  description = "Region for AWS Resources"
  default     = "ap-southeast-1"
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS hostnames in VPC"
  default     = true
}

variable "vpc_cidr_block" {
  type        = string
  description = "Base CIDR Block for VPC"
  default     = "10.0.0.0/16"
}

variable "vpc_subnet_count" {
  type        = number
  description = "Number of subnets to create in VPC"
  default     = 3
}

variable "vpc_private_subnet_cidr_blocks" {
  type        = list(string)
  description = "Base CIDR Block for VPC (Private Subnet)"
  default     = ["172.31.48.0/24", "172.31.64.0/24", "172.31.80.0/24"]
}


variable "vpc_private_subnet_count" {
  type        = number
  description = "Number of subnets to create in VPC"
  default     = 3
}

variable "map_public_ip_on_launch" {
  type        = bool
  description = "Map a public IP address for Subnet instances"
  default     = true
}

variable "instance_type" {
  type        = string
  description = "Type for EC2 Instance"
  default     = "t2.micro"
}

variable "instance_count" {
  type        = number
  description = "Number of instances to create in VPC"
  default     = 3
}

variable "company" {
  type        = string
  description = "Company name for resource tagging"
  default     = "company-name"
}

variable "project" {
  type        = string
  description = "Project name for resource tagging"
  default     = "server-fleet-nginx"
}

variable "repo_name" {
  type        = string
  default     = "counter-app"
  description = "ECR repo to store a Docker image."
}