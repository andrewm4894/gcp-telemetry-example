###########################################################
# telemetry_data_buckets
###########################################################

/*
GCS buckets to save event data to.
*/

resource "google_storage_bucket" "telemetry_data_buckets" {
  for_each      = toset(var.telemetry_dataset_table_list)
  name          = "${var.gcs_custom_prefix}_${replace(each.value, "/", "_")}"
  location      = var.gcp_region
  force_destroy = "true"
}
