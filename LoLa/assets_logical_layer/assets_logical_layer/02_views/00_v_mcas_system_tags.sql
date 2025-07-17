create or replace algorithm = merge view v_mcas_system_tags as
with `_target_system_tag` as (
	select
		`system_tags`.`id` as `target_system_tag_id`,
		`system_tags`.`name` as `target_system_tag_name`
	from
		`system_tags`
	where
		(`system_tags`.`name` = 'MCAS')
	limit 1
),
 `_all_entities_with_system_tags` as (
	select
		l.id as line_id,
		l.`name` as line_of_business,
		l.systemTags as line_system_tag,
		t.id as policy_type_id,
		t.`name` as policy_type,
		t.systemTags as policy_type_system_tag,
		i.subLineId as sub_line_id,
		s.`name` as subline_name,
		s.systemTags as subline_system_tag,
		i.id as policy_type_item_id,
		i.`name` as item_name,
		i.systemTags as item_system_tag,
		i.rateChain as rate_chain_obj
	from `policy_type_items` i
	join `policy_types` t on t.id = i.policyTypeId
	join `lines` l on l.id = t.lineId
	left join `sub_lines` s on s.id = i.subLineId
    where ((l.systemTags like (
    select
        concat('%', `target_system_tag_id`, '%')
    from
        `_target_system_tag`))
    or (t.systemTags like (
    select
        concat('%', `target_system_tag_id`, '%')
    from
        `_target_system_tag`))
    or (s.systemTags like (
    select
        concat('%', `target_system_tag_id`, '%')
    from
        `_target_system_tag`))
    or (i.systemTags like (
    select
        concat('%', `target_system_tag_id`, '%')
    from
        `_target_system_tag`))
    or (i.rateChain like (
    select
        concat('%', `target_system_tag_id`, '%')
    from
        `_target_system_tag`)))
),
`_cast_system_tags` as (
	select
		ast.line_id,
		ast.line_of_business,
		json_unquote(json_extract(bc_label_tags(ast.line_system_tag), concat('$.', (select `target_system_tag_name` from `_target_system_tag`)))) as line_target_system_tag_value,
		ast.policy_type_id,
		ast.policy_type,
		json_unquote(json_extract(bc_label_tags(ast.policy_type_system_tag), concat('$.', (select `target_system_tag_name` from `_target_system_tag`)))) as policy_type_target_system_tag_value,
		ast.sub_line_id,
		ast.subline_name,
		json_unquote(json_extract(bc_label_tags(ast.subline_system_tag), concat('$.', (select `target_system_tag_name` from `_target_system_tag`)))) as subline_target_system_tag_value,
		ast.policy_type_item_id,
		ast.item_name,
		json_unquote(json_extract(bc_label_tags(ast.item_system_tag), concat('$.', (select `target_system_tag_name` from `_target_system_tag`)))) as item_target_system_tag_value,
		ast.rate_chain_obj
    from `_all_entities_with_system_tags` `ast`
    having (
		line_target_system_tag_value IS NOT NULL
			or policy_type_target_system_tag_value IS NOT NULL
			or subline_target_system_tag_value IS NOT NULL
			or item_target_system_tag_value IS NOT NULL
	)
),
`_rate_chain_obj_system_tags` as (
    select
        `cst`.`line_id` as `line_id`,
        `cst`.`policy_type_id` as `policy_type_id`,
        `cst`.`sub_line_id` as `sub_line_id`,
        `cst`.`policy_type_item_id` as `policy_type_item_id`,
        `cst`.`rate_chain_obj` as `rate_chain_obj`
    from `_cast_system_tags` `cst`
    where `cst`.`rate_chain_obj` like (
        select
            concat('%', `target_system_tag_id`, '%')
        from
            `_target_system_tag`
    )
),
`_policy_type_item_category_system_tags` as (
	select
		`rcost`.`line_id` as `line_id`,
		`rcost`.`policy_type_id` as `policy_type_id`,
		`rcost`.`sub_line_id` as `sub_line_id`,
		`rcost`.`policy_type_item_id` as `policy_type_item_id`,
		`categories`.`category` as `policy_type_item_category`,
		json_unquote(json_extract(`categories`.`systemTags`, concat('$.', json_quote(`key_item`.`tag_key`), '.', json_quote((select `target_system_tag_id` from `_target_system_tag`))))) as `policy_type_item_category_target_system_tag_value`
	from
		(((`_rate_chain_obj_system_tags` `rcost`
	join json_table(convert(`rcost`.`rate_chain_obj` using utf8mb4), '$[*]' columns (`categories` json path '$.categories')) `rc`)
	join json_table(`rc`.`categories`, '$[*]' columns (`category` varchar(255) character set utf8mb4 path '$.category', `systemTags` json path '$.systemTags')) `categories`)
	join json_table(json_keys(`categories`.`systemTags`), '$[*]' columns (`tag_key` varchar(255) character set utf8mb4 path '$')) `key_item`)
	having (trim(ifnull(`policy_type_item_category_target_system_tag_value`, '')) <> '' )
),
`v_target_system_tags` as (
	select
		`ast`.`line_id` as `line_id`,
		`ast`.`line_of_business` as `line_of_business`,
		`cst`.`line_target_system_tag_value` as `line_target_system_tag_value`,
		`ast`.`policy_type_id` as `policy_type_id`,
		`ast`.`policy_type` as `policy_type`,
		`cst`.`policy_type_target_system_tag_value` as `policy_type_target_system_tag_value`,
		`ast`.`sub_line_id` as `sub_line_id`,
		`ast`.`subline_name` as `subline_name`,
		`cst`.`subline_target_system_tag_value` as `subline_target_system_tag_value`,
		`ast`.`policy_type_item_id` as `policy_type_item_id`,
		`ast`.`item_name` as `item_name`,
		`cst`.`item_target_system_tag_value` as `item_target_system_tag_value`,
		`pticst`.`policy_type_item_category` as `policy_type_item_category`,
		`pticst`.`policy_type_item_category_target_system_tag_value` as `policy_type_item_category_target_system_tag_value`
    from `_all_entities_with_system_tags` ast
    left join `_cast_system_tags` `cst` on
         `ast`.`line_id` = `cst`.`line_id`
         and `ast`.`policy_type_id` = `cst`.`policy_type_id`
         and `ast`.`policy_type_item_id` = `cst`.`policy_type_item_id`
    left join `_policy_type_item_category_system_tags` `pticst` on
         `ast`.`line_id` = `pticst`.`line_id`
         and `ast`.`policy_type_id` = `pticst`.`policy_type_id`
         and `ast`.`policy_type_item_id` = `pticst`.`policy_type_item_id`
)
select
    `v_target_system_tags`.`line_id` as `line_id`,
    `v_target_system_tags`.`line_of_business` as `line_of_business`,
    `v_target_system_tags`.`line_target_system_tag_value` as `line_target_system_tag_value`,
    `v_target_system_tags`.`policy_type_id` as `policy_type_id`,
    `v_target_system_tags`.`policy_type` as `policy_type`,
    `v_target_system_tags`.`policy_type_target_system_tag_value` as `policy_type_target_system_tag_value`,
    `v_target_system_tags`.`sub_line_id` as `sub_line_id`,
    `v_target_system_tags`.`subline_name` as `subline_name`,
    `v_target_system_tags`.`subline_target_system_tag_value` as `subline_target_system_tag_value`,
    `v_target_system_tags`.`policy_type_item_id` as `policy_type_item_id`,
    `v_target_system_tags`.`item_name` as `item_name`,
    `v_target_system_tags`.`item_target_system_tag_value` as `item_target_system_tag_value`,
    `v_target_system_tags`.`policy_type_item_category` as `policy_type_item_category`,
    `v_target_system_tags`.`policy_type_item_category_target_system_tag_value` as `policy_type_item_category_target_system_tag_value`
from
    `v_target_system_tags`
where
	`line_target_system_tag_value` IS NOT NULL
        or `policy_type_target_system_tag_value` IS NOT NULL
        or `subline_target_system_tag_value` IS NOT NULL
        or `item_target_system_tag_value` IS NOT NULL
        or `policy_type_item_category` IS NOT NULL
        or `policy_type_item_category_target_system_tag_value` IS NOT NULL
;
