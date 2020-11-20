SELECT
  *
FROM
  `${gcp_project_id}.${dataset_name}.raw_${table_name}_*`
WHERE
  _TABLE_SUFFIX = REPLACE(CAST(DATE_ADD(@run_date, INTERVAL -1 DAY) as STRING),"-","")
