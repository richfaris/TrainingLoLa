/* v_json_revision [v_revisions, v_json_property, v_json_revision_item, v_revisions_contacts, v_contacts, contacts, v_revisions_agencies, v_agencies] */
create or replace algorithm = merge view v_json_revision as
select
  r.revision_id,
  r.policy_term_id,
  r.policy_id,
  r.revision_date,
  r.commit_date_time,
  r.commit_date,
  json_object(
    'copy', 'Preview (not legal)',
    'date', date_format(curdate(), '%m/%d/%Y'),
    'procdate', date_format(curdate(), '%m/%d/%Y'),
    'policy', r.policy_number,
    'submitted_bound', r.submitted_bound,
    'billing_schedule', r.billing_schedule,
    'policy_system_tags', r.policy_system_tags,
    'line', t.line_of_business,
    'dec_type', case
      when r.revision_date = r.inception_date and not r.process_as_renewal then 'New Business'
      when r.revision_date = r.term_effective_date and r.process_as_renewal then 'Renewal'
      else 'Endorsement' end,
    'dec_description', r.print_description,
    'status', r.policy_status,
    'status_reason', r.policy_status_reason,
    'insureds', (
      select json_arrayagg(
        json_object(
          'name', i.insured_name,
          'order', i.insured_order,
          'ordinal', bc_ordinal(i.insured_order),
          'address1', i.address_line_1,
          'address2', i.address_line_2,
          'city', i.address_city,
          'state', i.address_state,
          'zip', i.address_zip,
          'full_address', i.full_address,
          'phone', i.primary_phone,
          'cell_phone', i.cell_phone,
          'home_phone', i.home_phone,
          'email', i.primary_email,
          'dob', (select date_format(bc_decrypt_value(dob), '%m/%d/%Y') from contacts where id = i.insured_id)
        )
      ) from (
          select i.*, row_number() over (order by rci.date_added) insured_order
          from v_revisions_contacts rci
          join v_insureds i on i.insured_id = rci.contact_id
          where rci.revision_id = r.revision_id and rci.relationship = 'named_insured'
      ) i
    ),
    'grouped_insureds', (
      select json_arrayagg(
        json_object(
          'names', i.insured_names,
          'order', i.insured_order,
          'ordinal', bc_ordinal(i.insured_order),
          'address1', i.address_line_1,
          'address2', i.address_line_2,
          'city', i.address_city,
          'state', i.address_state,
          'zip', i.address_zip,
          'full_address', i.full_address,
          'phone', i.primary_phone,
          'cell_phone', i.cell_phone,
          'home_phone', i.home_phone,
          'email', i.primary_email
        )
      ) from (
          select i.*, group_concat(i.insured_name order by rci.date_added separator ', ') insured_names,
          row_number() over (order by rci.date_added) insured_order
          from v_revisions_contacts rci
          join v_insureds i on i.insured_id = rci.contact_id
          where rci.revision_id = r.revision_id and rci.relationship = 'named_insured'
          group by i.full_address
      ) i
    ),
    'interests', (
      select json_arrayagg(
        json_object(
          'name', i.contact_name,
          'order', i.contact_order,
          'ordinal', bc_ordinal(i.contact_order),
          'address1', i.address_line_1,
          'address2', i.address_line_2,
          'city', i.address_city,
          'state', i.address_state,
          'zip', i.address_zip,
          'full_address', i.full_address,
          'interest', i.additional_interest
        )
      ) from (
          select i.*, rci.additional_interest, row_number() over (order by rci.date_added) contact_order
          from v_revisions_contacts rci
          join v_contacts i on i.contact_id = rci.contact_id
          where rci.revision_id = r.revision_id and rci.relationship = 'additional_interest'
      ) i
    ),
    'agency', json_object(
      'name', ra.agency_name,
      'code', ra.agency_number,
      'address1', ra.address_line_1,
      'address2', ra.address_line_2,
      'city', ra.address_city,
      'state', ra.address_state,
      'zip', ra.address_zip,
      'phone', ra.primary_phone,
      'work_phone', ra.work_phone,
      'cell_phone', ra.cell_phone,
      'email', ra.primary_email,
      'website', ra.website
    ),
    'inception_date', date_format(r.inception_date, '%m/%d/%Y'),
    'effective_date', date_format(r.term_effective_date, '%m/%d/%Y'),
    'expiration_date', date_format(r.term_expiration_date, '%m/%d/%Y'),
    'revision_date', date_format(r.revision_date, '%m/%d/%Y'),
    'commit_date', date_format(r.commit_date, '%m/%d/%Y'),
    'cancel_date', date_format(r.cancel_date, '%m/%d/%Y'),
    'forms', (
      select json_arrayagg(
        json_object(
          'code', f.form_code,
          'edition', f.form_edition,
          'description', f.form_description,
          'order', f.form_order
        )
      ) from (select f.*, row_number() over (order by f.date_added) form_order
        from v_policy_types_forms f
        where f.policy_type_id = r.policy_type_id
        /* mortgagee presence conditions */
        and if(f.mortgagee_types_condition is null, 1,
               (select json_overlaps(
                  json_extract(f.mortgagee_types_condition, '$'),
                  (select json_arrayagg(m.mortgage_type)
                   from v_properties_contacts m
                   join v_properties p on p.property_id = m.property_id and m.relationship = 'mortgagee'
                   where p.revision_id = r.revision_id)
                )
               )
        )) f
    ),
    'items', (
      select json_arrayagg(i.revision_item_json)
      from (select revision_id, revision_item_json,
            row_number() over (order by item_order) merge_sort_hack
            from v_json_revision_item where revision_id = r.revision_id) i
    ),
    'properties', (
      select json_arrayagg(p.property_json)
      from (
        select p.property_json, row_number() over (order by p.date_added) merge_sort_hack
        from v_json_property p
        where p.revision_id = r.revision_id
      ) p
    ),
    'written_premium', r.written_premium,
    'annual_premium', r.annual_premium,
    'written_fees', r.written_fees,
    'annual_fees', r.annual_fees
  ) revision_json
from v_revisions r
left join v_policy_types t on t.policy_type_id = r.policy_type_id
left join v_revisions_contacts rca on rca.revision_id = r.revision_id and rca.relationship = 'agency'
left join v_revisions_agencies ra on rca.contact_id = ra.agency_id and ra.revision_id = r.revision_id
;
