###########################################################
# telemetry_data_liveness
###########################################################

/*
Send a empty event for each event type to the telemetry endpoint that can
serve as a sort of liveness probe and for health testing and monitoring.
*/

resource "google_cloud_scheduler_job" "telemetry_data_liveness" {
  for_each    = toset(var.telemetry_dataset_table_list)
  name        = "telemetry_data_liveness_${replace(each.value, "/", "_")}"
  description = "Send a liveness event to the endpoint for ${each.value}"
  schedule    = "*/15 * * * *"
  http_target {
    http_method = "POST"
    uri         = google_cloudfunctions_function.pyfunc_handle_telemetry_event.https_trigger_url
    headers = {
      "content-type" : "application/json"
    }
    body = base64encode(jsonencode({
      "project" : var.gcp_project_id,
      "dataset" : element(split("/", each.value), 0),
      "table" : element(split("/", each.value), 1),
      "event_type" : "liveness",
      "event_key" : "liveness",
      "event_data" : "liveness"
    }))
  }
}

###########################################################
# telemetry_data_example
###########################################################

resource "google_cloud_scheduler_job" "telemetry_data_example" {
  for_each    = toset(var.telemetry_dataset_table_list)
  name        = "telemetry_data_example_${replace(each.value, "/", "_")}"
  description = "Send an example event to the endpoint for ${each.value}"
  schedule    = "*/10 * * * *"
  http_target {
    http_method = "POST"
    uri         = google_cloudfunctions_function.pyfunc_handle_telemetry_event.https_trigger_url
    headers = {
      "content-type" : "application/json"
    }
    body = base64encode(jsonencode({
      "project" : var.gcp_project_id,
      "dataset" : element(split("/", each.value), 0),
      "table" : element(split("/", each.value), 1),
      "event_type" : "example",
      "event_key" : "example",
      "event_data" : var.example_event_data[each.value]
    }))
  }
}

############################################################
## compose_telemetry_events
############################################################

/*
compose_telemetry_events
*/

resource "google_cloud_scheduler_job" "compose_telemetry_events" {
  for_each    = toset(var.telemetry_dataset_table_list)
  name        = "compose_telemetry_events_${replace(each.value, "/", "_")}"
  description = "Compose telemetry events for ${each.value}"
  schedule    = "*/10 * * * *"
  pubsub_target {
    topic_name = google_pubsub_topic.compose_telemetry_events.id
    # data to pass to function being called
    data = base64encode(jsonencode({
      "dataset" : element(split("/", each.value), 0),
      "table" : element(split("/", each.value), 1),
    }))
  }
}
