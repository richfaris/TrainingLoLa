/* v_account_history */
create or replace algorithm = merge view v_account_history as
select
  id account_history_id,
  revisionId revision_id,
  policyTermId policy_term_id,
  transactionDateTime transaction_date_time,
  transactionType transaction_type,
  `description`,
  dueDate due_date,
  cancelDate cancel_date,
  backCancelDate back_cancel_date,
  dayZeroDate day_zero_date,
  paymentAmount payment_amount,
  debitPremiumProRata debit_premium_pro_rata,
  debitPremiumFullyEarned debit_premium_fully_earned,
  debitPremiumFullyBilled debit_premium_fully_billed,
  debitCustomFeeProRata debit_custom_fee_pro_rata,
  debitCustomFeeFullyEarned debit_custom_fee_fully_earned,
  debitCustomFeeFullyBilled debit_custom_fee_fully_billed,
  debitSystemFee debit_system_fee,
  paidInFull paid_in_full,
  accountBalance account_balance,
  generatedBy generated_by,
  dirty user_modified,
  `snapshot` row_snapshot,
  dateAdded + interval dateAddedMicro microsecond date_added,
  dateUpdated date_updated,
  deleted,
  dateDeleted date_deleted,
  voided,
  dateVoided date_voided,
  fileId file_id,
  paymentId payment_id,
  waiveId waive_id,
  creditTransferId credit_transfer_id,
  debitTransferId debit_transfer_id,
  cancellationRevisionId cancellation_revision_id
from account_history;
