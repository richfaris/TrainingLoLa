/* v_commission_details */
create or replace algorithm = merge view v_commission_details as
select
  id commission_detail_id,
  revisionId revision_id,
  agencyId agency_id,
  commPayId commission_payment_id,
  commissionableAmount applicable_premium,
  amountToBePaid commission_amount,
  commissionRate commission_rate,
  `delayed` delay_reason,
  why calculation_type,
  manualEntry manual_flag,
  insertedBy added_by,
  transactionDateTime date_calculated,
  exportDate date_exported,
  dateAdded + interval dateAddedMicro microsecond date_added,
  dateUpdated date_updated,
  itemId item_id
from commission_accounting;
