/* v_custom_data */
create or replace algorithm = merge view v_custom_data as
select
  id custom_data_id,
  referenceId reference_id,
  dateAdded date_added,
  dateUpdated date_updated,
  name,
  value
from custom_data
/* do not return certain internal value */
where name != 'lola_bc_decrypt_value'
;
