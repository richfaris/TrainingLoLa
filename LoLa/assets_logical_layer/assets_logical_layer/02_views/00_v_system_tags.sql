/* v_system_tags [system_tags] */
create or replace algorithm = merge view v_system_tags as
select
    `system_tags`.`id` AS `system_tag_id`,
    `system_tags`.`name` AS `system_tag_name`
from `system_tags`
