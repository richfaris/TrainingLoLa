/* v_properties [properties, business_locations (county)] */
create or replace algorithm = merge view v_properties as
select
  p.id property_id,
  p.revisionId revision_id,
  p.name property_name,
  locationNumber location_number,
  g.groupNumber property_group_number,
  addressLine1 address_line_1,
  addressLine2 address_line_2,
  addressCity address_city,
  addressState address_state,
  addressZip address_zip,
  addressCountry address_country,
  concat_ws(', ', trim(addressLine1), nullif(trim(addressLine2), ''), addressCity, concat(addressState, ' ', addressZip)) full_address,
  nullif(substring_index(substring_index(substring_index(
         s.counties, concat('"id": "', p.addressCounty, '"'), 1), '"name": "', -1), '"', 1), '[{') address_county,
  p.writtenPremium written_premium,
  p.writtenFee written_fee,
  p.annualPremium annual_premium,
  p.annualFee annual_fee,
  latitude,
  longitude,
  addressAccuracy address_accuracy,
  p.dateAdded + interval p.dateAddedMicro microsecond date_added,
  p.dateUpdated date_updated,
  copyAddress address_copied_from_insured,
  p.deleted,
  fireDistrictDistance fire_district_distance,
  hydrantDistance hydrant_distance,
  case when isoPcData is not null and isoPcData like '%<FireDistrName>%'
       then trim(substring_index(substring_index(isoPcData, '<FireDistrName>', -1), '</FireDistrName>', 1))
       else c.fireDistrict
  end fire_district,
  case when isoPcData is not null and isoPcData like '%<PPCVal>%'
       then trim(substring_index(substring_index(isoPcData, '<PPCVal>', -1), '</PPCVal>', 1))
       else c.pc1
  end protection_class,
  grossArea gross_area,
  stories,
  yearBuilt year_built,
  replacementCostValue replacement_cost,
  propertyVal actual_cash_value,
  p.nextInspectionDate next_inspection_date,
  p.inspectionRequestedDate inspection_requested_date,
  v.title inspection_vendor
from properties p
left join property_groups g on g.id = p.propertyGroupId and g.revisionId = p.revisionId
left join protection_classes c on c.id = p.protectionClassId
join revisions r on r.id = p.revisionId
join policy_types t on t.id = r.policyTypeId
join business_locations s on s.id = t.locationId
left join vendors v on v.id = p.inspectionVendor
where p.type in ('Property', '');
