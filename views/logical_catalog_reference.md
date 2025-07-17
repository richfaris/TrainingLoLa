# BriteCore Logical Catalog Reference

This document lists all available views and their fields as found in `v_logical_catalog` (LoLaCatalog.xlsx).

## `m_accounting_terms`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 |  | range |  |
| 1 | policy_term_id | varchar |  |
| 2 | revision_id | varchar |  |
| 3 | prior_revision_id | char |  |
| 4 | policy_type_id | char |  |
| 5 | primary_insured_id | char |  |
| 6 | agency_id | char |  |
| 7 | ending_due | decimal |  |
| 8 | paid | decimal |  |
| 9 | payments | decimal |  |
| 10 | transfers | decimal |  |
| 11 | paid_custom_fee | decimal |  |
| 12 | paid_system_fee | decimal |  |
| 13 | paid_premium | decimal |  |
| 14 | return_premium | decimal |  |
| 15 | adjustment | decimal |  |
| 16 | advance_premium | decimal |  |
| 17 | premium_billed | decimal |  |
| 18 | premium_write_off | decimal |  |
| 19 | custom_fee_billed | decimal |  |
| 20 | custom_fee_write_off | decimal |  |
| 21 | system_fee_billed | decimal |  |
| 22 | system_fee_waive | decimal |  |
| 23 | installment_fee_billed | decimal |  |
| 24 | non_pay_fee_billed | decimal |  |
| 25 | reinstatement_fee_billed | decimal |  |
| 26 | nsf_fee_billed | decimal |  |
| 27 | term_balance | decimal |  |
| 28 | term_paid | decimal |  |
| 29 | term_payments | decimal |  |
| 30 | term_transfers | decimal |  |
| 31 | term_return_premium | decimal |  |
| 32 | term_adjustment | decimal |  |
| 33 | term_paid_custom_fee | decimal |  |
| 34 | term_paid_system_fee | decimal |  |
| 35 | term_paid_premium | decimal |  |
| 36 | ar_current | decimal |  |
| 37 | ar_0_29 | decimal |  |
| 38 | ar_30_59 | decimal |  |
| 39 | ar_60_89 | decimal |  |
| 40 | ar_90_plus | decimal |  |
| 41 | premium_in_collection | decimal |  |
| 42 | deferred_premium | decimal |  |
| 43 | term_advance_premium | decimal |  |
| 44 | term_premium_billed | decimal |  |
| 45 | term_premium_write_off | decimal |  |
| 46 | term_custom_fee_billed | decimal |  |
| 47 | term_custom_fee_write_off | decimal |  |
| 48 | term_system_fee_billed | decimal |  |
| 49 | term_system_fee_waive | decimal |  |
| 50 | term_premium_debits | decimal |  |
| 51 | revision_written_premium | decimal |  |
| 52 | change_written_premium | decimal |  |

## `m_inforce_policies`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 | revision | asof | Returns policies in force as of a specified date, with joins to revision, policy type, primary insured, and agency |
| 1 | revision_id | char | Key to revision |
| 2 | policy_type_id | char | Key to policy type |
| 3 | primary_insured_id | char | Key to primary (first added/listed) insured |
| 4 | agency_id | char | Key to attached agency/agent (depending on "policy go to" setting) |
| 5 | inforce_premium | decimal | Policy term written premium in force as of the specified date |

## `m_premium_terms`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 | policy_term | range | Written and Earned Premium and Fees over a given date range |
| 1 | revision_id | char | Key to v_revisions |
| 2 | policy_type_id | char |  |
| 3 | primary_insured_id | char |  |
| 4 | agency_id | char |  |
| 5 | prior_revision_id | varchar |  |
| 6 | premium_written | decimal |  |
| 7 | end_written | decimal |  |
| 8 | fee_written | decimal |  |
| 9 | end_fee | decimal |  |
| 10 | end_earned | decimal |  |
| 11 | prior_earned | decimal |  |

## `m_premium_transactions`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 |  | range |  |
| 1 | revision_id | char |  |
| 2 | policy_type_id | char |  |
| 3 | primary_insured_id | char |  |
| 4 | agency_id | char |  |
| 5 | prior_revision_id | varchar |  |
| 6 | transaction_date | date |  |
| 7 | transaction_type | varchar |  |
| 8 | transaction_written_premium | decimal |  |

## `v_account_history`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 |  | dimension |  |
| 1 | account_history_id | char |  |
| 2 | revision_id | char |  |
| 3 | policy_term_id | char |  |
| 4 | transaction_date_time | datetime |  |
| 5 | transaction_type | enum |  |
| 6 | description | varchar |  |
| 7 | due_date | date |  |
| 8 | cancel_date | date |  |
| 9 | back_cancel_date | datetime |  |
| 10 | day_zero_date | date |  |
| 11 | payment_amount | decimal |  |
| 12 | debit_premium_pro_rata | decimal |  |
| 13 | debit_premium_fully_earned | decimal |  |
| 14 | debit_premium_fully_billed | decimal |  |
| 15 | debit_custom_fee_pro_rata | decimal |  |
| 16 | debit_custom_fee_fully_earned | decimal |  |
| 17 | debit_custom_fee_fully_billed | decimal |  |
| 18 | debit_system_fee | decimal |  |
| 19 | paid_in_full | tinyint |  |
| 20 | account_balance | decimal |  |
| 21 | generated_by | varchar |  |
| 22 | user_modified | tinyint |  |
| 23 | row_snapshot | mediumtext |  |
| 24 | date_added | datetime |  |
| 25 | date_updated | timestamp |  |
| 26 | deleted | tinyint |  |
| 27 | date_deleted | datetime |  |
| 28 | voided | tinyint |  |
| 29 | date_voided | datetime |  |
| 30 | file_id | char |  |
| 31 | payment_id | char |  |
| 32 | waive_id | char |  |
| 33 | credit_transfer_id | char |  |
| 34 | debit_transfer_id | char |  |
| 35 | cancellation_revision_id | char |  |

