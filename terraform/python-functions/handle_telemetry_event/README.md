
Example request

```bash
curl --location --request POST 'https://us-east1-gcp-telemetry-example.cloudfunctions.net/handle_telemetry_event' \
  --header 'Content-Type: application/json' \
  --data-raw '{"event_type": "default", "event_data": {"key1": "value1", "key2": "value2"}}'
```