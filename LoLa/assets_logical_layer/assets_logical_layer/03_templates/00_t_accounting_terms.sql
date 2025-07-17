/* t_accounting_terms */
create or replace view t_accounting_terms as
select
  coalesce(r.policyTermId, fr.policyTermId) policy_term_id,
  coalesce(r.id, fr.id) revision_id,
  pr.id prior_revision_id,
  t.id policy_type_id,
  ni.contactId primary_insured_id,
  a.contactId agency_id,
  sum(b.due) ending_due,
  sum(b.paid - b.priorPaid) paid,
  sum(b.payments - b.priorPayments) payments,
  sum(b.transfers - b.priorTransfers) transfers,
  greatest(0, least(sum(b.paid), sum(b.customFeeBilled)))
  - greatest(0, least(sum(b.priorPaid), sum(b.priorCustomFeeBilled))) paid_custom_fee,
  greatest(0, least(sum(b.paid - b.customFeeBilled), sum(b.systemFeeBilled)))
  - greatest(0, least(sum(b.priorPaid - b.priorCustomFeeBilled),
                    sum(b.priorSystemFeeBilled))) paid_system_fee,
  greatest(0, least(sum(b.paid - b.customFeeBilled - b.systemFeeBilled), sum(b.premiumTerm)))
  - greatest(0, least(sum(b.priorPaid - b.priorCustomFeeBilled - b.priorSystemFeeBilled),
                    sum(b.priorPremiumTerm))) paid_premium,
  sum(b.returnPremium - b.priorReturnPremium) return_premium,
  sum(b.returnPremiumExported - b.priorReturnPremiumExported) return_premium_exported,
  sum(b.returnPremium - b.priorReturnPremium
      - (b.returnPremiumExported - b.priorReturnPremiumExported)) return_premium_pending,
  sum(b.adjustment - b.priorAdjustment) adjustment,
  sum(b.advancePremium - b.priorAdvancePremium) advance_premium,
  sum(b.premiumBilled - b.priorPremiumBilled) premium_billed,
  sum(b.premiumWriteOff - b.priorPremiumWriteOff) premium_write_off,
  sum(b.customFeeBilled - b.priorCustomFeeBilled) custom_fee_billed,
  sum(b.customFeeWriteOff - b.priorCustomFeeWriteOff) custom_fee_write_off,
  sum(b.systemFeeBilled - b.priorSystemFeeBilled) system_fee_billed,
  sum(b.systemFeeWaive - b.priorSystemFeeWaive) system_fee_waive,
  sum(b.installmentFeeBilled - b.priorInstallmentFeeBilled) installment_fee_billed,
  sum(b.nonPayFeeBilled - b.priorNonPayFeeBilled) non_pay_fee_billed,
  sum(b.reinstatementFeeBilled - b.priorReinstatementFeeBilled) reinstatement_fee_billed,
  sum(b.nsfFeeBilled - b.priorNsfFeeBilled) nsf_fee_billed,
  sum(b.convenienceFee - b.priorConvenienceFee) convenience_fee,
  sum(b.balance) term_balance,
  sum(b.paid) term_paid,
  sum(b.payments) term_payments,
  sum(b.transfers) term_transfers,
  sum(b.returnPremium) term_return_premium,
  sum(b.returnPremiumExported) term_return_premium_exported,
  sum(b.returnPremium) - sum(b.returnPremiumExported) term_return_premium_pending,
  sum(b.adjustment) term_adjustment,
  greatest(0, least(sum(b.paid), sum(b.customFeeBilled))) term_paid_custom_fee,
  greatest(0, least(sum(b.paid - b.customFeeBilled), sum(b.systemFeeBilled))) term_paid_system_fee,
  greatest(0, least(sum(b.paid - b.customFeeBilled - b.systemFeeBilled), sum(b.premiumTerm))) term_paid_premium,
  /* AR Aging */
  greatest(0, least(sum(case b.ageGroup when 0 then b.due else 0 end), sum(case when b.ageGroup > -1 then b.due else 0 end))) ar_current,
  greatest(0, least(sum(case b.ageGroup when 1 then b.due else 0 end), sum(case when b.ageGroup > 0 then b.due else 0 end))) ar_0_29,
  greatest(0, least(sum(case b.ageGroup when 2 then b.due else 0 end), sum(case when b.ageGroup > 1 then b.due else 0 end))) ar_30_59,
  greatest(0, least(sum(case b.ageGroup when 3 then b.due else 0 end), sum(case when b.ageGroup > 2 then b.due else 0 end))) ar_60_89,
  greatest(0, least(sum(case b.ageGroup when 4 then b.due else 0 end), sum(case when b.ageGroup > 3 then b.due else 0 end))) ar_90_plus,
  /* end AR aging */
  sum(b.due) premium_in_collection,
  sum(b.premiumTerm - b.premiumBilled) deferred_premium,
  sum(b.customFeeTerm - b.customFeeBilled) deferred_custom_fee,
  sum(b.systemFeeTerm - b.systemFeeBilled) deferred_system_fee,
  sum(b.advancePremium) term_advance_premium,
  sum(b.premiumBilled) term_premium_billed,
  sum(b.premiumWriteOff) term_premium_write_off,
  sum(b.customFeeBilled) term_custom_fee_billed,
  sum(b.customFeeWriteOff) term_custom_fee_write_off,
  sum(b.systemFeeBilled) term_system_fee_billed,
  sum(b.systemFeeWaive) term_system_fee_waive,
  sum(b.premiumTerm) term_premium,
  sum(b.customFeeTerm) term_custom_fee,
  sum(b.systemFeeTerm) term_system_fee,
  sum(b.convenienceFee) term_convenience_fee,
  coalesce(r.writtenPremium, 0) revision_written_premium,
  coalesce(r.writtenPremium, 0) - coalesce(pr.writtenPremium, 0) change_written_premium
