/* v_contacts base view */
create or replace algorithm = merge view v_contacts as
with docs as (select
  'Base view for all Contacts in BriteCore' view_doc,
  'contact' view_grain,
  'Primary key for the contact' contact_id,
  'Indicator whether the contact has been soft "deleted"' deleted,
  'The full name of the contact' contact_name,
  'The type of the contact ("individual" or "organization")' contact_type
)
select c.id contact_id,
  1 - c.active deleted,
  trim(c.name) contact_name,
  c.type contact_type,
  trim(pe.email) primary_email,
  trim(pp.phone) primary_phone,
  trim((select phone from phones where contactId = c.id and type = 'Cell' limit 1)) cell_phone,
  trim((select phone from phones where contactId = c.id and type = 'Home' limit 1)) home_phone,
  trim((select phone from phones where contactId = c.id and type = 'Work' limit 1)) work_phone,
  nullif(trim(pa.attention), '') attention,
  trim(pa.addressLine1) address_line_1,
  nullif(trim(pa.addressLine2), '') address_line_2,
  trim(pa.addressCity) address_city,
  pa.addressState address_state,
  trim(pa.addressZip) address_zip,
  nullif(trim(pa.addressCounty), '') address_county,
  trim(pa.addressCountry) address_country,
  concat_ws(', ', nullif(trim(pa.attention), ''),
            trim(pa.addressLine1), nullif(trim(pa.addressLine2), ''),
            trim(pa.addressCity), concat(pa.addressState, ' ', pa.addressZip)) full_address,
  nullif(trim(c.gender), '') gender,
  nullif(trim(c.dba), '') doing_business_as,
  nullif(trim(c.legalEntityType), '') legal_entity_type,
  nullif(c.dateBusinessStarted, '0000-00-00') date_business_started,
  c.termsConditionsAccepted terms_conditions_accepted,
  c.emailNotices edelivery_enabled,
  c.portalCode portal_code,
  nullif(trim(c.feinTax), '') fein,
  nullif(trim(c.position), '') `position`,
  nullif(trim(c.website), '') website,
  nullif(trim(c.background), '') contact_background,
  c.commissionStructure commission_structure,
  c.useAgencyGroupCommissionStructure use_agency_group_commission_structure,
  c.payCommissionTo pay_commission_to,
  nullif(trim(c.agencyGroupNumber), '') agency_group_number,
  nullif(trim(c.agencyNumber), '') agency_number,
  nullif(trim(c.producerNumber), '') producer_number,
  nullif(trim(c.vendorNumber), '') vendor_number,
  nullif(trim(c.mortgageeStatement), '') mortgagee_statement,
  c.terminated agent_terminated,
  nullif(trim(c.terminationReason), '') termination_reason,
  c.agencyInactiveTimestamp agency_inactive_at,
  c.agencyInceptionDate agency_inception_date,
  c.agencyTerminationDate agency_termination_date,
  pl.name permission_level,
  c.lastLogin last_login,
  c.cognitoUsername briteauth_username,
  c.username legacy_username,
  c.confirmationEmail user_email,
  c.isGod superuser_flag,
  c.timezone,
  s.name default_state,
  (select group_concat(distinct r.name order by r.name asc separator ', ') from roles r join x_contacts_roles x on x.roleId = r.id where x.contactId = c.id) roles,
  bc_label_tags(c.systemTags) system_tags,
  c.dateAdded date_added,
  c.dateUpdated date_updated,
  pa.dateUpdated date_address_updated,
  pp.dateUpdated date_phone_updated,
  pe.dateUpdated date_email_updated
from docs
join contacts c on true
left join addresses pa on pa.id = (select id from addresses where contactId = c.id order by
                                   case when type like 'Mailing/Billing%' then 1
                                        when type like 'Billing%' then 2
                                        when type like 'Mailing%' then 3
                                        when type like 'Other%' then 4 else 5 end limit 1)
left join emails pe on pe.id = (select id from emails where contactId = c.id order by
                                case when coalesce(c.noticeEmailId, '') = id then 1
                                     when type = 'Home' then 2
                                     when type = 'Work' then 3
                                     when type = 'Other' then 4 else 5 end limit 1)
left join phones pp on pp.id = (select id from phones where contactId = c.id order by
                                case type when 'Cell' then 1 when 'Home' then 2 when 'Work' then 3 when 'Other' then 4 when 'Fax' then 6 else 5 end limit 1)
left join permission_levels pl on pl.id = c.permissionLevelId
left join business_locations s on s.id = c.defaultStateId
;
