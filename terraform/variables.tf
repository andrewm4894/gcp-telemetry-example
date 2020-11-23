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

variable "gcs_custom_prefix" {
  type    = string
  default = var.gcp_project_id
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

# example expected data for each event
variable "example_event_data" {
  type = map(string)
  default = {
    "dataset_a/table_a1" = "{'a1_key1': 'a1_value1', 'a1_key2': 'a1_value2'}"
    "dataset_a/table_a2" = "{'a2_key1': 'a2_value1', 'a2_key2': 'a2_value2', 'a2_key3': 'a2_value3'}"
    "dataset_b/table_b1" = "{'b1_key100': 'b1_value100'}"
    "dataset_b/table_b2" = "{'b2_key200': 'b2_value200'}"
  }
}
