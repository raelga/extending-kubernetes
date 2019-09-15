# module "gke" {
#   source = "../../modules/gcp/containers/gke"
#   name = "extending-k8s"
# }

module "managed_zone" {
  source = "../../modules/gcp/dns/managed_zone"
  name = "gcloud-lominorama-com"
  dns_name = "gcloud.lominorama.com."
}

module "elasticsearch-endpoint" {
  source = "../../modules/gcp/dns/endpoint"
  name = "elasticsearch"
  managed_zone = "gcloud.lominorama.com."
  managed_zone_name = "gcloud-lominorama-com"
}

module "kibana-endpoint" {
  source = "../../modules/gcp/dns/endpoint"
  name = "kibana"
  managed_zone = "gcloud.lominorama.com."
  managed_zone_name = "gcloud-lominorama-com"
}
