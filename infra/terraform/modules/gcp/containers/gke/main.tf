resource "google_compute_network" "network" {
   name = "${var.name}-net"
}

resource "google_container_cluster" "gke" {
  name     = "${var.name}"
  location = "${var.location}"
  network  = "${google_compute_network.network.name}"
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count = 1
  logging_service = "none"
}

resource "google_container_node_pool" "gke_default_pool" {
  name       = "default-pool"
  location   = "${google_container_cluster.gke.location}"
  cluster    = "${google_container_cluster.gke.name}"
  node_count = "${var.node_count}"

  node_config {
    preemptible  = true
    machine_type = "${var.machine_type}"

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}