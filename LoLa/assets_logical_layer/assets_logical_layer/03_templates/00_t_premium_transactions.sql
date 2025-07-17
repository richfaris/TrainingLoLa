/* t_premium_transactions */
create or replace view t_premium_transactions as
select
  r.id revision_id,
  r.policyTypeId policy_type_id,
  ni.contactId primary_insured_id,
  a.contactId agency_id,
  coalesce(pr.id, '') prior_revision_id,
  greatest(r.commitDate, r.revisionDate) transaction_date,
  case
    when pr.id is null
    and r.revisionDate = p.inceptionDate then 'New Business'
    when pr.id is null
    and r.revisionDate = e.effectiveDate
    and r.writtenPremium <> 0 then 'Renewal'
    when r.policyStatus like 'Canceled%' then 'Cancellation'
    when coalesce(pr.policyStatus, '') like 'Canceled%'
    and r.policyStatus not like 'Canceled%' then 'Reinstatement'
    when r.writtenPremium - coalesce(pr.writtenPremium, 0) > 0 then 'Increase Endorsement'
    when r.writtenPremium - coalesce(pr.writtenPremium, 0) < 0 then 'Decrease Endorsement'
    else 'Non-Money Endorsement'
  end transaction_type,
  r.writtenPremium - coalesce(pr.writtenPremium, 0) transaction_written_premium
from dates d
join (
  /* <<<============== Report Date Range Here ====================== */
  select '<<$StartDate>>' reportStartDate, '<<$EndDate>>' reportEndDate 
) rd on d.dt between rd.reportStartDate and rd.reportEndDate
join (select 1 reinstateAtCommit union all select 0) rac
join revisions r on r.revisionState in ('committed', 'pending', 'archived')
      and greatest(r.revisionDate, r.commitDate) = d.dt
  and r.id = (
    select
      id
    from
      revisions rr
    where
      policyTermId = r.policyTermId
      and greatest(revisionDate, commitDate) = d.dt
      and reinstateAtCommit = rac.reinstateAtCommit
      and not deleted
      and (
        revisionState in ('pending', 'committed')
        or (
          revisionState = 'archived'
          and dateArchived >= d.dt + interval 1 - reinstateAtCommit day
          and exists (
            select
              1
            from
              revisions
            where
              policyTermId = rr.policyTermId
              and id <> rr.id
              and case
                when rr.reinstateAtCommit
                or policyStatus like 'Canceled%' then revisionDate <= rr.revisionDate
                else revisionDate = rr.revisionDate
              end
          )
        )
      )
    order by
      case
        when policyStatus like 'Canceled%' then greatest(revisionDate, commitDateTime)
        else revisionDate
      end desc,
      revisionDate desc,
      commitDateTime desc,
      createDate desc
    limit 1)
  left join revisions pr on pr.revisionState in ('committed', 'pending', 'archived')
    and r.policyTermId = pr.policyTermId
    and pr.id = (
    select id from revisions rr
    where
      policyTermId = pr.policyTermId
      and greatest(revisionDate, commitDate) < d.dt + interval reinstateAtCommit day
      and (
        revisionDate <= case
          when policyStatus not like 'Canceled%'
          and r.policyStatus like 'Canceled%'
          or (
            revisionState = 'archived'
            and not exists (
              select
                1
              from
                revisions
              where
                policyTermId = rr.policyTermId
                and id <> rr.id
                and revisionDate = rr.revisionDate
                and revisionDate < r.commitDateTime
                and commitDateTime < r.commitDateTime
            )
          ) then greatest(r.commitDateTime, r.revisionDate)
          else r.revisionDate
        end
        or reinstateAtCommit
      )
      and (
        revisionState in ('pending', 'committed')
        or (
          revisionState = 'archived'
          and dateArchived >= d.dt
        )
      )
      and not deleted
      and id <> r.id
    order by
      case
        when policyStatus like 'Canceled%'
        and r.policyStatus not like 'Canceled%'
        and not exists (select 1 from revisions
          where
            policyTermId = rr.policyTermId
            and revisionDate = rr.revisionDate
            and commitDateTime > rr.commitDateTime
            and revisionDate <= r.revisionDate
            and id <> r.id
            and not deleted
        ) then greatest(revisionDate, commitDateTime)
        else revisionDate
      end desc,
      case
        when commitDate = r.commitDate
        and createDate < r.createDate
        and not r.reinstateAtCommit then reinstateAtCommit
        else 0
      end desc,
      commitDateTime desc,
      createDate desc
    limit 1)
join policies p on p.id = r.policyId
join policy_terms e on e.id = r.policyTermId
join x_revisions_contacts ni on ni.id = (select id from x_revisions_contacts where revisionId = r.id and contactId is not null and namedInsured order by dateAdded limit 1)
join x_revisions_contacts a on a.id = (select id from x_revisions_contacts where revisionId = r.id and contactId is not null and agent order by dateAdded desc limit 1)
where
/* do not allow back-to-back reinstate transactions */
r.reinstateAtCommit + coalesce(pr.reinstateAtCommit, 0) < 2 and
r.writtenPremium - coalesce(pr.writtenPremium, 0) <> 0
;
