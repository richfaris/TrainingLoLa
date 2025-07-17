/* v_claims [claims, catastrophes, claim_change_log] */
create or replace algorithm = merge view v_claims as
select
  c.id claim_id,
  c.claimNumber claim_number,
  c.active claim_active_flag,
  c.status claim_status,
  c.type claim_type,
  (select group_concat(distinct pe.name order by pe.name asc separator ', ')
   from x_claims_perils xcp join perils pe on pe.id = xcp.perilId
   where xcp.claimId = c.id) loss_cause,
  p.policyNumber policy_number,
  r.id revision_id,
  r.policyTypeId policy_type_id,
  c.lossDate loss_date,
  c.dateAdded date_added,
  coalesce((select min(date) from claim_dates where claimId = c.id and type = 'reported'),
            cast(c.dateAdded as date)) date_reported,
  c.lastModified last_modified,
  c.lastReinReportDate last_reinsurance_report_date,
  c.description,
  c.isoTransactionType iso_business_or_individual,
  c.lossAddressId property_id,
  case when la.id is null
    then concat_ws(', ', c.lossAddressLine1, nullif(c.lossAddressLine2, ''), c.lossAddressCity, concat(c.lossAddressState, ' ', c.lossAddressZip))
    else concat_ws(', ', la.addressLine1, nullif(la.addressLine2, ''), la.addressCity, concat(la.addressState, ' ', la.addressZip))
  end loss_location_address,
  case when la.id is null
    then c.lossAddressLine1
    else la.addressLine1
  end loss_location_address_1,
  case when la.id is null
    then coalesce(c.lossAddressLine2, '')
    else coalesce(la.addressLine2, '')
  end loss_location_address_2,
  case when la.id is null
    then c.lossAddressCity
    else la.addressCity
  end loss_location_address_city,
  case when la.id is null
    then c.lossAddressZip
    else la.addressZip
  end loss_location_address_zip,
  case when la.id is null
    then c.county
    else la.addressCounty
  end loss_location_address_county_id,
  case when la.id is null
    then c.lossAddressState
    else la.addressState
  end loss_location_address_state,
  case when la.id is not null and coalesce(la.latitude, 0) <> 0
       then concat_ws(', ', la.latitude, la.longitude)
       else concat_ws(', ', c.lossAddressLatitude, c.lossAddressLongitude) end loss_location_lat_lng,
  bc_label_tags(c.systemTags) claim_system_tags,
  c.catId catastrophe_id,
  coalesce(cat.title, '') cat_code,
  coalesce(cat.pcs, '') cat_pcs,
  coalesce(cat.location, '') cat_location
from claims c
join policies p on p.id = c.policyId
join revisions r on r.id = coalesce(c.revisionId,
        case when c.lossAddressId is not null then (select revisionId from properties where id = c.lossAddressId) end,
        (select p.revisionId from properties p join property_items pi on pi.propertyId = p.id join claim_items ci on ci.itemId = pi.id
         where ci.claimId = c.id limit 1),
        (select ri.revisionId from revision_items ri join claim_items ci on ci.itemId = ri.id
         where ci.claimId = c.id limit 1)
    )
left join catastrophes cat on cat.id = c.catId
left join properties la on la.id = c.lossAddressId
;
