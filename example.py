#%%

import json
import requests

url = "https://us-east1-gcp-telemetry-example.cloudfunctions.net/handle_telemetry_event"

event_data = {
    "some_string": "a string",
    "some_list": ["a", "b", "c"],
    "some_int": 42,
    "some_float": 0.99,
    "some_dict": {"some_list": ["foo", "bar"]}
}

data = {
    "gcs_custom_prefix": "andrewm4894",
    "bq_destination_project": "gcp-telemetry-example",
    "bq_destination_dataset": "tmp_a",
    "bq_destination_table": "tmp_a1",
    "event_type": "default",
    "event_key": "mykey2",
    #"event_data": json.dumps(event_data),
    "event_data": "just a string"
}

payload = json.dumps(data)
headers = {
  'Content-Type': 'application/json'
}

response = requests.request("POST", url, headers=headers, data=payload)

print(response.json())

#%%