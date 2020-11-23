###########################################################
# tmp
###########################################################

/*
Temporary dataset for dev and testing. Tables will automatically
be expired and deleted.
*/

resource "google_bigquery_dataset" "tmp" {
  dataset_id                  = "tmp"
  location                    = var.gcp_bq_location
  default_table_expiration_ms = 3600000
  description                 = "Temp dataset for dev and testing - tables will be automatically deleted."
}

###########################################################
# telemetry_datasets
###########################################################

/*
Dataset for specific events.
*/

resource "google_bigquery_dataset" "telemetry_datasets" {
  for_each    = toset(var.telemetry_dataset_list)
  dataset_id  = each.value
  location    = var.gcp_bq_location
  description = "Dataset for ${each.value} data."
}

###########################################################
# stackdriver
###########################################################

/*
Dataset for stackdriver log sinks.
*/

resource "google_bigquery_dataset" "stackdriver" {
  dataset_id = "stackdriver"
  location   = var.gcp_bq_location
  description = "Stackdriver log related data."
}
