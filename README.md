# gcp-telemetry-example

## cURL example post

```
curl --location --request POST 'https://us-east1-gcp-telemetry-example.cloudfunctions.net/handle_telemetry_event' \
--header 'Content-Type: application/json' \
--data-raw '{
    "bq_destination_project": "gcp-telemetry-example", 
    "bq_destination_dataset": "tmp",
    "bq_destination_table": "tmp",
    "event_type": "default",
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
    "bq_destination_project": "gcp-telemetry-example",
    "bq_destination_dataset": "tmp",
    "bq_destination_table": "tmp",
    "event_type": "default",
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
  `gcp-telemetry-example.tmp.tmp_20201119`
where
  event_key = 'mykey'
/*
[
  {
    "timestamp": "2020-11-19 23:29:50.803099 UTC",
    "event_type": "default",
    "event_key": "mykey",
    "event_data": "{'some_value':'some_key'}"
  },
  {
    "timestamp": "2020-11-19 23:27:11.601436 UTC",
    "event_type": "default",
    "event_key": "mykey",
    "event_data": "{\"some_string\": \"a string\", \"some_list\": [\"a\", \"b\", \"c\"], \"some_int\": 42, \"some_float\": 0.99, \"some_dict\": {\"some_list\": [\"foo\", \"bar\"]}}"
  }
]
*/
```

