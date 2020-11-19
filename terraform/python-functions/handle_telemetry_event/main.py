"""
GCP HTTP Cloud Function to handle telemetry events.
"""
# -*- coding: utf-8 -*-
from datetime import datetime
import logging

import pandas as pd


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

    timestamp = datetime.now()
    bq_destination_project = request_json['bq_destination_project']
    bq_destination_dataset = request_json['bq_destination_dataset']
    bq_destination_table = request_json['bq_destination_table']
    bq_table_suffix = timestamp.strftime("%Y%m%d")
    event_key = str(request_json.get('event_key', 'default'))
    event_type = str(request_json.get('event_type', 'default'))
    event_data = request_json['event_data']

    df = pd.DataFrame(
        data=[[timestamp, event_type, event_key, event_data]],
        columns=['timestamp', 'event_type', 'event_key', 'event_data']
    )
    df.to_gbq(
        destination_table=f'{bq_destination_dataset}.{bq_destination_table}_{bq_table_suffix}',
        project_id=bq_destination_project,
        if_exists='append'
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

