resource "google_app_engine_application" "app" {
  project     = var.gcp_project_id
  location_id = var.gcp_region
}