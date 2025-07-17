/* v_roles - roles, x_roles_aspects, aspects, permission_levels */
create or replace algorithm = merge view v_roles as
select
  r.id role_id,
  r.name role_name,
  coalesce(r.type, 'both') role_type,
  (select group_concat(a.name order by a.name separator ', ')
   from aspects a join x_roles_aspects x on x.aspectId = a.id where x.roleId = r.id) aspects,
  (select count(*) from x_contacts_roles x
   join contacts c on c.id = x.contactId and c.active
   where x.roleId = r.id) contacts,
  p.name default_permission_level,
  r.dateUpdated date_updated
from roles r
left join permission_levels p on p.id = r.permissionLevelId
;
