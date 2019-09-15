resource "google_dns_managed_zone" "dns_zone" {
  name = "${var.name}"
  dns_name = "${var.dns_name}"
  description = "${var.description}"
}