from
    (

      /* 1) Get all terms due and balances as of report end date and changes over report range */
      select
        d.endTime,
        d.priorEndTime,
        a.policyTermId policy_term_id,

        /* AR Aging Logic */
        case when a.transactionType in ('Invoice', 'Non Pay', 'Reinstatement') and greatest(a.dateAdded, a.transactionDateTime) <= d.endTime
                  and coalesce(a.dateDeleted, '2300-01-01') > d.endTime
             then greatest(0, least(4, floor(datediff(d.endTime, coalesce(a.dueDate, a.transactionDateTime)) / 30) + 1))
        else 99 end ageGroup,

        max(case when a.dateAdded between d.priorEndTime and d.endTime
                  or a.transactionDateTime between d.priorEndTime and d.endTime
                  or coalesce(a.dateDeleted, '2300-01-01') between d.priorEndTime and d.endTime
                  or e.effectiveDate between d.priorEndTime and d.endTime
                  or greatest(r.commitDate, r.revisionDate) between d.priorEndTime and d.endTime
                then 1 else 0 end) hasTransaction,
        sum(case when greatest(a.dateAdded, a.transactionDateTime) <= d.endTime
                      and coalesce(a.dateDeleted, '2300-01-01') > d.endTime
                 then a.paymentAmount + a.debitPremiumProRata + a.debitPremiumFullyEarned
                    + a.debitCustomFeeProRata + a.debitCustomFeeFullyEarned + a.debitSystemFee
                 else 0 end) due,
        sum(case when greatest(a.dateAdded, a.transactionDateTime) <= d.priorEndTime
                      and coalesce(a.dateDeleted, '2300-01-01') > d.priorEndTime
                then a.paymentAmount + a.debitPremiumProRata + a.debitPremiumFullyEarned
                    + a.debitCustomFeeProRata + a.debitCustomFeeFullyEarned + a.debitSystemFee
                else 0 end) priorDue,
        sum(case when a.dateAdded <= d.endTime
                      and coalesce(a.dateDeleted, '2300-01-01') > d.endTime
                then a.paymentAmount + a.debitPremiumProRata + a.debitPremiumFullyEarned
                    + a.debitCustomFeeProRata + a.debitCustomFeeFullyEarned + a.debitSystemFee
                else 0 end) balance,
        sum(case when a.dateAdded <= d.priorEndTime
                      and coalesce(a.dateDeleted, '2300-01-01') > d.priorEndTime
                then a.paymentAmount + a.debitPremiumProRata + a.debitPremiumFullyEarned
                    + a.debitCustomFeeProRata + a.debitCustomFeeFullyEarned + a.debitSystemFee
                else 0 end) priorBalance,
        /* Credits don't care about transactionDateTime, ultimately */
        sum(case when a.dateAdded <= d.endTime
                      and coalesce(a.dateDeleted, '2300-01-01') > d.endTime
                then a.paymentAmount * -1
                else 0 end) paid,
        sum(case when a.dateAdded <= d.priorEndTime
                      and coalesce(a.dateDeleted, '2300-01-01') > d.priorEndTime
                then a.paymentAmount * -1
                else 0 end) priorPaid,
        /* "payments" are strictly Payment/NSF/Void while "paid" is any paymentAmount credit
           eg Return Premium Transfer, etc
        */
        sum(case when a.dateAdded <= d.endTime
                      and coalesce(a.dateDeleted, '2300-01-01') > d.endTime
                      and a.transactionType in ('Adjustment', 'NSF', 'Payment')
                then a.paymentAmount * -1
                else 0 end) payments,
        sum(case when a.dateAdded <= d.priorEndTime
                      and coalesce(a.dateDeleted, '2300-01-01') > d.priorEndTime
                      and a.transactionType in ('Adjustment', 'NSF', 'Payment')
                then a.paymentAmount * -1
                else 0 end) priorPayments,
        sum(case when a.dateAdded <= d.endTime
                      and coalesce(a.dateDeleted, '2300-01-01') > d.endTime
                      and a.transactionType not in ('Adjustment', 'NSF', 'Payment')
                then a.paymentAmount * -1
                else 0 end) transfers,
        sum(case when a.dateAdded <= d.priorEndTime
                      and coalesce(a.dateDeleted, '2300-01-01') > d.priorEndTime
                      and a.transactionType not in ('Adjustment', 'NSF', 'Payment')
                then a.paymentAmount * -1
                else 0 end) priorTransfers,
        sum(case when a.dateAdded <= d.endTime and e.effectiveDate > d.endTime
                      and coalesce(a.dateDeleted, '2300-01-01') > d.endTime
                then a.paymentAmount * -1
                else 0 end) advancePremium,
        sum(case when a.dateAdded <= d.priorEndTime and e.effectiveDate > d.priorEndTime
                      and coalesce(a.dateDeleted, '2300-01-01') > d.priorEndTime
                then a.paymentAmount * -1
                else 0 end) priorAdvancePremium,
        /* Debits do care about transactionDateTime */
        sum(case when greatest(a.dateAdded, a.transactionDateTime) <= d.endTime
                      and coalesce(a.dateDeleted, '2300-01-01') > d.endTime
                 then a.debitPremiumProRata + a.debitPremiumFullyEarned else 0 end) premiumBilled,
        sum(case when greatest(a.dateAdded, a.transactionDateTime) <= d.priorEndTime
                      and coalesce(a.dateDeleted, '2300-01-01') > d.priorEndTime
                 then a.debitPremiumProRata + a.debitPremiumFullyEarned else 0 end) priorPremiumBilled,
        sum(case when a.dateAdded <= d.endTime
                      and coalesce(a.dateDeleted, '2300-01-01') > d.endTime
                 then a.debitPremiumProRata + a.debitPremiumFullyEarned else 0 end) premiumTerm,
        sum(case when a.dateAdded <= d.priorEndTime
                      and coalesce(a.dateDeleted, '2300-01-01') > d.priorEndTime
                 then a.debitPremiumProRata + a.debitPremiumFullyEarned else 0 end) priorPremiumTerm,
        sum(case when a.dateAdded <= d.endTime and coalesce(a.dateDeleted, '2300-01-01') > d.endTime
                 then a.debitCustomFeeProRata + a.debitCustomFeeFullyEarned else 0 end) customFeeTerm,
        sum(case when a.dateAdded <= d.endTime and coalesce(a.dateDeleted, '2300-01-01') > d.endTime
                 then a.debitSystemFee else 0 end) systemFeeTerm,
        sum(case when a.transactionType in ('Return Premium', 'Return Premium Transfer')
                      and greatest(a.dateAdded, a.transactionDateTime) <= d.endTime
                      and coalesce(a.dateDeleted, '2300-01-01') > d.endTime
                 then a.paymentAmount else 0 end) returnPremium,
        sum(case when a.transactionType in ('Return Premium', 'Return Premium Transfer')
                      and greatest(a.dateAdded, a.transactionDateTime) <= d.priorEndTime
                      and coalesce(a.dateDeleted, '2300-01-01') > d.priorEndTime
                 then a.paymentAmount else 0 end) priorReturnPremium,
        sum(case when a.transactionType = 'Return Premium'
                      and coalesce(rp.dateExported, '2300-01-01') <= d.endTime
                      and coalesce(rpt.transactionDateTime, '2300-01-01') > d.endTime
                 then a.paymentAmount else 0 end) returnPremiumExported,
        sum(case when a.transactionType = 'Return Premium'
                      and coalesce(rp.dateExported, '2300-01-01') <= d.priorEndTime
                      and coalesce(rpt.transactionDateTime, '2300-01-01') > d.priorEndTime
                 then a.paymentAmount else 0 end) priorReturnPremiumExported,
        sum(case when a.transactionType = 'Waive' and greatest(a.dateAdded, a.transactionDateTime) <= d.endTime
                      and coalesce(a.dateDeleted, '2300-01-01') > d.endTime
                then a.debitPremiumProRata + a.debitPremiumFullyEarned else 0 end) premiumWriteOff,
        sum(case when a.transactionType = 'Waive' and  greatest(a.dateAdded, a.transactionDateTime) <= d.priorEndTime
                      and coalesce(a.dateDeleted, '2300-01-01') > d.priorEndTime
                then a.debitPremiumProRata + a.debitPremiumFullyEarned else 0 end) priorPremiumWriteOff,
        sum(case when a.transactionType = 'Waive' and greatest(a.dateAdded, a.transactionDateTime) <= d.endTime
                      and coalesce(a.dateDeleted, '2300-01-01') > d.endTime
                then a.debitCustomFeeProRata + a.debitCustomFeeFullyEarned else 0 end) customFeeWriteOff,
        sum(case when a.transactionType = 'Waive' and  greatest(a.dateAdded, a.transactionDateTime) <= d.priorEndTime
                      and coalesce(a.dateDeleted, '2300-01-01') > d.priorEndTime
                then a.debitCustomFeeProRata + a.debitCustomFeeFullyEarned else 0 end) priorCustomFeeWriteOff,
        sum(case when a.transactionType = 'Waive' and greatest(a.dateAdded, a.transactionDateTime) <= d.endTime
                      and coalesce(a.dateDeleted, '2300-01-01') > d.endTime
                then a.debitSystemFee else 0 end) systemFeeWaive,
        sum(case when a.transactionType = 'Waive' and  greatest(a.dateAdded, a.transactionDateTime) <= d.priorEndTime
                      and coalesce(a.dateDeleted, '2300-01-01') > d.priorEndTime
                then a.debitSystemFee else 0 end) priorSystemFeeWaive,
        sum(case when a.transactionType in ('Adjustment', 'NSF', 'Waive') and a.dateAdded <= d.endTime
                      and coalesce(a.dateDeleted, '2300-01-01') > d.endTime
                then a.debitPremiumProRata + a.debitPremiumFullyEarned + a.debitCustomFeeProRata
                      + a.debitCustomFeeFullyEarned + a.debitSystemFee else 0 end) adjustment,
        sum(case when a.transactionType in ('Adjustment', 'NSF', 'Waive') and a.dateAdded <= d.priorEndTime
                      and coalesce(a.dateDeleted, '2300-01-01') > d.priorEndTime
                then a.debitPremiumProRata + a.debitPremiumFullyEarned + a.debitCustomFeeProRata
                      + a.debitCustomFeeFullyEarned + a.debitSystemFee else 0 end) priorAdjustment,
        sum(case when greatest(a.dateAdded, a.transactionDateTime) <= d.endTime
                      and coalesce(a.dateDeleted, '2300-01-01') > d.endTime
                then a.debitCustomFeeProRata + a.debitCustomFeeFullyEarned
                else 0 end) customFeeBilled,
        sum(case when greatest(a.dateAdded, a.transactionDateTime) <= d.priorEndTime
                      and coalesce(a.dateDeleted, '2300-01-01') > d.priorEndTime
                then a.debitCustomFeeProRata + a.debitCustomFeeFullyEarned
                else 0 end) priorCustomFeeBilled,
        sum(case when greatest(a.dateAdded, a.transactionDateTime) <= d.endTime
                      and coalesce(a.dateDeleted, '2300-01-01') > d.endTime
                then a.debitSystemFee else 0 end) systemFeeBilled,
        sum(case when greatest(a.dateAdded, a.transactionDateTime) <= d.priorEndTime
                      and coalesce(a.dateDeleted, '2300-01-01') > d.priorEndTime
                then a.debitSystemFee else 0 end) priorSystemFeeBilled,
        /* Period System Fee Billed Breakouts - Installment(Invoice), Non Pay, Reinstatement, NSF */
        sum(case when greatest(a.dateAdded, a.transactionDateTime) <= d.endTime
                      and coalesce(a.dateDeleted, '2300-01-01') > d.endTime
                      and a.transactionType = 'Invoice'
                then a.debitSystemFee else 0 end) installmentFeeBilled,
        sum(case when greatest(a.dateAdded, a.transactionDateTime) <= d.priorEndTime
                      and coalesce(a.dateDeleted, '2300-01-01') > d.priorEndTime
                      and a.transactionType = 'Invoice'
                then a.debitSystemFee else 0 end) priorInstallmentFeeBilled,
        sum(case when greatest(a.dateAdded, a.transactionDateTime) <= d.endTime
                      and coalesce(a.dateDeleted, '2300-01-01') > d.endTime
                      and a.transactionType = 'Non Pay'
                then a.debitSystemFee else 0 end) nonPayFeeBilled,
        sum(case when greatest(a.dateAdded, a.transactionDateTime) <= d.priorEndTime
                      and coalesce(a.dateDeleted, '2300-01-01') > d.priorEndTime
                      and a.transactionType = 'Non Pay'
                then a.debitSystemFee else 0 end) priorNonPayFeeBilled,
        sum(case when greatest(a.dateAdded, a.transactionDateTime) <= d.endTime
                      and coalesce(a.dateDeleted, '2300-01-01') > d.endTime
                      and a.transactionType = 'Reinstatement'
                then a.debitSystemFee else 0 end) reinstatementFeeBilled,
        sum(case when greatest(a.dateAdded, a.transactionDateTime) <= d.priorEndTime
                      and coalesce(a.dateDeleted, '2300-01-01') > d.priorEndTime
                      and a.transactionType = 'Reinstatement'
                then a.debitSystemFee else 0 end) priorReinstatementFeeBilled,
        sum(case when greatest(a.dateAdded, a.transactionDateTime) <= d.endTime
                      and coalesce(a.dateDeleted, '2300-01-01') > d.endTime
                      and a.transactionType = 'NSF'
                then a.debitSystemFee else 0 end) nsfFeeBilled,
        sum(case when greatest(a.dateAdded, a.transactionDateTime) <= d.priorEndTime
                      and coalesce(a.dateDeleted, '2300-01-01') > d.priorEndTime
                      and a.transactionType = 'NSF'
                then a.debitSystemFee else 0 end) priorNsfFeeBilled,
        /* Payment processing fees, billed outside of BriteCore */
        sum(case when a.dateAdded <= d.endTime
                      and coalesce(a.dateDeleted, '2300-01-01') > d.endTime
                then coalesce(py.convenienceFee, 0) * if(a.transactionType = 'Adjustment', -1, 1)
                else 0 end) convenienceFee,
        sum(case when a.dateAdded <= d.priorEndTime
                      and coalesce(a.dateDeleted, '2300-01-01') > d.priorEndTime
                then coalesce(py.convenienceFee, 0) * if(a.transactionType = 'Adjustment', -1, 1)
                else 0 end) priorConvenienceFee
      from
        (select
              v.reportStartDate,
              v.reportEndDate,
              v.reportEndDate + interval 1 day - interval 1 microsecond endTime,
              v.reportStartDate - interval 1 microsecond priorEndTime
              from (
                select '<<$StartDate>>' as reportStartDate, '<<$EndDate>>' as reportEndDate
                ) v
            ) d /* <======= Report Range Here, Inclusive to end of day ====================== */
      join account_history a on a.dateAdded <= d.endTime
                                and coalesce(a.dateDeleted, '2300-01-01') > d.priorEndTime
      join policy_terms e on e.id = a.policyTermId
      join revisions r on r.id = a.revisionId
      left join return_premium rp on rp.accountHistoryId = a.id
      left join account_history rpt on rpt.id = rp.accountHistoryTransferId
      left join payments py on py.id = a.paymentId
      group by a.policyTermId, ageGroup
      having not (balance = 0 and hasTransaction = 0)
   /* End 1 Report-applicable Terms and Balances */
    ) b
  /* when commissions are based on paid premium, should we use those figures for premium received */
  left join revisions r on r.id = (
    select id from revisions
    where policyTermId = b.policy_term_id and not deleted
      and greatest(revisionDate, commitDate) <= b.endTime
      and not (revisionState = 'archived' and dateArchived <= b.endTime)
    order by
    revisionDate desc, commitDate desc, commitDateTime desc, createDate desc
    limit 1
  )
  left join revisions pr on pr.id = (
    select id from revisions
    where policyTermId = b.policy_term_id and not deleted
      and greatest(revisionDate, commitDate) <= b.priorEndTime
      and not (revisionState = 'archived' and dateArchived <= b.priorEndTime)
    order by
    revisionDate desc, commitDate desc, commitDateTime desc, createDate desc
    limit 1
  )
  /* fallback revision */
  left join revisions fr on r.id is null and fr.id = (select id from revisions
    where policyTermId = b.policy_term_id and not deleted
      and createDate <= b.endTime
      and not (revisionState = 'archived' and dateArchived <= b.endTime)
    order by
    revisionDate desc, commitDate desc, commitDateTime desc, createDate desc
    limit 1
  )
  join policy_types t on t.id = coalesce(r.policyTypeId, fr.policyTypeId)
  join x_revisions_contacts ni on ni.id = (select id from x_revisions_contacts where revisionId = coalesce(r.id, fr.id) and contactId is not null and namedInsured order by dateAdded limit 1)
  join x_revisions_contacts a on a.id = (select id from x_revisions_contacts where revisionId = coalesce(r.id, fr.id) and contactId is not null and agent order by dateAdded desc limit 1)
  group by b.policy_term_id
;
