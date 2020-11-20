############################################################
## telemetry_data_livenesss
############################################################

resource "google_cloud_scheduler_job" "telemetry_data_livenesss" {
  for_each    = toset(var.telemetry_dataset_table_list)
  name        = "telemetry_data_livenesss_${replace(each.value, "/", "_")}"
  description = "Send a liveness event to the endpoint for ${each.value}"
  schedule    = "*/1 * * * *"
  http_target {
    http_method = "POST"
    uri         = google_cloudfunctions_function.pyfunc_handle_telemetry_event.https_trigger_url
    headers = {
      "content-type" : "application/json"
    }
    body = base64encode(jsonencode({
      "gcs_custom_prefix" : "andrewm4894",
      "bq_destination_project" : "gcp-telemetry-example",
      "bq_destination_dataset" : element(split("/", each.value), 0),
      "bq_destination_table" : element(split("/", each.value), 1),
      "event_type" : "liveness",
      "event_key" : "liveness",
      "event_data" : "liveness"
    }))
  }
}