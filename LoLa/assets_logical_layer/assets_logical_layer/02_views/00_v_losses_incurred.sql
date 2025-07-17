/* v_losses_incurred [losses_incurred, losses_incurred_items, claim_items] */
create or replace algorithm = merge view v_losses_incurred as
select
  li.id loss_incurred_id,
  lii.id loss_incurred_item_id,
  li.claimId claim_id,
  lii.claimItemId claim_item_id,
  li.claimTransactionId claim_payment_id,
  lii.claimItemName policy_item_name,
  ci.itemId policy_item_id,
  li.dateCreated date_incurred,
  li.dateCreated + interval li.dateCreatedMicro microsecond date_incurred_micro,
  li.modifiedBy modified_by,
  lii.changeInLossReserve loss_reserved,
  lii.lossPaid loss_paid,
  lii.changeInAdjustingReserve adjusting_reserved,
  lii.adjustingPaid adjusting_paid,
  lii.changeInLegalReserve legal_reserved,
  lii.legalPaid legal_paid,
  li.historical,
  li.dateUpdated date_updated
from losses_incurred li
join losses_incurred_items lii on lii.lossesIncurredId = li.id
join claim_items ci on ci.id = lii.claimItemId
;
