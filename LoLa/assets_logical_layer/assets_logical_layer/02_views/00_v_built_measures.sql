/* v_built_measures */
create or replace algorithm = merge view v_built_measures as
with docs as (select
  'Utility view that lists all built measure tables' view_doc,
  'built_table' view_grain,
  'Name of the base measure' measure_name,
  'Type of measure: asof ("as of date") or range ("date range")' measure_type,
  'Specified start date for range measures' start_date,
  'Specified end date for range measures or as of date for asof measures' end_date,
  'Physical built table name for the provided parameters' built_name,
  'Flagged 1 if the requested end/asof date was future to the build date, making the result possibly incomplete' future_dated,
  'Number of rows in the table' num_rows,
  'Storage size of the table in bytes' disk_size,
  'Datetime that the measure table was created in UTC' created,
  'Datetime that the measure table was last updated in UTC' updated,
  'Name of the SQL user account used to build the measure' sql_builder,
  'Number of seconds it took to build the measure' build_secs,
  'Name of the authenticated BriteCore User whose query/report caused the measure to be built' api_builder,
  'Datetime that the table was last queried via BriteCore (not updated for direct SQL connection queries)' last_accessed,
  'Name of the authenticated BriteCore User to last access the measure data via query' last_api_user,
  'Object storing the metadata on the built measure' json_metadata
)
select
  left(json_unquote(json_extract(t.table_comment, '$.name')), 255) name,
  left(json_unquote(json_extract(t.table_comment, '$.type')), 10) type,
  cast(json_unquote(json_extract(t.table_comment, '$.start_date')) as date) start_date,
  cast(json_unquote(json_extract(t.table_comment, '$.end_date')) as date) end_date,
  t.table_name built_name,
  t.create_time < (cast(json_unquote(json_extract(t.table_comment, '$.end_date')) as date) + interval 1 day) future_dated,
  t.table_rows num_rows,
  t.data_length + t.index_length disk_size,
  t.create_time created,
  t.update_time updated,
  left(json_unquote(json_extract(t.table_comment, '$.sql_builder')), 64) sql_builder,
  cast(json_unquote(json_extract(t.table_comment, '$.build_secs')) as decimal(9,4)) build_secs,
  left(json_unquote(json_extract(t.table_comment, '$.api_builder')), 128) api_builder,
  cast(json_unquote(json_extract(t.table_comment, '$.last_accessed')) as datetime) last_accessed,
  left(json_unquote(json_extract(t.table_comment, '$.last_api_user')), 128) last_api_user,
  t.table_comment json_metadata
from docs
join information_schema.tables t on true
where table_schema = schema()
  and table_name like 'm\_%';
