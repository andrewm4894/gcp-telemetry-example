# gcp-telemetry-example

1. Public HTTP cloud function receives POST requests.
2. Cloud function saves event as a json file to GCS specific to each `dataset` and `table` combination.
3. BigQuery data transfer job to ingest GCS files into `<dataset>.raw_<table>_yyyymmdd` tables in BigQuery.
4. Scheduled BigQuery queries to parse raw json into daily `<dataset>.parsed_<table>_yyyymmdd` tables. 

## cURL example post

```
curl --location --request POST 'https://us-east1-gcp-telemetry-example.cloudfunctions.net/handle_telemetry_event' \
--header 'Content-Type: application/json' \
--data-raw '{
    "gcs_custom_prefix": "andrewm4894", 
    "project": "gcp-telemetry-example", 
    "dataset": "dataset_a",
    "table": "table_a2",
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
    "project": "gcp-telemetry-example",
    "dataset": "dataset_a",
    "table": "table_a1",
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
SELECT 
  * 
FROM 
  `gcp-telemetry-example.dataset_a.parsed_table_a1_20201122`
/*
timestamp,event_type,event_key,a1_key1,a1_key2
2020-11-22 11:00:00.197725,example,example,a1_value1,a1_value2
2020-11-22 04:30:00.095965,example,example,a1_value1,a1_value2
2020-11-22 18:00:00.628708,example,example,a1_value1,a1_value2
2020-11-22 20:00:00.212486,example,example,a1_value1,a1_value2
2020-11-22 03:30:00.141171,example,example,a1_value1,a1_value2
*/
```