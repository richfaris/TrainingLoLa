/* v_return_premium [return_premium, policies] */
create or replace algorithm = merge view v_return_premium as
select
  r.id return_premium_id,
  r.accountHistoryId account_history_id,
  r.addressId address_id,
  r.policyId policy_id,
  n.policyNumber policy_number,
  r.check_number,
  r.amount return_amount,
  r.date date_created,
  r.dateAuthorized date_authorized,
  r.dateExported date_exported,
  r.clearedDate date_cleared,
  r.dateUpdated date_updated,
  r.reason,
  r.authorized,
  r.exported,
  r.canceled,
  r.toExport to_export,
  r.rejected,
  r.voided,
  r.transferred,
  r.accountHistoryTransferId transfer_account_history_id,
  r.paymentId payment_id,
  r.checkDivert check_divert,
  r.productDescription product_description
from return_premium r
join policies n on n.id = r.policyId
;
