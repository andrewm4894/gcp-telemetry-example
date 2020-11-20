/*
Create an empty row to insert into an event table.
*/

select
  cast(current_timestamp() as string) as timestamp,
  'empty' as event_type,
  'empty' as event_key,
  'empty' as event_data