/* v_claim_payments [claim_transactions, claims, policies] */
create or replace algorithm = merge view v_claim_payments as
select
  t.id claim_payment_id,
  t.claimId claim_id,
  c.claimNumber claim_number,
  c.lossDate loss_date,
  case v.voided when 0 then 'payment' else 'void' end payment_action,
  case when v.voided then t.voidedDate else t.transactionDate end date_entered,
  case when v.voided then t.voidedDate else t.dateExported end date_exported,
  t.clearedDate date_cleared,
  t.voidedDate date_voided,
  p.id policy_id,
  p.policyNumber policy_number,
  t.checkNumber check_number,
  t.paymentMethodId source_payment_method_id,
  t.contactId entered_by_id,
  (1 - v.voided * 2) * t.amount payment_amount,
  t.addressId mailing_address_id,
  t.checkDisplay pay_to,
  t.memo check_memo,
  t.deductible deductible_applied,
  bc_label_tags(t.systemTags) payment_system_tags,
  pc.name payment_classification,
  json_unquote(json_extract(bc_json_return_max(t.itemAmounts, 'lossPaid,legalPaid,adjustingPaid'), '$.lineItemName')) coverage_name,
  (1 - v.voided * 2) * bc_json_sum(t.itemAmounts, 'lossPaid') loss_paid,
  (1 - v.voided * 2) * bc_json_sum(t.itemAmounts, 'legalPaid') legal_paid,
  (1 - v.voided * 2) * bc_json_sum(t.itemAmounts, 'adjustingPaid') adjusting_paid
from claim_transactions t
join (select 0 voided union all select 1) v on v.voided <= t.voided
join claims c on c.id = t.claimId
join policies p on p.id = c.policyId
left join claims_payment_classification pc on pc.id = (select classificationId from x_claims_payment_classifications where claimTransactionId = t.id limit 1)
where t.type = 'payment'
;
