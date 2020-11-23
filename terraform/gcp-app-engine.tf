###########################################################
# app
###########################################################

/*
An app engine instance is required to be able to use cloud scheduler
so we just define an empty one below.
*/

resource "google_app_engine_application" "app" {
  project     = var.gcp_project_id
  location_id = var.gcp_region
}
