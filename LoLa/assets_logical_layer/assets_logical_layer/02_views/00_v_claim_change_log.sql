/* v_claim_change_log [claim_change_log] */
create or replace algorithm = merge view v_claim_change_log as
select
  id claim_change_log_id,
  claimId claim_id,
  claimNumber claim_number,
  `transaction` change_type,
  claimItemId claim_item_id,
  claimStatus claim_status,
  dateStamp change_date_time,
  changedFrom changed_from,
  changedTo changed_to,
  deleted,
  dateUpdated date_updated
from claim_change_log;
