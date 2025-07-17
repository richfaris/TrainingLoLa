/* v_logical_catalog */
create or replace algorithm = merge view v_logical_catalog as
with docs as (select
  'Utility view that generates the logical SQL catalog' view_doc,
  'view_field' view_grain,
  'View or Measure name to use in FROM clause' view_name,
  'Field position in the view when selecting *' field_num,
  'Name of the field to use in SELECT clause' field_name,
  'Type of data present in the field' field_type,
  'Logical description of the field content or purpose' field_description
)
select
  case left(v.table_name, 2) when 't_' then concat('m', mid(v.table_name, 2)) else v.table_name end view_name,
  case vr.idx when 0 then 0 else c.ordinal_position end field_num,
  left(case vr.idx when 0 then case locate("`view_grain`", v.view_definition) when 0 then ''
    else substring_index(substring_index(
      v.view_definition,
      "' AS `view_grain", 1),
      "'", -1) end
  else c.column_name end, 255) field_name,
  left(case vr.idx when 0 then
       case when left(v.table_name, 2) = 'v_' then 'dimension'
            when locate('<<$AsOfDate>>', v.view_definition) > 0 then 'asof'
            else 'range' end
       else c.data_type end, 16) field_type,
  left(case locate(concat("' AS `", c.column_name), substring_index(v.view_definition, ') select', 1)) when 0 then '' else
  substring_index(substring_index(
    v.view_definition,
    concat("' AS `", case vr.idx when 0 then 'view_doc' else c.column_name end), 1),
    "'", -1) end, 2024) field_description
from docs
join (select 0 idx union all select 1) vr on true
join information_schema.columns c on vr.idx >= case c.ordinal_position when 1 then 0 else 1 end
join information_schema.views v on v.table_name = c.table_name
where v.table_schema = schema()
order by view_name, field_num
;
