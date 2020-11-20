## handle_telemetry_event

Example request

```bash
curl --location --request POST 'https://us-east1-gcp-telemetry-example.cloudfunctions.net/handle_telemetry_event' \
--header 'Content-Type: application/json' \
--data-raw '{
    "gcs_custom_prefix": "andrewm4894", 
    "bq_destination_project": "gcp-telemetry-example", 
    "bq_destination_dataset": "dataset_a",
    "bq_destination_table": "table_a2",
    "event_type": "dev",
    "event_key": "mykey",
    "event_data": "{'\''some_value'\'':'\''some_key'\''}"
    }'
```