"""
GCP HTTP Cloud Function to handle telemetry events.
"""
# -*- coding: utf-8 -*-
import json
from datetime import datetime
import uuid
import os

from google.cloud import storage


def validate_request_json(request_json):
    """
    """
    if 'project' not in request_json:
        raise ValueError(f'missing project')
    if 'dataset' not in request_json:
        raise ValueError(f'missing dataset')
    if 'table' not in request_json:
        raise ValueError(f'missing table')
    if 'event_data' not in request_json:
        raise ValueError(f'missing event_data')


def process_request_json(request_json):
    """
    """

    validate_request_json(request_json)

    gcs_custom_prefix = request_json.get('gcs_custom_prefix', os.getenv('GCS_CUSTOM_PREFIX',''))
    dataset = request_json['dataset']
    table = request_json['table']
    event_key = str(request_json.get('event_key', 'default'))
    event_type = str(request_json.get('event_type', 'default'))
    event_data = request_json['event_data']

    timestamp = datetime.now()
    gcs_bucket_prefix = timestamp.strftime("%Y/%m/%d/%H")
    gcs_bucket_name = f'{gcs_custom_prefix}_{dataset}_{table}'
    gcs_file_name = 'event_{ts}_{uid}.json'.format(
        ts=timestamp.strftime("%Y%m%d%H%M%S"),
        uid=uuid.uuid4().hex.upper()[0:6]
    )
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
        data=f'{json.dumps(gcs_data)}\n',
        content_type='application/json'
    )

    response = {
        "timestamp": timestamp,
        "statusCode": 200,
    }

    return response


def handle_telemetry_event(request):
    """
    """

    if request.method != 'POST':
        raise ValueError(f'POST requests only')

    request_json = request.get_json(silent=True)
    response = process_request_json(request_json)

    return response

