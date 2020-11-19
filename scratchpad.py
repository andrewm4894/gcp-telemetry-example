#%%

from handle_telemetry_event.main import process_request_json

data = {
    "event_type": "default",
    "event_data": '{"key1":"value1","key2":"value2"}'
}

response = process_request_json(data)

print(response)


#%%