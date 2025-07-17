/* v_commission_payments */
create or replace algorithm = merge view v_commission_payments as
select
  id commission_payment_id,
  payeeId payee_contact_id,
  payAmount payment_amount,
  transactionDate transaction_date,
  dateAdded date_added,
  dateReviewed date_reviewed,
  dateExported date_exported,
  dateUpdated date_updated,
  reviewed,
  exported,
  isElectronicPayment is_electronic,
  nullif(trim(paymentMethodId), '') payment_method_id,
  isNetCommission is_net_commission
from commission_payments;
