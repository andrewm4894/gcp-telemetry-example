"""
GCP Pub/Sub Cloud Function to compose telemetry events.
"""
# -*- coding: utf-8 -*-
import json
from datetime import datetime
import uuid
import os
import base64

from google.cloud import storage


def process_event(event_data_json):
    """
    """

    timestamp = datetime.now()
    gcs_custom_prefix = event_data_json.get('gcs_custom_prefix', os.getenv('GCS_CUSTOM_PREFIX', ''))
    gcs_bucket_prefix = timestamp.strftime("%Y/%m/%d/%H")
    dataset = event_data_json['dataset']
    table = event_data_json['table']

    client = storage.Client()
    bucket = f'{gcs_custom_prefix}_{dataset}_{table}'
    bucket = client.get_bucket(bucket)

    blobs = client.list_blobs(
        bucket,
        prefix=f'{gcs_bucket_prefix}/event',
        max_results=32
    )
    blobs_to_compose = []
    blobs_to_delete = []
    for blob in blobs:
        blobs_to_compose.append(blob)
        blobs_to_delete.append(blob)
    gcs_file_name = '{gcs_bucket_prefix}/events_{ts}_{uid}.json'.format(
        gcs_bucket_prefix=gcs_bucket_prefix,
        ts=timestamp.strftime("%Y%m%d%H%M%S"),
        uid=uuid.uuid4().hex.upper()[0:6]
    )
    destination = bucket.blob(gcs_file_name)
    destination.content_type = "application/json"
    destination.compose(blobs_to_compose)
    for blob in blobs_to_delete:
        blob.delete()

    response = {
        "timestamp": timestamp,
        "statusCode": 200,
    }

    return response


def handle_telemetry_event(event, context=None):
    """
    """

    # get data from event into a dict
    event_data_json = json.loads(base64.b64decode(event['data']).decode('utf-8'))

    response = process_event(event_data_json)

    return response

