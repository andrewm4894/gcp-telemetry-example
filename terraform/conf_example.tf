# conf_example.tf - example expected conf.tf file. Uncomment the below, add your real values and save file as conf.tf.
# make sure to include conf.tf in .gitignore if not already.

/*
variable "gcp_terraform_service_account_json_path" {
  type    = string
  default = "path/to/your/file.json"
}
*/

/*
variable "gcp_project_id" {
  type    = string
  default = "some-project-name"
}
*/

/*
variable "gcp_project_number" {
  type    = string
  default = "123456789"
}
*/

/*
variable "service_account_email" {
  type    = string
  default = "blah@blah"
}
*/

/*
variable "cloud_function_members_list" {
  type = list(string)
  default = [
    "serviceAccount:blah@blah",
  ]
}
*/