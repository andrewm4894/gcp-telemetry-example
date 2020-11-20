#######################################
# telemetry_gcs_to_bq
#######################################

resource "google_bigquery_data_transfer_config" "telemetry_gcs_to_bq" {
  for_each               = toset(var.telemetry_dataset_table_list)
  display_name           = "${replace(each.value, "/", "_")}_gcs_to_bq"
  location               = var.gcp_bq_location
  data_source_id         = "google_cloud_storage"
  schedule               = "every 1 hours"
  destination_dataset_id = element(split("/", each.value), 0)
  params = {
    destination_table_name_template = "raw_${element(split("/", each.value), 1)}_{run_time-1h|\"%Y%m%d\"}"
    data_path_template              = "gs://${var.custom_prefix}_${replace(each.value, "/", "_")}/{run_time|\"%Y\"}/{run_time|\"%m\"}/{run_time|\"%d\"}/{run_time-1h|\"%H\"}/*.json"
    file_format                     = "JSON"
    max_bad_records                 = 100
    allow_jagged_rows               = "true"
    allow_quoted_newlines           = "true"
    ignore_unknown_values           = "true"
  }
}