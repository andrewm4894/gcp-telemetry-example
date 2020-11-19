terraform {
  backend "gcs" {
    bucket = "gcp-telemetry-example-tf-state"
    prefix = "terraform/state"
  }
}