## `v_addresses`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 |  | dimension |  |
| 1 | address_id | char |  |
| 2 | contact_id | char |  |
| 3 | address_type | varchar |  |
| 4 | type_label | varchar |  |
| 5 | attention | varchar |  |
| 6 | address_line_1 | varchar |  |
| 7 | address_line_2 | varchar |  |
| 8 | address_city | varchar |  |
| 9 | address_state | varchar |  |
| 10 | address_zip | varchar |  |
| 11 | address_county | varchar |  |
| 12 | address_country | enum |  |
| 13 | address_location | varchar |  |
| 14 | date_updated | timestamp |  |
| 15 | effective_start_date | date |  |
| 16 | effective_end_date | date |  |

## `v_built_measures`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 | built_table | dimension |  |
| 1 | name | varchar |  |
| 2 | type | varchar |  |
| 3 | start_date | date | Specified start date for range measures |
| 4 | end_date | date | Specified end date for range measures or as of date for asof measures |
| 5 | built_name | varchar | Physical built table name for the provided parameters |
| 6 | future_dated | int | Flagged 1 if the requested end/asof date was future to the build date, making the result possibly incomplete |
| 7 | num_rows | bigint | Number of rows in the table |
| 8 | disk_size | bigint | Storage size of the table in bytes |
| 9 | created | timestamp | Datetime that the measure table was created in UTC |
| 10 | updated | datetime | Datetime that the measure table was last updated in UTC |
| 11 | sql_builder | varchar | Name of the SQL user account used to build the measure |
| 12 | build_secs | decimal | Number of seconds it took to build the measure |
| 13 | api_builder | varchar | Name of the authenticated BriteCore User whose query/report caused the measure to be built |
| 14 | last_accessed | datetime | Datetime that the table was last queried via BriteCore (not updated for direct SQL connection queries) |
| 15 | last_api_user | varchar | Name of the authenticated BriteCore User to last access the measure data via query |
| 16 | json_metadata | text | Object storing the metadata on the built measure |

## `v_claim_change_log`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 |  | dimension |  |
| 1 | claim_change_log_id | char |  |
| 2 | claim_id | char |  |
| 3 | claim_number | varchar |  |
| 4 | change_type | varchar |  |
| 5 | claim_item_id | char |  |
| 6 | claim_status | varchar |  |
| 7 | change_date_time | datetime |  |
| 8 | changed_from | text |  |
| 9 | changed_to | text |  |
| 10 | deleted | tinyint |  |
| 11 | date_updated | timestamp |  |

## `v_claim_items`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 |  | dimension |  |
| 1 | claim_item_id | char |  |
| 2 | claim_id | char |  |
| 3 | policy_item_id | char |  |
| 4 | policy_type_item_id | varchar |  |
| 5 | policy_item_name | varchar |  |
| 6 | claim_item_name | varchar |  |
| 7 | coverage_deductible | decimal |  |
| 8 | override | tinyint |  |
| 9 | loss_reserve | decimal |  |
| 10 | adjusting_reserve | decimal |  |
| 11 | legal_reserve | decimal |  |
| 12 | subrogation_reserve | decimal |  |
| 13 | salvage_reserve | decimal |  |
| 14 | reinsurance_reserve | decimal |  |
| 15 | item_description | varchar |  |
| 16 | loss_type | enum |  |
| 17 | loss_id | char |  |
| 18 | deleted | tinyint |  |
| 19 | date_updated | timestamp |  |

## `v_claim_payments`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 |  | dimension |  |
| 1 | claim_payment_id | char |  |
| 2 | claim_id | char |  |
| 3 | claim_number | varchar |  |
| 4 | loss_date | datetime |  |
| 5 | payment_action | varchar |  |
| 6 | date_entered | datetime |  |
| 7 | date_exported | datetime |  |
| 8 | date_cleared | datetime |  |
| 9 | date_voided | datetime |  |
| 10 | policy_id | char |  |
| 11 | policy_number | varchar |  |
| 12 | check_number | int |  |
| 13 | entered_by_id | char |  |
| 14 | payment_amount | decimal |  |
| 15 | mailing_address_id | char |  |
| 16 | pay_to | varchar |  |
| 17 | check_memo | varchar |  |
| 18 | deductible_applied | decimal |  |
| 19 | payment_classification | varchar |  |
| 20 | coverage_name | longtext |  |
| 21 | loss_paid | decimal |  |
| 22 | legal_paid | decimal |  |
| 23 | adjusting_paid | decimal |  |

## `v_claims`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 |  | dimension |  |
| 1 | claim_id | char |  |
| 2 | claim_number | varchar |  |
| 3 | claim_active_flag | tinyint |  |
| 4 | claim_status | varchar |  |
| 5 | claim_type | enum |  |
| 6 | loss_cause | text |  |
| 7 | policy_number | varchar |  |
| 8 | revision_id | char |  |
| 9 | policy_type_id | char |  |
| 10 | loss_date | datetime |  |
| 11 | date_added | timestamp |  |
| 12 | date_reported | date |  |
| 13 | last_modified | date |  |
| 14 | last_reinsurance_report_date | date |  |
| 15 | description | text |  |
| 16 | iso_business_or_individual | enum |  |
| 17 | property_id | char |  |
| 18 | loss_location_address | text |  |
| 19 | loss_location_address_1 | varchar |  |
| 20 | loss_location_address_2 | varchar |  |
| 21 | loss_location_address_city | varchar |  |
| 22 | loss_location_address_zip | varchar |  |
| 23 | loss_location_address_county_id | varchar |  |
| 24 | loss_location_address_state | varchar |  |
| 25 | loss_location_lat_lng | varchar |  |
| 26 | claim_system_tags | text |  |
| 27 | catastrophe_id | char |  |
| 28 | cat_code | varchar |  |
| 29 | cat_pcs | varchar |  |
| 30 | cat_location | varchar |  |

