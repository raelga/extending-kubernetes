variable "name" {
  description = "EC2 instance name"
  type        = "string"
}

variable "region" {
  description = "EC2 region"
  type        = "string"
  default     = "eu-west-1"
}
variable "vpc" {
  description = "EC2 VPC"
  type        = "string"
}
variable "subnet" {
  description = "EC2 VPC Subnet"
  type        = "string"
}