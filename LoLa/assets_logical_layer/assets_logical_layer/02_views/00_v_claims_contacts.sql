/* v_claims_contacts */
create or replace algorithm = merge view v_claims_contacts as
select
  id claim_contact_id,
  claimId claim_id,
  contactId contact_id,
  case
    when namedInsured then 'named_insured'
    when producer then 'agency'
    when adjuster then 'adjuster'
    when externalAdjuster then 'external_adjuster'
    when claimant then 'claimant'
    when contractor then 'contactor'
    when supervisor then 'supervisor'
    when defendantAttorney then 'defendant_attorney'
    when plaintiffAttorney then 'plaintiff_attorney'
    /* redundant publicAdjuster flag not used by ANY carrier yet */
    when publicClaimsAdjuster then 'public_claims_adjuster'
    when policeDepartment then 'police_department'
    when fireDepartment then 'fire_department'
    when medicalProvider then 'medical_provider'
    when driver then 'driver'
    /* TODO: other auto roles have been moved to quick_codes.quickCode = 'CLAIM_CONTACT_ROLES'
       quick_code_values + x_claims_contacts_quickcode_values */
    else '!unmapped!'
  end relationship,
  contractorDescription contractor_description,
  dateAdded date_added,
  dateUpdated date_updated
from x_claims_contacts
where contactId is not null
;