## `v_claims_contacts`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 |  | dimension |  |
| 1 | claim_contact_id | char |  |
| 2 | claim_id | char |  |
| 3 | contact_id | char |  |
| 4 | relationship | varchar |  |
| 5 | contractor_description | varchar |  |
| 6 | date_added | timestamp |  |
| 7 | date_updated | timestamp |  |

## `v_claims_dates`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 |  | dimension |  |
| 1 | claim_id | char |  |
| 2 | claim_date | date |  |
| 3 | date_type | varchar |  |

## `v_claims_perils`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 |  | dimension |  |
| 1 | claim_id | char |  |
| 2 | peril_id | char |  |
| 3 | loss_cause | varchar |  |
| 4 | loss_code | varchar |  |
| 5 | aplus_code | char |  |
| 6 | lexis_nexis_code | varchar |  |
| 7 | peril_group | text |  |

## `v_commission_details`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 |  | dimension |  |
| 1 | commission_detail_id | char |  |
| 2 | revision_id | char |  |
| 3 | agency_id | char |  |
| 4 | commission_payment_id | char |  |
| 5 | applicable_premium | decimal |  |
| 6 | commission_amount | decimal |  |
| 7 | commission_rate | decimal |  |
| 8 | delay_reason | enum |  |
| 9 | calculation_type | varchar |  |
| 10 | manual_flag | tinyint |  |
| 11 | added_by | varchar |  |
| 12 | date_calculated | datetime |  |
| 13 | date_exported | datetime |  |
| 14 | date_added | datetime |  |
| 15 | date_updated | timestamp |  |
| 16 | item_id | varchar |  |

## `v_commission_payments`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 |  | dimension |  |
| 1 | commission_payment_id | char |  |
| 2 | payee_contact_id | char |  |
| 3 | payment_amount | decimal |  |
| 4 | transaction_date | datetime |  |
| 5 | date_added | datetime |  |
| 6 | date_reviewed | datetime |  |
| 7 | date_exported | datetime |  |
| 8 | date_updated | timestamp |  |
| 9 | reviewed | tinyint |  |
| 10 | exported | tinyint |  |
| 11 | is_electronic | tinyint |  |
| 12 | payment_method_id | varchar |  |
| 13 | is_net_commission | tinyint |  |

## `v_contact_relationships`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 |  | dimension |  |
| 1 | contact_relationship_id | char |  |
| 2 | subject_contact_id | char |  |
| 3 | related_contact_id | char |  |
| 4 | relationship | varchar |  |

## `v_contacts`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 | contact | dimension | Base view for all Contacts in BriteCore |
| 1 | contact_id | char | Primary key for the contact |
| 2 | deleted | int | Indicator whether the contact has been soft "deleted" |
| 3 | contact_name | varchar | The full name of the contact |
| 4 | contact_type | enum | The type of the contact ("individual" or "organization") |
| 5 | primary_email | varchar |  |
| 6 | primary_phone | varchar |  |
| 7 | attention | varchar |  |
| 8 | address_line_1 | varchar |  |
| 9 | address_line_2 | varchar |  |
| 10 | address_city | varchar |  |
| 11 | address_state | varchar |  |
| 12 | address_zip | varchar |  |
| 13 | address_county | varchar |  |
| 14 | address_country | varchar |  |
| 15 | full_address | text |  |
| 16 | gender | varchar |  |
| 17 | doing_business_as | varchar |  |
| 18 | legal_entity_type | varchar |  |
| 19 | date_business_started | varchar |  |
| 20 | terms_conditions_accepted | tinyint |  |
| 21 | edelivery_enabled | tinyint |  |
| 22 | portal_code | varchar |  |
| 23 | fein | varchar |  |
| 24 | position | varchar |  |
| 25 | website | varchar |  |
| 26 | contact_background | longtext |  |
| 27 | commission_structure | varchar |  |
| 28 | use_agency_group_commission_structure | tinyint |  |
| 29 | pay_commission_to | enum |  |
| 30 | agency_group_number | varchar |  |
| 31 | agency_number | varchar |  |
| 32 | producer_number | varchar |  |
| 33 | vendor_number | varchar |  |
| 34 | mortgagee_statement | varchar |  |
| 35 | agent_terminated | tinyint |  |
| 36 | termination_reason | varchar |  |
| 37 | agency_inactive_at | datetime |  |
| 38 | agency_inception_date | date |  |
| 39 | agency_termination_date | date |  |
| 40 | permission_level | varchar |  |
| 41 | last_login | datetime |  |
| 42 | briteauth_username | varchar |  |
| 43 | legacy_username | varchar |  |
| 44 | user_email | varchar |  |
| 45 | superuser_flag | tinyint |  |
| 46 | timezone | varchar |  |
| 47 | default_state | varchar |  |
| 48 | roles | text |  |
| 49 | system_tags | text |  |
| 50 | date_added | timestamp |  |
| 51 | date_updated | timestamp |  |
| 52 | date_address_updated | timestamp |  |
| 53 | date_phone_updated | timestamp |  |
| 54 | date_email_updated | timestamp |  |

