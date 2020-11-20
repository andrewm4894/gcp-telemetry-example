########################################
## handle-telemetry-event
########################################

/*
*/

variable "pyfunc_info_handle_telemetry_event" {
  type = map(string)
  default = {
    name    = "handle_telemetry_event"
    version = "v1.2"
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
  name = "${var.custom_prefix}_pyfunc_${var.pyfunc_info_handle_telemetry_event.name}"
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
  description           = "handle_telemetry_event"
  available_memory_mb   = 256
  source_archive_bucket = google_storage_bucket.pyfunc_handle_telemetry_event.name
  source_archive_object = google_storage_bucket_object.pyfunc_zip_handle_telemetry_event.name
  trigger_http          = true
  entry_point           = "handle_telemetry_event"
  timeout               = 520
  runtime               = "python37"
  environment_variables = {
  }
}

resource "google_cloudfunctions_function_iam_member" "pyfunc_invoker_handle_telemetry_event" {
  project        = google_cloudfunctions_function.pyfunc_handle_telemetry_event.project
  region         = google_cloudfunctions_function.pyfunc_handle_telemetry_event.region
  cloud_function = google_cloudfunctions_function.pyfunc_handle_telemetry_event.name
  role           = "roles/cloudfunctions.invoker"
  member         = "allUsers"
}