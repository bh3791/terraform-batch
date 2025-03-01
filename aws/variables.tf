variable "deployment_name" {
  description = "Deployment Name"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/19"
}

variable "subnet1_cidr_block" {
  description = "CIDR block for subnet1"
  type        = string
  default     = "10.0.0.0/20"
}

variable "subnet2_cidr_block" {
  description = "CIDR block for subnet2"
  type        = string
  default     = "10.0.16.0/20"
}

variable "route_table_cidr_block" {
  description = "CIDR block for route table"
  type        = string
  default     = "0.0.0.0/0"
}