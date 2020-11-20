# gcp-telemetry-example

## cURL example post

```
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

## Python example post

```python
import json
import requests
url = "https://us-east1-gcp-telemetry-example.cloudfunctions.net/handle_telemetry_event"
event_data = {
    "some_string": "a string",
    "some_list": ['a', 'b', 'c'],
    "some_int": 42,
    "some_float": 0.99,
    "some_dict": {"some_list": ['foo', 'bar']}
}
data = {
    "gcs_custom_prefix": "andrewm4894",
    "bq_destination_project": "gcp-telemetry-example",
    "bq_destination_dataset": "dataset_a",
    "bq_destination_table": "table_a1",
    "event_type": "dev",
    "event_key": "mykey",
    "event_data": json.dumps(event_data)
}
payload = json.dumps(data)
headers = {
  'Content-Type': 'application/json'
}
response = requests.request("POST", url, headers=headers, data=payload)
print(response.json())
```

## Results in BigQuery

```SQL
select
  *
from
  `gcp-telemetry-example.dataset_a.table_a1_20201119`
where
  event_type = 'dev'
```

![Alt text](misc/bq.jpg?raw=true "Results in BigQuery UI.")
