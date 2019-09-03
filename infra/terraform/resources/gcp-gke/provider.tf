provider "google" {
  project     = "k8s-talks"
  region      = "europe-west4"
}

terraform {
  backend "s3" {
    region         = "eu-west-1"
    key            = "gcp-gke"
    bucket         = "tf-state-talks"
    dynamodb_table = "tf-state-talks-locks"
  }
}
