/* v_claims_perils [x_claims_perils, perils, x_perils_peril_groups, peril_groups] */
create or replace algorithm = merge view v_claims_perils as
select
  x.claimId claim_id,
  p.id peril_id,
  p.name loss_cause,
  p.code loss_code,
  p.aplusCode aplus_code,
  p.lexisNexisCode lexis_nexis_code,
  (select group_concat(distinct g.name order by g.name separator ', ') from x_perils_peril_groups x
   join peril_groups g on g.id = x.groupId
   where x.perilId = p.id) peril_group
from x_claims_perils x
join perils p on p.id = x.perilId
;
