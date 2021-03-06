###########################################################
# handle_telemetry_event
###########################################################

/*
Function to handle http event and save to relevant GCS bucket.
*/

# define some metadata about the function, useful for easily incrementing by changing version number
variable "pyfunc_info_handle_telemetry_event" {
  type = map(string)
  default = {
    name    = "handle_telemetry_event"
    version = "v1.6"
  }
}

# zip up our source code
data "archive_file" "pyfunc_zip_handle_telemetry_event" {
  type        = "zip"
  source_dir  = "${path.root}/python-functions/${var.pyfunc_info_handle_telemetry_event.name}/"
  output_path = "${path.root}/python-functions/zipped/${var.pyfunc_info_handle_telemetry_event.name}_${var.pyfunc_info_handle_telemetry_event.version}.zip"
}

# create the storage bucket
resource "google_storage_bucket" "pyfunc_handle_telemetry_event" {
  name = "${var.gcs_custom_prefix}_pyfunc_${var.pyfunc_info_handle_telemetry_event.name}"
}

# place the zip-ed code in the bucket
resource "google_storage_bucket_object" "pyfunc_zip_handle_telemetry_event" {
  name   = "${var.pyfunc_info_handle_telemetry_event.name}_${var.pyfunc_info_handle_telemetry_event.version}.zip"
  bucket = google_storage_bucket.pyfunc_handle_telemetry_event.name
  source = "${path.root}/python-functions/zipped/${var.pyfunc_info_handle_telemetry_event.name}_${var.pyfunc_info_handle_telemetry_event.version}.zip"
}

# define the function resource
resource "google_cloudfunctions_function" "pyfunc_handle_telemetry_event" {
  name                  = var.pyfunc_info_handle_telemetry_event.name
  description           = "Save event data to the relevant GCS bucket as defined by the body of received http POST."
  available_memory_mb   = 256
  source_archive_bucket = google_storage_bucket.pyfunc_handle_telemetry_event.name
  source_archive_object = google_storage_bucket_object.pyfunc_zip_handle_telemetry_event.name
  trigger_http          = true
  entry_point           = var.pyfunc_info_handle_telemetry_event.name
  timeout               = 120
  runtime               = "python37"
  environment_variables = {
    GCS_CUSTOM_PREFIX = var.gcs_custom_prefix
  }
}

# define iam settings for the function
resource "google_cloudfunctions_function_iam_member" "pyfunc_invoker_handle_telemetry_event" {
  project        = google_cloudfunctions_function.pyfunc_handle_telemetry_event.project
  region         = google_cloudfunctions_function.pyfunc_handle_telemetry_event.region
  cloud_function = google_cloudfunctions_function.pyfunc_handle_telemetry_event.name
  role           = "roles/cloudfunctions.invoker"
  member         = "allUsers"
}

###########################################################
# compose_telemetry_events
###########################################################

/*
*/

# define some metadata about the function, useful for easily incrementing by changing version number
variable "pyfunc_info_compose_telemetry_events" {
  type = map(string)
  default = {
    name    = "compose_telemetry_events"
    version = "v0.2"
  }
}

# zip up our source code
data "archive_file" "pyfunc_zip_compose_telemetry_events" {
  type        = "zip"
  source_dir  = "${path.root}/python-functions/${var.pyfunc_info_compose_telemetry_events.name}/"
  output_path = "${path.root}/python-functions/zipped/${var.pyfunc_info_compose_telemetry_events.name}_${var.pyfunc_info_compose_telemetry_events.version}.zip"
}

# create the storage bucket
resource "google_storage_bucket" "pyfunc_compose_telemetry_events" {
  name = "${var.gcs_custom_prefix}_pyfunc_${var.pyfunc_info_compose_telemetry_events.name}"
}

# place the zip-ed code in the bucket
resource "google_storage_bucket_object" "pyfunc_zip_compose_telemetry_events" {
  name   = "${var.pyfunc_info_compose_telemetry_events.name}_${var.pyfunc_info_compose_telemetry_events.version}.zip"
  bucket = google_storage_bucket.pyfunc_compose_telemetry_events.name
  source = "${path.root}/python-functions/zipped/${var.pyfunc_info_compose_telemetry_events.name}_${var.pyfunc_info_compose_telemetry_events.version}.zip"
}

# define the function resource
resource "google_cloudfunctions_function" "pyfunc_compose_telemetry_events" {
  name                  = var.pyfunc_info_compose_telemetry_events.name
  description           = "Compose multiple single events into a bigger events file."
  available_memory_mb   = 1024
  source_archive_bucket = google_storage_bucket.pyfunc_compose_telemetry_events.name
  source_archive_object = google_storage_bucket_object.pyfunc_zip_compose_telemetry_events.name
  entry_point           = "compose_telemetry_events"
  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.compose_telemetry_events.id
  }
  timeout               = 540
  runtime               = "python37"
  environment_variables = {
    GCS_CUSTOM_PREFIX = var.gcs_custom_prefix
  }
  service_account_email = var.service_account_email
}

# define iam settings for the function
resource "google_cloudfunctions_function_iam_binding" "pyfunc_iam_binding_compose_telemetry_events" {
  project        = google_cloudfunctions_function.pyfunc_compose_telemetry_events.project
  region         = google_cloudfunctions_function.pyfunc_compose_telemetry_events.region
  cloud_function = google_cloudfunctions_function.pyfunc_compose_telemetry_events.name
  role           = "roles/cloudfunctions.invoker"
  members        = var.cloud_function_members_list
}
