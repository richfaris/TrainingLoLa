/* v_addresses - simple complete address view */
create or replace algorithm = merge view v_addresses as
select
  id address_id,
  contactId contact_id,
  `type` address_type,
  nullif(trim(typeLabel), '') type_label,
  nullif(trim(attention), '') attention,
  trim(addressLine1) address_line_1,
  nullif(trim(addressLine2), '') address_line_2,
  addressCity address_city,
  addressState address_state,
  addressZip address_zip,
  nullif(trim(addressCounty), '') address_county,
  addressCountry address_country,
  concat('(', nullif(latitude, 0.00000), ', ', longitude, ')') address_location,
  dateUpdated date_updated,
  effectiveStartDate effective_start_date,
  effectiveEndDate effective_end_date
from addresses
;
