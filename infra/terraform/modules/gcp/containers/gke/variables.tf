variable "location" {
  description = "Google Cloud location"
  type        = "string"
  default     = "europe-west4"
}

variable "name" {
  description = "Google Kubernetes Engine cluster name"
  type        = "string"
}

variable "environment" {
  description = "Environment (e.g. `prod`, `dev`, `staging`)"
  type        = "string"
  default = "test"
}

variable "machine_type" {
  description = "Machine type for the node pools"
  type        = "string"
  default     = "n2-standard-4"
}

variable "node_count" {
  description = "Node pool size"
  type        = "string"
  default     = 1
}