## `v_counties`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 |  | dimension |  |
| 1 | county_id | varchar |  |
| 2 | county_name | varchar |  |
| 3 | county_code | varchar |  |
| 4 | country_id | char |  |
| 5 | country_name | varchar |  |
| 6 | country_abbreviation | char |  |
| 7 | state_id | char |  |
| 8 | state_name | varchar |  |
| 9 | state_abbreviation | char |  |

## `v_dates`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 |  | dimension |  |
| 1 | date | date |  |
| 2 | week | tinyint |  |
| 3 | month | tinyint |  |
| 4 | quarter | tinyint |  |
| 5 | year | smallint |  |
| 6 | year_month | mediumint |  |
| 7 | day_of_week | tinyint |  |
| 8 | day_of_month | tinyint |  |
| 9 | day_of_year | smallint |  |
| 10 | is_month_start | tinyint |  |
| 11 | is_month_end | tinyint |  |
| 12 | is_quarter_start | tinyint |  |
| 13 | is_quarter_end | tinyint |  |
| 14 | is_year_start | tinyint |  |
| 15 | is_year_end | tinyint |  |

## `v_files`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 |  | dimension |  |
| 1 | file_id | char |  |
| 2 | policy_id | varchar |  |
| 3 | claim_id | varchar |  |
| 4 | policy_type_item_id | varchar |  |
| 5 | policy_type_id | varchar |  |
| 6 | property_id | varchar |  |
| 7 | contact_id | varchar |  |
| 8 | revision_id | char |  |
| 9 | report_id | char |  |
| 10 | location_id | char |  |
| 11 | is_dir | tinyint |  |
| 12 | file_type | varchar |  |
| 13 | file_label | varchar |  |
| 14 | print_state | enum |  |
| 15 | date_to_print | date |  |
| 16 | date_printed | date |  |
| 17 | active | tinyint |  |
| 18 | added_to_zip | tinyint |  |
| 19 | date_added | timestamp |  |
| 20 | email_only | tinyint |  |
| 21 | emailed | tinyint |  |
| 22 | folder_id | char |  |
| 23 | is_photo | tinyint |  |
| 24 | mime_type | varchar |  |
| 25 | batch | varchar |  |
| 26 | print_location | text |  |
| 27 | private | tinyint |  |
| 28 | read_only | tinyint |  |
| 29 | received_metadata | text |  |
| 30 | size | int |  |
| 31 | successful_upload | tinyint |  |
| 32 | virus_scan | tinyint |  |
| 33 | file_title | varchar |  |
| 34 | file_tag | varchar |  |
| 35 | file_description | varchar |  |
| 36 | file_sub_type | enum |  |
| 37 | uploading_to_s3 | tinyint |  |
| 38 | file_url | varchar |  |
| 39 | vendor_upload | text |  |
| 40 | uploaded_by | char |  |
| 41 | date_updated | timestamp |  |
| 42 | esigned | tinyint |  |

## `v_insureds`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 |  | dimension |  |
| 1 | insured_id | char |  |
| 2 | insured_name | varchar |  |
| 3 | contact_type | enum |  |
| 4 | primary_email | varchar |  |
| 5 | primary_phone | varchar |  |
| 6 | address_line_1 | varchar |  |
| 7 | address_line_2 | varchar |  |
| 8 | address_city | varchar |  |
| 9 | address_county | varchar |  |
| 10 | address_state | varchar |  |
| 11 | address_zip | varchar |  |
| 12 | full_address | text |  |
| 13 | gender | varchar |  |
| 14 | doing_business_as | varchar |  |
| 15 | legal_entity_type | varchar |  |
| 16 | date_business_started | varchar |  |
| 17 | terms_conditions_accepted | tinyint |  |
| 18 | edelivery_enabled | tinyint |  |
| 19 | portal_code | varchar |  |
| 20 | system_tags | text |  |
| 21 | date_added | timestamp |  |
| 22 | date_updated | timestamp |  |

## `v_json_property`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 |  | dimension |  |
| 1 | property_id | char |  |
| 2 | revision_id | char |  |
| 3 | date_added | datetime |  |
| 4 | property_json | json |  |

## `v_json_property_item`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 |  | dimension |  |
| 1 | property_item_id | char |  |
| 2 | property_id | char |  |
| 3 | item_order | int |  |
| 4 | property_item_json | json |  |

## `v_json_revision`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 |  | dimension |  |
| 1 | revision_id | char |  |
| 2 | policy_term_id | char |  |
| 3 | policy_id | char |  |
| 4 | revision_date | date |  |
| 5 | commit_date_time | timestamp |  |
| 6 | commit_date | date |  |
| 7 | revision_json | json |  |

## `v_json_revision_item`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 |  | dimension |  |
| 1 | revision_item_id | char |  |
| 2 | revision_id | char |  |
| 3 | item_order | int |  |
| 4 | revision_item_json | json |  |

## `v_logical_catalog`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 | view_field | dimension | Utility view that generates the logical SQL catalog |
| 1 | view_name | varchar | View or Measure name to use in FROM clause |
| 2 | field_num | bigint | Field position in the view when selecting * |
| 3 | field_name | varchar | Name of the field to use in SELECT clause |
| 4 | field_type | varchar | Type of data present in the field |
| 5 | field_description | text | Logical description of the field content or purpose |

