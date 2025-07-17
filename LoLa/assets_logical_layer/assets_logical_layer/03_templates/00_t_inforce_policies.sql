/* t_inforce_policies */
create or replace view t_inforce_policies as
with docs as (select
  'Returns policies in force as of a specified date, with joins to revision, policy type, primary insured, and agency' view_doc,
  'revision' view_grain,
  'Key to revision' revision_id,
  'Key to policy type' policy_type_id,
  'Key to primary (first added/listed) insured' primary_insured_id,
  'Key to attached agency/agent (depending on "policy go to" setting)' agency_id,
  'Policy term written premium in force as of the specified date' inforce_premium
)
select
  r.id revision_id,
  r.policyTypeId policy_type_id,
  ni.contactId primary_insured_id,
  a.contactId agency_id,
  r.writtenPremium inforce_premium
from docs
join (select '<<$AsOfDate>>' dt) v on true
straight_join policy_terms e on v.dt between e.effectiveDate and e.expirationDate - interval 1 day
straight_join revisions r on r.policyTermId = e.id and r.id = (
		select id from revisions where not deleted and
		policyTermId = r.policyTermId
		and greatest(revisionDate, commitDate) <= v.dt
		and (revisionState in ('pending', 'committed') or (revisionState = 'archived' and cast(dateArchived as date) > v.dt))
		order by
        revisionDate desc, commitDate desc,
        commitDateTime desc, createDate desc
		limit 1) and r.policyStatus not like 'Canceled%'
join x_revisions_contacts ni on ni.id = (select id from x_revisions_contacts where revisionId = r.id and contactId is not null and namedInsured order by dateAdded limit 1)
join x_revisions_contacts a on a.id = (select id from x_revisions_contacts where revisionId = r.id and contactId is not null and agent order by dateAdded desc limit 1)
;
