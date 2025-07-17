/* v_permission_rules - permission_levels, permission_level_rules, permission_level_rule_dashboards, dashboards
   note: cannot algorithm = merge on unioned queries.  low records count, so likely not a big deal
*/
create or replace view v_permission_rules as
select
  plr.id permission_rule_id,
  pl.id permission_id,
  pl.name permission_level,
  plr.access,
  plr.rule `resource`,
  plr.locked locked_flag
from permission_level_rules plr
join permission_levels pl on pl.id = plr.permissionLevelid
union all
select
  pld.id permission_rule_id,
  pl.id permission_id,
  pl.name permission_level,
  'dashboard' access,
  d.name `resource`,
  isPrimary locked_flag
from permission_level_rule_dashboards pld
join dashboards d on d.id = pld.dashboardId
join permission_levels pl on pl.id = pld.permissionLevelId
order by permission_level, access, resource
;
