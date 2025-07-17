/* v_payment_methods - payment methods view excluding encrypted personal information */
create or replace algorithm = merge view v_payment_methods as
select
  id payment_method_id,
  nullif(trim(accountDescription), '') account_description,
  accountHash account_hash,
  nullif(trim(accountName), '') account_name,
  nullif(trim(accountType), '') account_type,
  active,
  -- Excluding encrypted Kryptonite fields:
  -- address_city, address_line1, address_line2, address_state, address_zip, address_country
  nullif(trim(addressLine2), '') address_line_2, -- This is VARCHAR, not Kryptonite
  nullif(trim(companyOnAccount), '') company_on_account,
  contactId contact_id,
  nullif(trim(customerProfileId), '') customer_profile_id,
  dateUpdated date_updated,
  -- Excluding expire_date (Kryptonite encrypted)
  nullif(trim(maskedNumber), '') masked_number,
  nullif(trim(maskedRouting), '') masked_routing,
  `method` payment_method,
  -- Excluding name_on_account (Kryptonite encrypted)
  primaryAccount is_primary_account,
  sameAddress same_address_flag,
  updatedOn updated_on,
  nullif(trim(vendor), '') vendor,
  vendorId vendor_id,
  integrationInstanceId integration_instance_id,
  nullif(trim(vendorPaymentMethodId), '') vendor_payment_method_id,
  vendorLog vendor_log_obj
from payment_methods
;