## `v_losses_incurred`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 |  | dimension |  |
| 1 | loss_incurred_id | char |  |
| 2 | loss_incurred_item_id | char |  |
| 3 | claim_id | char |  |
| 4 | claim_item_id | char |  |
| 5 | claim_payment_id | char |  |
| 6 | policy_item_name | varchar |  |
| 7 | policy_item_id | char |  |
| 8 | date_incurred | timestamp |  |
| 9 | date_incurred_micro | datetime |  |
| 10 | modified_by | varchar |  |
| 11 | loss_reserved | decimal |  |
| 12 | loss_paid | decimal |  |
| 13 | adjusting_reserved | decimal |  |
| 14 | adjusting_paid | decimal |  |
| 15 | legal_reserved | decimal |  |
| 16 | legal_paid | decimal |  |
| 17 | historical | tinyint |  |
| 18 | date_updated | timestamp |  |

## `v_mcas_system_tags`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 |  | dimension |  |
| 1 | line_id | char |  |
| 2 | line_of_business | varchar |  |
| 3 | line_target_system_tag_value | longtext |  |
| 4 | policy_type_id | char |  |
| 5 | policy_type | varchar |  |
| 6 | policy_type_target_system_tag_value | longtext |  |
| 7 | sub_line_id | char |  |
| 8 | subline_name | varchar |  |
| 9 | subline_target_system_tag_value | longtext |  |
| 10 | policy_type_item_id | char |  |
| 11 | item_name | varchar |  |
| 12 | item_target_system_tag_value | longtext |  |
| 13 | policy_type_item_category | varchar |  |
| 14 | policy_type_item_category_target_system_tag_value | longtext |  |

## `v_notes`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 |  | dimension |  |
| 1 | note_id | char |  |
| 2 | reference_id | char |  |
| 3 | revision_id | char |  |
| 4 | entered_by_id | varchar |  |
| 5 | entered_by_label | varchar |  |
| 6 | date_added | timestamp |  |
| 7 | added_microseconds | int |  |
| 8 | title | varchar |  |
| 9 | contents | mediumtext |  |
| 10 | system_or_user | varchar |  |
| 11 | file_id | char |  |
| 12 | alert_date | datetime |  |
| 13 | alert_displayed | tinyint |  |
| 14 | alert_email | text |  |
| 15 | alert_now | tinyint |  |
| 16 | alert_sent | tinyint |  |
| 17 | alert_status | tinyint |  |
| 18 | event_alert | tinyint |  |
| 19 | event_preset | varchar |  |
| 20 | event_fired | tinyint |  |
| 21 | external_system_reference | varchar |  |

## `v_payment_batches`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 |  | dimension |  |
| 1 | batch_id | char |  |
| 2 | batch_title | char |  |
| 3 | expected_items | int |  |
| 4 | expected_amount | decimal |  |
| 5 | default_paid_amount_source | enum |  |
| 6 | capture_mode | enum |  |
| 7 | creator_contact_id | char |  |
| 8 | batch_date_time | datetime |  |
| 9 | creation_date_time | datetime |  |
| 10 | payment_id | char |  |
| 11 | payor_contact_id | char |  |
| 12 | payment_instrument | enum |  |
| 13 | check_number | char |  |
| 14 | paid_amount | decimal |  |

## `v_payments`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 |  | dimension |  |
| 1 | payment_id | char |  |
| 2 | payor_contact_id | char |  |
| 3 | payment_instrument | enum |  |
| 4 | payment_method_id | varchar |  |
| 5 | payment_interface | enum |  |
| 6 | account_name | varchar |  |
| 7 | masked_number | varchar |  |
| 8 | transaction_amount | decimal |  |
| 9 | transaction_date_time | datetime |  |
| 10 | confirmation_number | varchar |  |
| 11 | entered_by | varchar |  |
| 12 | entry_date_time | datetime |  |
| 13 | date_updated | timestamp |  |
| 14 | invoice_number | varchar |  |
| 15 | check_number | int |  |
| 16 | sweep_check_number | varchar |  |
| 17 | authorization_state | enum |  |
| 18 | vendor_stage | enum |  |
| 19 | vendor_success | tinyint |  |
| 20 | vendor_response_obj | mediumtext |  |
| 21 | vendor_log_obj | mediumtext |  |
| 22 | vendor_message | mediumtext |  |
| 23 | is_commissin_payment | tinyint |  |
| 24 | is_auto_payment | tinyint |  |
| 25 | is_sweep_payment | tinyint |  |
| 26 | completed | tinyint |  |
| 27 | deleted | tinyint |  |
| 28 | voided | tinyint |  |
| 29 | nsf | tinyint |  |
| 30 | printed_to_deposit | tinyint |  |
| 31 | selected_on_deposit | tinyint |  |
| 32 | commission_payment_id | char |  |
| 33 | distribution_obj | mediumtext |  |
| 34 | file_id_list | mediumtext |  |
| 35 | sale_or_credit | varchar |  |

## `v_permission_rules`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 |  | dimension |  |
| 1 | permission_rule_id | char |  |
| 2 | permission_id | char |  |
| 3 | permission_level | varchar |  |
| 4 | access | varchar | dashboard |
| 5 | resource | varchar |  |
| 6 | locked_flag | tinyint |  |

