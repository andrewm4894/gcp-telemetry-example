#%%

import json
import requests

url = "https://us-east1-gcp-telemetry-example.cloudfunctions.net/handle_telemetry_event"

event_data = {
    "foo": "bar"
}

data = {
    "event_type": "default",
    "event_data": json.dumps(event_data)
}

payload = json.dumps(data)
headers = {
  'Content-Type': 'application/json'
}

response = requests.request("POST", url, headers=headers, data=payload)

print(response.text)

#%%