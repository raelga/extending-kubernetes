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

variable "system_default_user" {
  description = "EC2 instance default user"
  type        = "string"
  default     = "ubuntu"
}

variable "system_user" {
  description = "EC2 instance user"
  type        = "string"
  default     = "rael"
}
variable "github_user" {
  description = "GitHub user, to retrieve the public ssh keys"
  type        = "string"
  default     = "raelga"
}
