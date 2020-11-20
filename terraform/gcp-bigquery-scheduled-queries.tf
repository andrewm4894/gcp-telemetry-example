###########################################################
# telemetry_data_empty
###########################################################

/*
Create empty table with dummy schema for a separate bigquery transfer
service job to later append to once it pulls files in from gcs.
*/

resource "google_bigquery_data_transfer_config" "telemetry_data_empty" {
  for_each               = toset(var.telemetry_dataset_table_list)
  display_name           = "${element(split("/", each.value), 0)}.raw_${element(split("/", each.value), 1)}"
  data_source_id         = "scheduled_query"
  schedule               = "every 60 minutes from 00:10 to 23:10"
  destination_dataset_id = element(split("/", each.value), 0)
  location               = var.gcp_bq_location
  params = {
    destination_table_name_template = "raw_${element(split("/", each.value), 1)}_{run_time-1h|\"%Y%m%d\"}"
    write_disposition               = "WRITE_APPEND"
    query                           = file("sql/telemetry_empty.sql")
  }
}