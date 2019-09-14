module "gke" {
  source = "../../modules/gcp/containers/gke"
  name = "extending-k8s"
}

module "managed_zone" {
  source = "../../modules/gcp/dns/managed_zone"
  name = "gcloud-lominorama-com"
  dns_name = "gcloud.lominorama.com."
}
