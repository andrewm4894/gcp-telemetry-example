#%%

from datetime import datetime
import uuid

from google.cloud import storage

#%%

client = storage.Client()

timestamp = datetime.now()

bucket = 'andrewm4894_dataset_a_table_a1'
bucket = client.get_bucket('andrewm4894_dataset_a_table_a1')
prefix = '2020/11/23/22'

blobs = client.list_blobs(bucket, prefix=f'{prefix}/event_', max_results=2)
blobs_to_compose = []
blobs_to_delete = []
for blob in blobs:
    blobs_to_compose.append(blob)
    blobs_to_delete.append(blob)
gcs_file_name = '{prefix}/events_{ts}_{uid}.json'.format(
    prefix=prefix,
    ts=timestamp.strftime("%Y%m%d%H%M%S"),
    uid=uuid.uuid4().hex.upper()[0:6]
    )
destination = bucket.blob(gcs_file_name)
destination.content_type = "application/json"
destination.compose(blobs_to_compose)
for blob in blobs_to_delete:
    blob.delete()

#%%