## `v_policy_type_items`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 |  | dimension |  |
| 1 | policy_type_item_id | char |  |
| 2 | policy_type_id | char |  |
| 3 | item_category | enum |  |
| 4 | item_type | enum |  |
| 5 | item_name | varchar |  |
| 6 | subline_name | varchar |  |
| 7 | item_description | varchar |  |
| 8 | subline_description | varchar |  |
| 9 | subline_type | enum |  |
| 10 | item_order | int |  |
| 11 | subline_order | int |  |
| 12 | item_is_default | tinyint |  |
| 13 | item_is_mandatory | tinyint |  |
| 14 | item_allow_multiple | tinyint |  |
| 15 | subline_is_default | tinyint |  |
| 16 | subline_is_mandatory | tinyint |  |
| 17 | subline_allow_mutiple | tinyint |  |
| 18 | subline_editable_name | tinyint |  |
| 19 | disallow_submit_bound | tinyint |  |
| 20 | dec_section | varchar |  |
| 21 | dec_combine_premium | tinyint |  |
| 22 | dec_hide_when_zero | tinyint |  |
| 23 | dec_print_included_when_zero | tinyint |  |
| 24 | dec_exclude_from_rating_info | tinyint |  |
| 25 | dec_limit_and_premium_in_rating_info | tinyint |  |
| 26 | dec_user_inputs_first | tinyint |  |
| 27 | html_formatted_item_name | varchar |  |
| 28 | has_limit | tinyint |  |
| 29 | has_rate | tinyint |  |
| 30 | rate_chain_obj | longtext |  |
| 31 | item_system_tags | text |  |
| 32 | subline_system_tags | text |  |
| 33 | has_loss_payee | tinyint |  |
| 34 | agent_can_add | int |  |
| 35 | agent_cannot_remove | tinyint |  |
| 36 | term_availability | varchar |  |
| 37 | item_visibility | varchar |  |
| 38 | fully_earned | tinyint |  |
| 39 | fully_billed | tinyint |  |
| 40 | round_method | enum |  |
| 41 | decimal_places | bigint |  |
| 42 | round_pro_rata | tinyint |  |
| 43 | commission_excluded | tinyint |  |
| 44 | item_specific_commission | tinyint |  |
| 45 | commission_rate_eval | varchar |  |
| 46 | ignore_term_factor | tinyint |  |
| 47 | dividend_factor | decimal |  |
| 48 | prorate_fee | tinyint |  |
| 49 | item_schedule_obj | longtext |  |
| 50 | in_loss_exposure_group | tinyint |  |
| 51 | loss_free_obj | text |  |
| 52 | not_applicable_for_agency_billing | tinyint |  |
| 53 | submit_unbound_if_limit_exceeds | bigint |  |
| 54 | claim_coverage_party_types | enum |  |
| 55 | default_loss_reserve | decimal |  |
| 56 | default_adjusting_reserve | decimal |  |
| 57 | default_legal_reserve | decimal |  |
| 58 | sub_line_id | char |  |
| 59 | item_external_system_reference | varchar |  |
| 60 | last_synched_date | timestamp |  |
| 61 | item_inheritance_id | char |  |
| 62 | item_reference_id | char |  |

## `v_policy_type_items_forms`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 |  | dimension |  |
| 1 | policy_type_item_form_id | char |  |
| 2 | file_id | char |  |
| 3 | policy_type_item_id | char |  |
| 4 | form_code | varchar |  |
| 5 | form_edition | varchar |  |
| 6 | form_description | varchar |  |
| 7 | category_conditions | mediumtext |  |
| 8 | premium_zero_condition | varchar |  |
| 9 | mortgagee_types_condition | mediumtext |  |
| 10 | do_not_print | tinyint |  |
| 11 | print_every_renewal | tinyint |  |
| 12 | file_name | varchar |  |
| 13 | file_size | int |  |
| 14 | date_added | timestamp |  |

## `v_policy_types`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 |  | dimension |  |
| 1 | effective_id | char |  |
| 2 | lines_effective_date | date |  |
| 3 | lines_effective_description | text |  |
| 4 | location_id | char |  |
| 5 | country | char |  |
| 6 | state | char |  |
| 7 | line_id | char |  |
| 8 | line_of_business | varchar |  |
| 9 | line_system_tags | text |  |
| 10 | policy_type_id | char |  |
| 11 | policy_type | varchar |  |
| 12 | multi_property | tinyint |  |
| 13 | open_to_quoting | tinyint |  |
| 14 | policy_type_system_tags | text |  |

## `v_policy_types_forms`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 |  | dimension |  |
| 1 | policy_type_form_id | char |  |
| 2 | file_id | char |  |
| 3 | policy_type_id | char |  |
| 4 | form_code | varchar |  |
| 5 | form_edition | varchar |  |
| 6 | form_description | varchar |  |
| 7 | mortgagee_types_condition | mediumtext |  |
| 8 | do_not_print | tinyint |  |
| 9 | print_every_renewal | tinyint |  |
| 10 | file_name | varchar |  |
| 11 | file_size | int |  |
| 12 | date_added | timestamp |  |

## `v_properties`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 |  | dimension |  |
| 1 | property_id | char |  |
| 2 | revision_id | char |  |
| 3 | property_name | varchar |  |
| 4 | location_number | int |  |
| 5 | property_group_number | varchar |  |
| 6 | address_line_1 | varchar |  |
| 7 | address_line_2 | varchar |  |
| 8 | address_city | varchar |  |
| 9 | address_state | varchar |  |
| 10 | address_zip | varchar |  |
| 11 | address_country | enum |  |
| 12 | full_address | text |  |
| 13 | address_county | longtext |  |
| 14 | written_premium | decimal |  |
| 15 | written_fee | decimal |  |
| 16 | annual_premium | decimal |  |
| 17 | annual_fee | decimal |  |
| 18 | latitude | decimal |  |
| 19 | longitude | decimal |  |
| 20 | address_accuracy | enum |  |
| 21 | date_added | datetime |  |
| 22 | date_updated | timestamp |  |
| 23 | address_copied_from_insured | tinyint |  |
| 24 | deleted | tinyint |  |
| 25 | fire_district_distance | decimal |  |
| 26 | hydrant_distance | smallint |  |
| 27 | fire_district | mediumtext |  |
| 28 | protection_class | mediumtext |  |
| 29 | gross_area | varchar |  |
| 30 | stories | varchar |  |
| 31 | year_built | varchar |  |
| 32 | replacement_cost | decimal |  |
| 33 | actual_cash_value | varchar |  |

