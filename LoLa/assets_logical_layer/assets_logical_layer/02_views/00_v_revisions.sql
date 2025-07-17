/* v_revisions [policies, policy_terms, revisions] */
create or replace algorithm = merge view v_revisions as
select
  r.id revision_id,
  e.id policy_term_id,
  p.id policy_id,
  r.policyTypeId policy_type_id,
  p.policyNumber policy_number,
  p.active policy_active_flag,
  p.rewritten rewritten,
  r.revisionState revision_state,
  r.revisionDate revision_date,
  r.commitDateTime commit_date_time,
  r.commitDate commit_date,
  r.createDate create_date,
  r.dateArchived date_archived,
  r.deleted revision_deleted,
  r.dateUpdated date_updated,
  e.effectiveDate term_effective_date,
  e.expirationDate term_expiration_date,
  e.termLength term_length_days,
  e.termType term_length,
  s.name billing_schedule,
  case coalesce(trim(e.autoPaymentMethodId), '') when '' then 0 else 1 end autopay_flag,
  e.firstPaymentMethodId initial_payment_method_id,
  e.firstBillWhomId initial_billing_contact_id,
  e.firstAddressUsedId initial_billing_address_id,
  e.autoPaymentMethodId recurring_payment_method_id,
  e.billWhomId recurring_billing_contact_id,
  e.addressUsedId recurring_billing_address_id,
  p.inceptionDate inception_date,
  r.policyStatus policy_status,
  case when r.policyStatus like '%Non-Payment%' then 'Non-Payment of Premium'
       when r.policyStatusReasonId is not null then
            case when r.policyStatus like 'Cancel%' then (select reason from cancellation_reasons where id = r.policyStatusReasonId LIMIT 1)
                 when e.renewalStatus like 'Non-Renewal' then (select reason from nonrenewal_reasons where id = r.policyStatusReasonId LIMIT 1)
            end
  end policy_status_reason,
  case when r.policyStatusReasonId is not null then
            case when r.policyStatus like 'Cancel%' then (select category from cancellation_reasons where id = r.policyStatusReasonId LIMIT 1)
            end
  end cancellation_category,
  r.cancelDate cancel_date,
  r.reinstateAtCommit reinstated_at_commit,
  e.renewalStatus renewal_status,
  e.isRenewal process_as_renewal,
  r.printDec declaration_prints,
  p.showApp quote_complete,
  p.submitBound submitted_bound,
  bc_label_tags(p.systemTags) policy_system_tags,
  r.decDescription print_description,
  r.description additional_description,
  r.commissionRate commission_rate,
  r.overrideCommission manual_commission_flag,
  r.writtenPremium written_premium,
  r.writtenFee written_fees,
  r.annualPremium annual_premium,
  r.annualFee annual_fees,
  coalesce(r.termFactor, 1.0000) term_factor,
  round(coalesce(r.termFactor, 1.0000) * r.annualPremium, 2) term_premium,
  round(coalesce(r.termFactor, 1.0000) * r.annualFee, 2) term_fees,
  p.copiedFromRevId copied_from_revision_id,
  case when p.copiedFromRevId is not null then (select c.policyNumber from policies c join revisions cr on cr.policyId = c.id where cr.id = p.copiedFromRevId) end copied_from_policy_number,
  p.copiedToRevId copied_to_revision_id,
  case when p.copiedToRevId is not null then (select c.policyNumber from policies c join revisions cr on cr.policyId = c.id where cr.id = p.copiedToRevId) end copied_to_policy_number
from revisions r
join policy_terms e on e.id = r.policyTermId
join policies p on p.id = r.policyId
left join billing_schedules s on s.id = coalesce(r.billingScheduleId, e.billSchedId)
;
