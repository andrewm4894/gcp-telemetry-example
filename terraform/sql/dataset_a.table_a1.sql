
/*
Specific SQL to parse out expected event data into individual columns in parsed_...._yyyymmdd table's for end users.
*/

SELECT
  timestamp,
  event_type,
  event_key,
  json_extract_scalar(event_data,'$.a1_key1') as a1_key1,
  json_extract_scalar(event_data,'$.a1_key2') as a1_key2,
FROM
  `${gcp_project_id}.${dataset_name}.raw_${table_name}_*`
WHERE
  _TABLE_SUFFIX = REPLACE(CAST(DATE_ADD(@run_date, INTERVAL -1 DAY) as STRING),"-","")
  and
  event_type in ('example')