## `v_properties_contacts`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 |  | dimension |  |
| 1 | property_contact_id | char |  |
| 2 | property_id | char |  |
| 3 | contact_id | char |  |
| 4 | relationship | varchar |  |
| 5 | loan_description | varchar |  |
| 6 | loan_number | varchar |  |
| 7 | mortgage_type | varchar |  |
| 8 | dec_mortgage_statement | varchar |  |
| 9 | date_added | timestamp |  |
| 10 | date_updated | timestamp |  |

## `v_property_items`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 |  | dimension |  |
| 1 | property_item_id | char |  |
| 2 | property_id | char |  |
| 3 | revision_id | char |  |
| 4 | sub_line_instance_id | char |  |
| 5 | policy_type_item_id | char |  |
| 6 | item_name | varchar |  |
| 7 | item_type | enum |  |
| 8 | apply_date | date |  |
| 9 | coverage_limit | decimal |  |
| 10 | deductible | decimal |  |
| 11 | written_premium | decimal |  |
| 12 | annual_premium | decimal |  |
| 13 | written_fee | decimal |  |
| 14 | annual_fee | decimal |  |
| 15 | manual_premium_override | tinyint |  |
| 16 | builder_obj | mediumtext |  |
| 17 | questions | text |  |
| 18 | rating_obj | mediumtext |  |
| 19 | date_added | datetime |  |
| 20 | property_date_added | datetime |  |
| 21 | property_deleted | tinyint |  |
| 22 | item_deleted | tinyint |  |
| 23 | date_deleted | datetime |  |
| 24 | deleted_by | varchar |  |
| 25 | date_updated | timestamp |  |
| 26 | item_commission_rate | decimal |  |
| 27 | limit_type | varchar |  |
| 28 | second_limit | decimal |  |
| 29 | second_limit_type | varchar |  |
| 30 | third_limit | decimal |  |
| 31 | third_limit_type | varchar |  |
| 32 | limit_updated | tinyint |  |
| 33 | link_obj | mediumtext |  |
| 34 | loss_exposure_group | int |  |
| 35 | previous_adjustment_amount | decimal |  |
| 36 | persist_status | enum |  |
| 37 | status_reason | varchar |  |
| 38 | previous_property_item_id | char |  |

## `v_recoveries`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 |  | dimension |  |
| 1 | recovery_id | char |  |
| 2 | claim_id | char |  |
| 3 | claim_item_id | char |  |
| 4 | claim_recovery_id | char |  |
| 5 | date_incurred | timestamp |  |
| 6 | modified_by | varchar |  |
| 7 | subrogation_reserved | decimal |  |
| 8 | subrogation_received | decimal |  |
| 9 | salvage_reserved | decimal |  |
| 10 | salvage_received | decimal |  |
| 11 | reinsurance_reserved | decimal |  |
| 12 | reinsurance_received | decimal |  |
| 13 | historical | tinyint |  |
| 14 | date_updated | timestamp |  |

## `v_return_premium`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 |  | dimension |  |
| 1 | return_premium_id | char |  |
| 2 | account_history_id | char |  |
| 3 | address_id | char |  |
| 4 | policy_id | char |  |
| 5 | policy_number | varchar |  |
| 6 | check_number | int |  |
| 7 | return_amount | decimal |  |
| 8 | date_created | datetime |  |
| 9 | date_authorized | timestamp |  |
| 10 | date_exported | timestamp |  |
| 11 | date_cleared | datetime |  |
| 12 | date_updated | timestamp |  |
| 13 | reason | varchar |  |
| 14 | authorized | tinyint |  |
| 15 | exported | tinyint |  |
| 16 | canceled | tinyint |  |
| 17 | to_export | tinyint |  |
| 18 | rejected | tinyint |  |
| 19 | voided | tinyint |  |
| 20 | transferred | tinyint |  |
| 21 | transfer_account_history_id | char |  |
| 22 | payment_id | char |  |
| 23 | check_divert | enum |  |
| 24 | product_description | varchar |  |

## `v_revision_items`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 |  | dimension |  |
| 1 | revision_item_id | char |  |
| 2 | revision_id | char |  |
| 3 | sub_line_instance_id | char |  |
| 4 | policy_type_item_id | char |  |
| 5 | item_name | varchar |  |
| 6 | item_type | enum |  |
| 7 | apply_date | date |  |
| 8 | coverage_limit | decimal |  |
| 9 | deductible | decimal |  |
| 10 | written_premium | decimal |  |
| 11 | annual_premium | decimal |  |
| 12 | written_fee | decimal |  |
| 13 | annual_fee | decimal |  |
| 14 | manual_premium_override | tinyint |  |
| 15 | builder_obj | mediumtext |  |
| 16 | questions | text |  |
| 17 | rating_obj | mediumtext |  |
| 18 | date_added | datetime |  |
| 19 | item_deleted | tinyint |  |
| 20 | date_deleted | datetime |  |
| 21 | deleted_by | varchar |  |
| 22 | date_updated | timestamp |  |
| 23 | item_commission_rate | decimal |  |
| 24 | limit_type | varchar |  |
| 25 | second_limit | decimal |  |
| 26 | second_limit_type | varchar |  |
| 27 | third_limit | decimal |  |
| 28 | third_limit_type | varchar |  |
| 29 | limit_updated | tinyint |  |
| 30 | link_obj | mediumtext |  |
| 31 | loss_exposure_group | int |  |
| 32 | previous_adjustment_amount | decimal |  |
| 33 | persist_status | enum |  |
| 34 | status_reason | varchar |  |
| 35 | previous_revision_item_id | char |  |

