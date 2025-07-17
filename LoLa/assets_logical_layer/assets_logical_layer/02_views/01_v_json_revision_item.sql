/* v_json_revision_item [v_revision_items, v_policy_type_items, v_policy_type_items_forms] */
create or replace algorithm = merge view v_json_revision_item as
select
  i.revision_item_id,
  i.revision_id,
  y.item_order,
  json_object(
    'order', y.item_order,
    'name', i.item_name,
    'type', i.item_type,
    'section', y.dec_section,
    'has_limit', y.has_limit,
    'has_deductible', y.has_deductible,
    'has_rate', y.has_rate,
    'limit', i.coverage_limit,
    'limit_type', i.limit_type,
    'second_limit', i.second_limit,
    'second_limit_type', i.second_limit_type,
    'third_limit', i.third_limit,
    'third_limit_type', i.third_limit_type,
    'deductible', i.deductible,
    'removed', i.item_deleted,
    'written_premium', i.written_premium,
    'display_written', if(i.written_premium = 0 and y.dec_print_included_when_zero, 'Included', concat('$', format(i.written_premium, 2))),
    'written_fee', i.written_fee,
    'annual_premium', i.annual_premium,
    'display_annual', if(i.annual_premium = 0 and y.dec_print_included_when_zero, 'Included', concat('$', format(i.annual_premium, 2))),
    'annual_fee', i.annual_fee,
    'builder_obj', json_replace(
      json_extract(i.builder_obj, '$'), '$.questions',
      json_extract(i.questions, '$')
    ),
    'forms', (
      select json_arrayagg(
        json_object(
          'code', f.form_code,
          'edition', f.form_edition,
          'description', f.form_description,
          'order', f.form_order
        )
      ) from (select f.*, row_number() over (order by f.date_added) form_order
        from v_policy_type_items_forms f
        where f.policy_type_item_id = i.policy_type_item_id
          /* form category conditions */
          and if(json_length(coalesce(f.category_conditions, '[]')) = 0, 1,
                 (select count(*) = json_length(f.category_conditions)
                  from json_table(
                         json_keys(f.category_conditions),
                        '$[*]' columns (cond_key varchar(255) path '$')
                  ) k
                  where json_overlaps(
                          json_extract(f.category_conditions, concat('$."', k.cond_key, '"[*]')),
                          json_array(
                            json_extract(i.builder_obj, concat('$.categories."', k.cond_key, '"')),
                            /* we have to also test against a normalized value to handle broken sites from prior bug */
                            json_unquote(lower(replace(regexp_replace(
                              json_extract(i.builder_obj, concat('$.categories."', k.cond_key, '"')),
                              '[^[:ascii:]]', ''), ' ', '')))
                          )
                        )
                  ))
          /* premium inequality conditions */
          and if(f.premium_zero_condition is null, 1,
              case f.premium_zero_condition
              when 'gt' then i.written_premium > 0
              when 'gte' then i.written_premium >= 0
              when 'eq' then i.written_premium = 0
              when 'neq' then i.written_premium <> 0
              when 'lte' then i.written_premium <= 0
              when 'lt' then i.written_premium < 0
              else 0 end
              )
          /* mortgagee presence conditions */
          and if(f.mortgagee_types_condition is null, 1,
                 (select json_overlaps(
                    json_extract(f.mortgagee_types_condition, '$'),
                    (select json_arrayagg(m.mortgage_type)
                     from v_properties_contacts m
                     join v_properties p on p.property_id = m.property_id and m.relationship = 'mortgagee'
                     where p.revision_id = i.revision_id)
                  )
                 )
          )
        ) f
    ),
    'rating_details', (
      select json_arrayagg(
        json_object(
          'name', ro.name,
          'description', ro.description,
          'value', ro.value
        )
      )
      from json_table(
        convert(i.rating_obj using utf8mb4),
        '$.objects[*]' COLUMNS (
          name VARCHAR(50) PATH '$.name',
          description VARCHAR(255) PATH '$.description',
          value TEXT PATH '$.runningTotal'
        )
      ) ro
      /* excluding giant lookup tables from rating_obj */
      where char_length(ro.value) <= 50
    )
  ) revision_item_json
from v_revision_items i
join v_policy_type_items y on y.policy_type_item_id = i.policy_type_item_id
where not (i.item_deleted and i.written_premium = 0)
;
