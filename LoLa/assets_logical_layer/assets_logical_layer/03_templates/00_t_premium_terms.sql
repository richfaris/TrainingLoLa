/* t_premium_terms written earned premium at policy term level - similar to MEC Premium logic */
create or replace view t_premium_terms as
with docs as (select
  'Written and Earned Premium and Fees over a given date range' view_doc,
  'policy_term' view_grain,
  'Key to v_revisions' revision_id
)
select
  r.id revision_id,
  r.policyTypeId policy_type_id,
  ni.contactId primary_insured_id,
  a.contactId agency_id,
  coalesce(pr.id, '') prior_revision_id,
  r.writtenPremium - coalesce(pr.writtenPremium, 0) premium_written,
  r.writtenPremium end_written,
  r.writtenFee - coalesce(pr.writtenFee, 0) fee_written,
  r.writtenFee end_fee,
  /* earned = written - unearned */
  r.writtenPremium - case
  when r.policyStatus like 'Canceled%' then 0
  else round(
      greatest(
      0,
      cast(
          datediff(
          e.expirationDate,
          d.periodEnd + interval 1 microsecond
          ) as decimal(16, 10)
      ) / e.termLength
      ) * r.annualPremium * coalesce(r.termFactor, 1.0000),
      2
  )
  end end_earned,
  case
  when pr.id is null then 0.00
  else pr.writtenPremium - case
      when pr.policyStatus like 'Canceled%' then 0
      else round(
      greatest(
          0,
          cast(
          datediff(e.expirationDate, d.periodStart) as decimal(16, 10)
          ) / e.termLength
      ) * pr.annualPremium * coalesce(pr.termFactor, 1.0000),
      2
      )
  end
  end prior_earned
from
  docs
 join (
  select
      rd.reportStartDate,
      rd.reportEndDate,
      rd.reportStartDate periodStart,
      rd.reportEndDate + interval 1 day - interval 1 microsecond periodEnd,
      rd.reportStartDate - interval 1 microsecond priorEnd
  from (
      select '<<$StartDate>>' as reportStartDate, '<<$EndDate>>' as reportEndDate /* <<<============== Report Date Range Here ====================== */
      ) rd
  ) d on true
  straight_join revisions r on r.revisionState in ('committed', 'pending', 'archived')
  and r.id = (
  select
      rr.id
  from
      revisions rr
      join policy_terms re on re.id = rr.policyTermId
  where
      rr.policyTermId = r.policyTermId
      /* committed/effective during this period for written.  latest prior within effective for earned */
      and greatest(rr.revisionDate, rr.commitDateTime) <= d.periodEnd
      and (
      greatest(rr.revisionDate, rr.commitDateTime) > d.periodStart
      or (
          re.effectiveDate <= d.periodEnd
          and re.expirationDate > d.periodStart
      )
      )
      and (
      rr.revisionState in ('pending', 'committed')
      or (
          rr.revisionState = 'archived'
          and rr.dateArchived > d.periodEnd
          and not rr.deleted
      )
      )
  order by
      rr.revisionDate desc,
      rr.commitDateTime desc,
      rr.createDate desc
  limit
      1
  )
  and not(
  r.policyStatus like 'Canceled%'
  and greatest(r.revisionDate, r.commitDateTime) < d.periodStart
  )
  join policy_terms e on e.id = r.policyTermId
  left join revisions pr on r.revisionState in ('committed', 'pending', 'archived')
  and r.policyTermId = pr.policyTermId
  and pr.id = (
  select
      rr.id
  from
      revisions rr
      join policy_terms re on re.id = rr.policyTermId
  where
      rr.policyTermId = r.policyTermId
      /* committed/effective prior to this period */
      and greatest(rr.revisionDate, rr.commitDateTime) < d.periodStart
      and (
      rr.revisionState in ('pending', 'committed')
      or (
          rr.revisionState = 'archived'
          and rr.dateArchived > d.priorEnd
          and not rr.deleted
      )
      )
  order by
      rr.revisionDate desc,
      rr.commitDateTime desc,
      rr.createDate desc
  limit
      1
  )
join x_revisions_contacts ni on ni.id = (select id from x_revisions_contacts where revisionId = r.id and contactId is not null and namedInsured order by dateAdded limit 1)
join x_revisions_contacts a on a.id = (select id from x_revisions_contacts where revisionId = r.id and contactId is not null and agent order by dateAdded desc limit 1)
;
