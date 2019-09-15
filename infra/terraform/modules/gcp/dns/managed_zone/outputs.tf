output "nameservers" {
  value = "${google_dns_managed_zone.dns_zone.name_servers}"
}
