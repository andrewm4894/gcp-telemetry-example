
####################
## telemetry_buckets
####################

resource "google_storage_bucket" "telemetry_buckets" {
  for_each      = toset(var.telemetry_dataset_table_list)
  name          = "${var.custom_prefix}_${replace(each.value, "/", "_")}"
  location      = var.gcp_region
  force_destroy = "true"
}