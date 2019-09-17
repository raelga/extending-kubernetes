variable "name" {
  description = "Name for this endpoint"
  type        = "string"
}

variable "dns_zone" {
  description = "The DNS of this managed zone"
  type        = "string"
}

variable "cluster_name" {
  description = "The GKE cluster name"
  type = "string"
}

variable "cluster_location" {
  description = "GKE cluster location"
  type        = "string"
  default     = "europe-west4"
}

variable "svc_name" {
  description = "Name of the Kubernetes service"
  type        = "string"
}

variable "svc_namespace" {
  description = "Namespace of the Kubernetes service"
  type        = "string"
  default     = "default"
}
