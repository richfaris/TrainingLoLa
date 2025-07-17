create or replace algorithm = merge view v_policy_type_items_forms as
select
  x.id policy_type_item_form_id,
  f.id file_id,
  f.referenceId policy_type_item_id,
  x.formCode form_code,
  x.editionNumber form_edition,
  x.description form_description,
  case when x.conditionalPrint then x.conditionalValues end category_conditions,
  case when x.conditionalPremiumPrint then x.conditionalPremiumSelect end premium_zero_condition,
  nullif(mortgageeTypes, '[]') mortgagee_types_condition,
  x.suppressPrinting do_not_print,
  x.alwaysPrintOnRenewal print_every_renewal,
  f.title file_name,
  f.size file_size,
  f.dateAdded date_added
from x_policy_type_items_docs x
join files f on f.id = x.fileId
;
