#%%

import json
from handle_telemetry_event.main import process_request_json

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
    "event_key": "123456",
    "event_data": json.dumps(event_data)
}
response = process_request_json(data)
print(response)

#%%