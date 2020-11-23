SELECT
  timestamp,
  event_type,
  event_key,
  json_extract_scalar(event_data,'$.b2_key200') as b2_key200,
FROM
  `${gcp_project_id}.${dataset_name}.raw_${table_name}_*`
WHERE
  _TABLE_SUFFIX = REPLACE(CAST(DATE_ADD(@run_date, INTERVAL -1 DAY) as STRING),"-","")
  and
  event_type in ('example')