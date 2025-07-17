/* v_claim_items [claim_items] */
create or replace algorithm = merge view v_claim_items as
select
  ci.id claim_item_id,
  ci.claimId claim_id,
  ci.itemId policy_item_id,
  coalesce(pti1.id, pti2.id) policy_type_item_id,
  coalesce(pti1.name, pti2.name) policy_item_name,
  CASE WHEN coalesce(s1.name, s2.name, '') <> ''
        THEN concat_ws(' - ', coalesce(s1.name, s2.name), coalesce(pti1.name, pti2.name))
        ELSE coalesce(pti1.name, pti2.name)
  END claim_item_name,
  ci.coverageDeductible coverage_deductible,
  ci.override,
  ci.lossReserve loss_reserve,
  ci.adjustingReserve adjusting_reserve,
  ci.legalReserve legal_reserve,
  ci.itemSubrogationReserve subrogation_reserve,
  ci.itemSalvageReserve salvage_reserve,
  ci.itemReinsuranceReserve reinsurance_reserve,
  ci.`description` item_description,
  ci.lossType loss_type,
  ci.lossId loss_id,
  ci.deleted,
  ci.dateUpdated date_updated
from claim_items ci
left join property_items i1 on ci.itemId = i1.id
left join policy_type_items pti1 on pti1.id =i1.itemId
left join sub_lines s1 on s1.id = pti1.subLineId
left join revision_items i2 on ci.itemId = i2.id and i1.id is null
left join policy_type_items pti2 on pti2.id =i2.itemId and i1.id is null
left join sub_lines s2 on s2.id = pti2.subLineId and i1.id is null
;
