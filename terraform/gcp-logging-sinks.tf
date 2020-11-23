###########################################################
# stackdriver
###########################################################

/*
Create a sink for stackdriver logs into BigQuery.
*/

resource "google_logging_project_sink" "stackdriver_bigquery_sink" {
  name                   = "stackdriver_bigquery_sink"
  project                = var.gcp_project_id
  destination            = "bigquery.googleapis.com/projects/${var.gcp_project_id}/datasets/${google_bigquery_dataset.stackdriver.dataset_id}"
  unique_writer_identity = true
}

resource "google_project_iam_member" "bq_log_writer" {
  member  = google_logging_project_sink.stackdriver_bigquery_sink.writer_identity
  role    = "roles/bigquery.dataEditor"
  project = var.gcp_project_id
}
