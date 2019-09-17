data "google_container_cluster" "gke" {
  name     = "${var.cluster_name}"
  location = "${var.cluster_location}"
}

data "google_client_config" "current" {}

provider "kubernetes" {
  # version          = "~> 1.3"
  load_config_file       = false
  host                   = "https://${data.google_container_cluster.gke.endpoint}"
  token                  = "${data.google_client_config.current.access_token}"
  cluster_ca_certificate = "${base64decode(data.google_container_cluster.gke.master_auth.0.cluster_ca_certificate)}"
}

data "kubernetes_service" "svc" {
  metadata {
    name      = "${var.svc_name}"
    namespace = "${var.svc_namespace}"
  }
}

resource "google_dns_record_set" "endpoint" {
  name         = "${var.name}.${var.dns_zone}."
  type         = "A"
  ttl          = 300
  managed_zone = "${replace(var.dns_zone, ".", "-")}-zone"
  rrdatas      = ["${data.kubernetes_service.svc.load_balancer_ingress.0.ip}"]
}
