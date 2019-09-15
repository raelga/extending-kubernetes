resource "google_compute_address" "public_ip" {
  name = "${var.name}"
}

resource "google_dns_record_set" "endpoint" {
  name = "${var.name}.${var.managed_zone}"
  type = "A"
  ttl  = 300
  managed_zone = "${var.managed_zone_name}"
  rrdatas = ["${google_compute_address.public_ip.address}"]
}