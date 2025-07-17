/* v_recoveries [recovery_history] */
create or replace algorithm = merge view v_recoveries as
select
  id recovery_id,
  claimId claim_id,
  /* Note Dec 2024, claimItemId for recoveries is on auto claims only at the time */
  claimItemId claim_item_id,
  claimTransactionId claim_recovery_id,
  dateCreated date_incurred,
  modifiedBy modified_by,
  cast(json_extract(snapshot, '$.subrogationChange') as decimal(14,2)) subrogation_reserved,
  cast(json_extract(snapshot, '$.subrogationReceived') as decimal(14,2)) subrogation_received,
  cast(json_extract(snapshot, '$.salvageChange') as decimal(14,2)) salvage_reserved,
  cast(json_extract(snapshot, '$.salvageReceived') as decimal(14,2)) salvage_received,
  cast(json_extract(snapshot, '$.reinsuranceChange') as decimal(14,2)) reinsurance_reserved,
  cast(json_extract(snapshot, '$.reinsuranceReceived') as decimal(14,2)) reinsurance_received,
  cast(json_extract(snapshot, '$.reinsurancelaeChange') as decimal(14,2)) reinsurance_expense_reserved,
  cast(json_extract(snapshot, '$.reinsurancelaeReceived') as decimal(14,2)) reinsurance_expense_received,
  historical,
  dateUpdated date_updated
from recovery_history;
