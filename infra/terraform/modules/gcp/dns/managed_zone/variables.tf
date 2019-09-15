variable "name" {
  description = "User assigned name for this resource"
  type        = "string"
}

variable "dns_name" {
  description = "The DNS name of this managed zone"
  type        = "string"
}

variable "description" {
  description = "Description for the zone"
  type        = "string"
  default = "DNS zone"
}

