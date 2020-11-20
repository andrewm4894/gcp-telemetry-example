variable "gcp_region" {
  type    = string
  default = "us-east1"
}

variable "gcp_zone" {
  type    = string
  default = "us-east1-a"
}

variable "gcp_bq_location" {
  type    = string
  default = "US"
}

variable "custom_prefix" {
  type    = string
  default = "andrewm4894"
}

# define datasets in scope
variable "telemetry_dataset_list" {
  type = list(string)
  default = [
    "dataset_a",
    "dataset_b",
  ]
}

# define datasets and tables in scope
variable "telemetry_dataset_table_list" {
  type = list(string)
  default = [
    "dataset_a/table_a1",
    "dataset_a/table_a2",
    "dataset_b/table_b1",
    "dataset_b/table_b2",
  ]
}
