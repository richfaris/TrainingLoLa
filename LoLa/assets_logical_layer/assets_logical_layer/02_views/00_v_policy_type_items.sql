/* v_policy_type_items [policy_type_items, sub_lines] */
create or replace algorithm = merge view v_policy_type_items as
select
  /* important keys */
  i.id policy_type_item_id,
  i.policyTypeId policy_type_id,
  /* important fields */
  i.category item_category,
  i.`type` item_type,
  i.name item_name,
  s.name subline_name,
  nullif(trim(i.description), '')  item_description,
  nullif(trim(s.description), '') subline_description,
  s.`type` subline_type,
  i.sortOrder item_order,
  s.sortOrder subline_order,
  i.`default` item_is_default,
  i.mandatory item_is_mandatory,
  i.allowMultiples item_allow_multiple,
  s.`default` subline_is_default,
  s.mandatory subline_is_mandatory,
  s.allowMultiples subline_allow_mutiple,
  s.editableName subline_editable_name,
  i.disallowSubmitBound disallow_submit_bound,
  /* document style / layout rules */
  i.displayOnDecAs dec_section,
  i.combinePremium dec_combine_premium,
  i.doNotDisplayWhenZero dec_hide_when_zero,
  i.displayPremiumAsIncl dec_print_included_when_zero,
  i.doNotDisplayInRatingInformation dec_exclude_from_rating_info,
  i.showLimitAndPremiumOnDec dec_limit_and_premium_in_rating_info,
  i.displayUserInputsAboveRateCategories dec_user_inputs_first,
  concat(if(i.decFontBold, '<b>', ''),
         if(i.decFontItalic, '<i>', ''),
         i.name,
         if(i.decFontItalic, '</i>', ''),
         if(i.decFontBold, '<.b>', '')
  ) html_formatted_item_name,
  /* setup fields */
  i.hasLimit has_limit,
  if(json_search(i.rateChain, 'one', 'Deductible', null, '$[*].type') is not null, 1, 0) has_deductible,
  i.hasRate has_rate,
  i.rateChain rate_chain_obj,
  bc_label_tags(i.systemTags) item_system_tags,
  bc_label_tags(s.systemTags) subline_system_tags,
  i.hasLossPayee has_loss_payee,
  if(i.hideInBriteQuote, 0, 1) agent_can_add,
  i.preventFromBeingDeleted agent_cannot_remove,
  if(i.limitAvailability like '', 'All', i.limitAvailability) term_availability,
  case i.showInBuilder when 'none' then 'Hidden'
       when 'bc' then 'Carrier Only'
       when 'all' then 'Agent and Carrier' end item_visibility,
  /* accounting-related fields */
  i.fullyEarned fully_earned,
  i.fullyBilled fully_billed,
  i.roundMethod round_method,
  length(i.roundTo) - length(replace(i.roundTo, '0', '')) decimal_places,
  i.roundProRata round_pro_rata,
  i.noCommissionPaidOnLineItem commission_excluded,
  i.calculateItemCommissionRate item_specific_commission,
  i.commissionRateEval commission_rate_eval,
  i.excludedProrataAndFactor ignore_term_factor,
  i.dividendFactor dividend_factor,
  i.proRateFee prorate_fee,
  i.scheduledItem item_schedule_obj,
  /* decAliases is configured (barely) for a single customer:
     fmbc Farmers Mutual Burnet County. excluding for now.
  i.decAliases dec_aliases,
  html font-size not supported in Carbone currently
  i.decFontSize dec_font_size,
  below in html formatted name
  i.decFontBold dec_font_bold,
  i.decFontItalic dec_font_italic,
  */
  lossExposure in_loss_exposure_group,
  lossFreeCredit loss_free_obj,
  notApplicableForAgencyBilling not_applicable_for_agency_billing,
  /* probably don't need these
  renewalAmount renewal_amount,
  renewalModify renewal_modify,
  renewalSplitBy renewal_split_by,
  renewalZipFactors renewal_zip_factors,
  skipPBOnMandatoryAdd skip_pb_on_mandatory_add,
  skipPBOnCategoryAdd default_value_new_categories,
  overrideLimit overrides_other_items_limit,
  */
  if(submitBoundLimit, submitBoundLimitUpper, null) submit_unbound_if_limit_exceeds,
  i.claimCoveragePartyTypes claim_coverage_party_types,
  i.defaultLossReserve default_loss_reserve,
  i.defaultAdjustingReserve default_adjusting_reserve,
  i.defaultLegalReserve default_legal_reserve,
  subLineId sub_line_id,
  i.externalSystemReference item_external_system_reference,
  i.lastSynchedDate last_synched_date,
  i.inheritanceId item_inheritance_id,
  i.referenceId item_reference_id
from policy_type_items i
left join sub_lines s on s.id = i.subLineId
;
