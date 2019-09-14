provider "google" {
  project     = "fluid-acrobat-252814"
  region      = "europe-west4"
  credentials = "${file("fluid-acrobat-252814-7af15b373a26.json")}"
}
