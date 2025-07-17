/* v_json_property [v_properties, v_json_property_item, v_properties_contacts, v_contacts] */
create or replace algorithm = merge view v_json_property as
select
  p.property_id,
  p.revision_id,
  p.date_added,
  json_object(
    'address1', p.address_line_1,
    'address2', p.address_line_2,
    'city', p.address_city,
    'state', p.address_state,
    'zip', p.address_zip,
    'written_premium', p.written_premium,
    'annual_premium', p.annual_premium,
    'written_fee', p.written_fee,
    'annual_fee', p.annual_fee,
    'items', (
      select json_arrayagg(i.property_item_json)
      from (
        select property_id, property_item_json,
        row_number() over (order by item_order) merge_sort_hack
        from v_json_property_item where property_id = p.property_id) i
    ),
    'mortgagees', (
      select json_arrayagg(
        json_object(
          'type', m.mortgage_type,
          'name', m.name,
          'address1', m.address1,
          'address2', m.address2,
          'city', m.city,
          'state', m.state,
          'zip', m.zip,
          'full_address', m.full_address,
          'statement', m.dec_mortgage_statement,
          'loan_number', m.loan_number,
          'loan_description', m.loan_description
        )
      ) from (select pc.*, m.contact_name name, m.address_line_1 address1,
          m.address_line_2 address2, m.address_city city,
          m.address_state `state`, m.address_zip zip,
          m.full_address,
          row_number() over (order by pc.mortgage_type, pc.date_added) mort_num
          from v_properties_contacts pc
          join v_contacts m on m.contact_id = pc.contact_id
          where pc.property_id = p.property_id and pc.relationship = 'mortgagee'
      ) m
    )
  ) property_json
from v_properties p
;
