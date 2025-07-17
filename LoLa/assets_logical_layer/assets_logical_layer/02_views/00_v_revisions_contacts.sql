/* v_revisions_contacts */
create or replace algorithm = merge view v_revisions_contacts as
select
  id revision_contact_id,
  revisionId revision_id,
  contactId contact_id,
  case
    when namedInsured then 'named_insured'
    when agent then 'agency'
    when creator then 'creator'
    when underwriter then 'underwriter'
    when addtlInterest then 'additional_interest'
    when driver then 'driver'
    when financeCompany then 'finance_company'
    else '!unmapped!' end relationship,
    interest additional_interest,
    /* there are 20+ additional auto-relationship values that can be added when needed */
    dateAdded date_added,
    dateUpdated date_updated
from x_revisions_contacts
where contactId is not null;