## `v_revisions`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 |  | dimension |  |
| 1 | revision_id | char |  |
| 2 | policy_term_id | char |  |
| 3 | policy_id | char |  |
| 4 | policy_type_id | char |  |
| 5 | policy_number | varchar |  |
| 6 | policy_active_flag | tinyint |  |
| 7 | rewritten | tinyint |  |
| 8 | revision_state | enum |  |
| 9 | revision_date | date |  |
| 10 | commit_date_time | timestamp |  |
| 11 | commit_date | date |  |
| 12 | create_date | timestamp |  |
| 13 | date_archived | datetime |  |
| 14 | revision_deleted | tinyint |  |
| 15 | date_updated | timestamp |  |
| 16 | term_effective_date | date |  |
| 17 | term_expiration_date | date |  |
| 18 | term_length_days | int |  |
| 19 | term_length | enum |  |
| 20 | billing_schedule | varchar |  |
| 21 | autopay_flag | int |  |
| 22 | inception_date | date |  |
| 23 | policy_status | varchar |  |
| 24 | policy_status_reason | mediumtext |  |
| 25 | cancellation_category | varchar |  |
| 26 | cancel_date | date |  |
| 27 | reinstated_at_commit | tinyint |  |
| 28 | renewal_status | varchar |  |
| 29 | process_as_renewal | tinyint |  |
| 30 | declaration_prints | tinyint |  |
| 31 | quote_complete | tinyint |  |
| 32 | submitted_bound | tinyint |  |
| 33 | policy_system_tags | text |  |
| 34 | print_description | text |  |
| 35 | additional_description | text |  |
| 36 | commission_rate | decimal |  |
| 37 | manual_commission_flag | tinyint |  |
| 38 | written_premium | decimal |  |
| 39 | written_fees | decimal |  |
| 40 | annual_premium | decimal |  |
| 41 | annual_fees | decimal |  |
| 42 | term_factor | decimal |  |
| 43 | term_premium | decimal |  |
| 44 | term_fees | decimal |  |
| 45 | copied_from_revision_id | char |  |
| 46 | copied_from_policy_number | varchar |  |
| 47 | copied_to_revision_id | char |  |
| 48 | copied_to_policy_number | varchar |  |

## `v_revisions_agencies`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 |  | dimension |  |
| 1 | revision_id | char |  |
| 2 | agency_id | char |  |
| 3 | agent_name | varchar |  |
| 4 | producer_number | varchar |  |
| 5 | agent_id | varchar |  |
| 6 | agency_name | varchar |  |
| 7 | agency_number | varchar |  |
| 8 | true_agency_id | varchar |  |
| 9 | agency_group_name | varchar |  |
| 10 | agency_group_number | varchar |  |
| 11 | agency_group_id | char |  |
| 12 | contact_type | enum |  |
| 13 | primary_email | varchar |  |
| 14 | primary_phone | varchar |  |
| 15 | address_line_1 | varchar |  |
| 16 | address_line_2 | varchar |  |
| 17 | address_city | varchar |  |
| 18 | address_state | varchar |  |
| 19 | address_zip | varchar |  |
| 20 | address_county | varchar |  |
| 21 | address_country | varchar |  |
| 22 | edelivery_enabled | tinyint |  |
| 23 | fein | varchar |  |
| 24 | position | varchar |  |
| 25 | website | varchar |  |
| 26 | contact_background | longtext |  |
| 27 | commission_structure | varchar |  |
| 28 | use_agency_group_commission_structure | tinyint |  |
| 29 | pay_commission_to | enum |  |
| 30 | agency_group_commission_structure | varchar |  |
| 31 | effective_commission_structure | varchar |  |
| 32 | agent_terminated | int |  |
| 33 | termination_reason | varchar |  |
| 34 | agency_inactive_at | datetime |  |
| 35 | agency_inception_date | date |  |
| 36 | agency_termination_date | date |  |
| 37 | permission_level | varchar |  |
| 38 | last_login | datetime |  |
| 39 | system_tags | text |  |
| 40 | date_added | timestamp |  |
| 41 | date_updated | timestamp |  |
| 42 | date_address_updated | timestamp |  |
| 43 | date_phone_updated | timestamp |  |
| 44 | date_email_updated | timestamp |  |

## `v_revisions_contacts`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 |  | dimension |  |
| 1 | revision_contact_id | char |  |
| 2 | revision_id | char |  |
| 3 | contact_id | char |  |
| 4 | relationship | varchar |  |
| 5 | additional_interest | varchar |  |
| 6 | date_added | timestamp |  |
| 7 | date_updated | timestamp |  |

## `v_roles`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 |  | dimension |  |
| 1 | role_id | char |  |
| 2 | role_name | varchar |  |
| 3 | role_type | varchar |  |
| 4 | aspects | text |  |
| 5 | contacts | bigint |  |
| 6 | default_permission_level | varchar |  |
| 7 | date_updated | timestamp |  |

## `v_system_tags`

| # | Field Name | Type | Description |
|---|------------|------|-------------|
| 0 |  | dimension |  |
| 1 | system_tag_id | char |  |
| 2 | system_tag_name | varchar |  |

