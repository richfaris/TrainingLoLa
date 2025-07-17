/* v_contact_relationships - x_contacts */
create or replace algorithm = merge view v_contact_relationships as
select
  id contact_relationship_id,
  contactId subject_contact_id,
  refContactId related_contact_id,
  case
    when agencyGroupMember then 'agency_group_member'
    when agencyMember then 'agency_member'
    when agencyAdministrator then 'agency_administrator'
    when defaultSurplusLinesProducer then 'default_surplus_lines_producer'
    when associatedSurplusLinesProducer then 'associated_surplus_lines_producer'
    when relatedTo then 'relative'
    else 'works_for' end relationship
from x_contacts
where contactId is not null and refContactId is not null;
