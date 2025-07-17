/* v_policy_types [effective_dates, business_locations, lines, policy_types, system_tags] */
create or replace algorithm = merge view v_policy_types as
select
  e.id effective_id,
  e.effectiveDate lines_effective_date,
  e.description lines_effective_description,
  b.id location_id,
  c.abbreviation country,
  b.abbreviation state,
  l.id line_id,
  l.name line_of_business,
  bc_label_tags(l.systemTags) line_system_tags,
  t.id policy_type_id,
  t.name policy_type,
  t.multiplePropertyStatus multi_property,
  t.openToQuoting open_to_quoting,
  bc_label_tags(t.systemTags) policy_type_system_tags
from policy_types t
join `lines` l on l.id = t.lineId
join business_locations b on b.id = t.locationId
join countries c on c.id = b.countryId
join effective_dates e on e.id = t.effectiveId
;
