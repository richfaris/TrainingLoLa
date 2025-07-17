/* v_properties_contacts */
create or replace algorithm = merge view v_properties_contacts as
select
  id property_contact_id,
  propertyId property_id,
  contactId contact_id,
  case
    when mortgagee then 'mortgagee'
    when inspector then 'inspector'
    when driver then 'driver'
    when tenant then 'tenant'
    else '!unmapped!' end relationship,
    description loan_description,
    loanNum loan_number,
    type mortgage_type,
    decMortStatement dec_mortgage_statement,
    dateAdded date_added,
    dateUpdated date_updated
from x_properties_contacts
where contactId is not null;
