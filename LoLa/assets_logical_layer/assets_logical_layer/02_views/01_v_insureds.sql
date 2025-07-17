/* v_insureds  */
create or replace algorithm = merge view v_insureds as
select
  contact_id insured_id,
  contact_name insured_name,
  contact_type,
  primary_email,
  primary_phone,
  cell_phone,
  home_phone,
  address_line_1,
  address_line_2,
  address_city,
  address_county,
  address_country,
  address_state,
  address_zip,
  full_address,
  gender,
  doing_business_as,
  legal_entity_type,
  date_business_started,
  terms_conditions_accepted,
  edelivery_enabled,
  portal_code,
  system_tags,
  date_added,
  date_updated
from v_contacts i
where not deleted
      and exists (select 1 from x_revisions_contacts where contactId = i.contact_id and namedInsured)
;
