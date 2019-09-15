locals {
  cluster_name = "extending-k8s"
  managed_zone = "gcloud.lominorama.com"
}

module "gke" {
  source = "../../modules/gcp/containers/gke"
  name   = "${local.cluster_name}"
}

module "managed_zone" {
  source   = "../../modules/gcp/dns/managed_zone"
  name     = "gcloud-lominorama-com"
  dns_name = "gcloud.lominorama.com."
}

module "elasticsearch_endpoint" {
  source            = "../../modules/gcp/dns/endpoint"
  name              = "elasticsearch"
  cluster_name      = "${local.cluster_name}"
  managed_zone      = "${local.managed_zone}"
  svc_name          = "elasticsearch-es-http"
}

module "kibana_endpoint" {
  source            = "../../modules/gcp/dns/endpoint"
  name              = "kibana"
  cluster_name      = "${local.cluster_name}"
  managed_zone      = "${local.managed_zone}"
  svc_name          = "kibana-kb-http"
}
