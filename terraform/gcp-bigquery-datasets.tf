####################
## tmp
####################

resource "google_bigquery_dataset" "tmp" {
  dataset_id                  = "tmp"
  location                    = "US"
  default_table_expiration_ms = 3600000
  description                 = "Temp dataset for dev and testing - tables will be automatically deleted."
}