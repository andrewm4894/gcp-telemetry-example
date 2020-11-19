"""
GCP HTTP Cloud Function to handle telemetry events.
"""
# -*- coding: utf-8 -*-
import json
import datetime
import logging

import pandas as pd


def process_request_json(request_json):
    """
    """

    # timestamp
    timestamp = str(datetime.datetime.now())

    event_data = json.loads(request_json['event_data'])

    df = pd.DataFrame.from_dict([event_data], orient='columns')
    df['timestamp'] = timestamp

    logging.info(df.info())

    response_body = {
        "timestamp": timestamp,
        "request_json": request_json,
    }

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

    # get json from request
    request_json = request.get_json()

    response = process_request_json(request_json)

    response["request_method"] = str(request.method)

    # logging response
    logging.info(response)

    return response

