locals {
  cluster_name = "extending-k8s"
  manage_zone  = "talks.cloudnative.barcelona"
}

module "gke" {
  source = "../../modules/gcp/containers/gke"
  name   = "${local.cluster_name}"
}

# module "elasticsearch_endpoint" {
#   source       = "../../modules/gcp/dns/endpoint"
#   name         = "elasticsearch"
#   cluster_name = "${local.cluster_name}"
#   dns_zone     = "${local.dns_zone}"
#   svc_name     = "elasticsearch-es-http"
# }

# module "kibana_endpoint" {
#   source       = "../../modules/gcp/dns/endpoint"
#   name         = "kibana"
#   cluster_name = "${local.cluster_name}"
#   dns_zone     = "${local.dns_zone}"
#   svc_name     = "kibana-kb-http"
# }
