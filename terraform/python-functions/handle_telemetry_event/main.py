"""
GCP HTTP Cloud Function to handle telemetry events.
"""
# -*- coding: utf-8 -*-
import json
from datetime import datetime
import logging
import uuid

import pandas as pd
from google.cloud import storage


def validate_request_json(request_json):
    """
    """
    if 'bq_destination_project' not in request_json:
        raise ValueError(f'bq_destination_project not found in request_json')
    if 'bq_destination_dataset' not in request_json:
        raise ValueError(f'bq_destination_dataset not found in request_json')
    if 'bq_destination_table' not in request_json:
        raise ValueError(f'bq_destination_table not found in request_json')
    if 'event_data' not in request_json:
        raise ValueError(f'event_data not found in request_json')


def process_request_json(request_json):
    """
    """

    validate_request_json(request_json)

    gcs_custom_prefix = request_json.get('gcs_custom_prefix', 'andrewm4894')
    bq_destination_dataset = request_json['bq_destination_dataset']
    bq_destination_table = request_json['bq_destination_table']
    event_key = str(request_json.get('event_key', 'default'))
    event_type = str(request_json.get('event_type', 'default'))
    event_data = request_json['event_data']

    timestamp = datetime.now()
    timestamp_yyyymmddhhmmss = timestamp.strftime("%Y%m%d%H%M%S")
    random_id = uuid.uuid4().hex.upper()[0:6]
    gcs_bucket_prefix = timestamp.strftime("%Y/%m/%d/%H")
    gcs_bucket_name = f'{gcs_custom_prefix}_{bq_destination_dataset}_{bq_destination_table}'
    gcs_file_name = f'event_{timestamp_yyyymmddhhmmss}_{random_id}.json'
    gcs_full_path = f'{gcs_bucket_prefix}/{gcs_file_name}'

    client = storage.Client()
    bucket = client.get_bucket(gcs_bucket_name)
    blob = bucket.blob(gcs_full_path)
    gcs_data = {
        'timestamp': str(timestamp),
        'event_type': event_type,
        'event_key': event_key,
        'event_data': event_data
    }
    blob.upload_from_string(
        data=json.dumps(gcs_data),
        content_type='application/json'
    )

    response = {
        "statusCode": 200,
        "body": {
            "timestamp": timestamp,
            "request_json": request_json,
        }
    }

    return response


def handle_telemetry_event(request):
    """
    """

    request_json = request.get_json(silent=True)
    response = process_request_json(request_json)
    response["request_method"] = request.method
    logging.info(response)

    return response

