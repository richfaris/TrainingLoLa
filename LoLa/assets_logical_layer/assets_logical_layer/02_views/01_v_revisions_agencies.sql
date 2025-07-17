/* v_revisions_agencies [v_contacts, contacts,x_contacts, x_contacts_roles, x_revisions_contacts, x_policy_contacts] */
create or replace algorithm = merge view v_revisions_agencies as
with
  ar as (select case value when 'agency' then 'Agency' else 'Agent' end role_level
         from settings where `option` = 'policy-go-to')
select
  r.id revision_id,
  a.contact_id agency_id,
  case ar.role_level when 'Agent' then a.contact_name
       else coalesce(oa.name, a.contact_name)
  end agent_name,
  case ar.role_level when 'Agent' then a.producer_number else oa.producerNumber end producer_number,
  case ar.role_level when 'Agent' then a.contact_id else oa.id end agent_id,
  case ar.role_level when 'Agency' then a.contact_name
       else coalesce(oa.name, a.contact_name)
  end agency_name,
  case ar.role_level when 'Agent' then oa.agencyNumber else a.agency_number end agency_number,
  case ar.role_level when 'Agent' then oa.id else a.contact_id end true_agency_id,
  coalesce(ag.name, '') agency_group_name,
  coalesce(ag.agencyGroupNumber, '') agency_group_number,
  ag.id agency_group_id,
  a.contact_type,
  a.primary_email,
  a.primary_phone,
  a.work_phone,
  a.cell_phone,
  a.address_line_1,
  a.address_line_2,
  a.address_city,
  a.address_state,
  a.address_zip,
  a.address_county,
  a.address_country,
  a.edelivery_enabled,
  a.fein,
  a.position,
  a.website,
  a.contact_background,
  a.commission_structure,
  a.use_agency_group_commission_structure,
  a.pay_commission_to,
  ag.commissionStructure agency_group_commission_structure,
  case when a.use_agency_group_commission_structure then ag.commissionStructure
       else a.commission_structure
  end effective_commission_structure,
  case ar.role_level when 'Agent' then a.agent_terminated else oa.terminated end agent_terminated,
  case ar.role_level when 'Agent' then a.termination_reason else oa.terminationReason end termination_reason,
  case ar.role_level when 'Agency' then a.agency_inactive_at else oa.agencyInactiveTimestamp end agency_inactive_at,
  case ar.role_level when 'Agency' then a.agency_inception_date else oa.agencyInceptionDate end agency_inception_date,
  case ar.role_level when 'Agency' then a.agency_termination_date else oa.agencyTerminationDate end agency_termination_date,
  a.permission_level,
  a.last_login,
  a.system_tags,
  a.date_added,
  a.date_updated,
  a.date_address_updated,
  a.date_phone_updated,
  a.date_email_updated
from ar
join v_contacts a on true
join x_revisions_contacts rc on rc.contactId = a.contact_id and rc.agent
join revisions r on r.id = rc.revisionId
/* oa "other agentcy" will have either the agent or agency reference, opposite of ar.role_level */
left join contacts oa on oa.id = case ar.role_level
  /* find Agency */
  when 'Agent' then (select refContactId from x_contacts where contactId = a.contact_id and agencyMember limit 1)
  /* find Agent */
  when 'Agency' then coalesce((select contactId from x_policy_contacts where policyId = r.policyId and agencyContact and contactId is not null
                   and contactId in (select contactId from x_contacts where agencyMember
                                     and refContactId = a.contact_id and refContactId is not null) limit 1),
                  (select contactId from x_revisions_contacts where revisionId = r.id and creator and contactId is not null
                   and contactId in (select contactId from x_contacts where agencyMember
                                     and refContactId = a.contact_id and refContactId is not null) limit 1))
  end
left join contacts ag on ag.id = (select refContactId from x_contacts
  where contactId = case ar.role_level when 'Agency' then a.contact_id else oa.id end
  and agencyGroupMember and refContactId is not null limit 1)
;
