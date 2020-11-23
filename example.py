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
    "project": "gcp-telemetry-example",
    "dataset": "dataset_a",
    "table": "table_a1",
    "event_type": "dev",
    "event_key": "mykey",
    "event_data": json.dumps(event_data)
}

payload = json.dumps(data)
headers = {'Content-Type': 'application/json'}

response = requests.request("POST", url, headers=headers, data=payload)

print(response.json())

#%%