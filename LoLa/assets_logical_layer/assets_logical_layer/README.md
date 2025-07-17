# Logical Layer Assets


## 1. Assets

### Functions (UDFs)
- Location: `assets_logical_layer/00_functions/`
- Type: SQL FUNCTION
- Filename convention: `<run_order>_<function_name>.sql`
- Example: `assets_logical_layer/01_functions/00_bc_count_str.sql`

### Stored Procedures
- Location: `assets_logical_layer/01_procedures/`
- Type: SQL PROCEDURE
- Filename convention: `<run_order>_<procedure_name>.sql`
- Example: `assets_logical_layer/01_procedures/00_build_measure.sql`

### Views
- Location: `assets_logical_layer/02_views/`
- Type: SQL VIEW
- Filename convention: `<run_order>_v_<view_name>.sql`
- Example:
  - `assets_logical_layer/02_views/00_v_properties.sql`
  - `assets_logical_layer/02_views/01_v_revisions_agencies.sql`

### Templates
- Location: `assets_logical_layer/03_templates/`
- Type: SQL VIEW
- Filename convention: `<run_order>_t_<template_name>.sql`
- Example: `assets_logical_layer/03_templates/00_t_accounting_terms.sql`

### Events
- Location: `assets_logical_layer/04_events/`
- Type: SQL EVENT
- Filename convention: `<run_order>_<event_name>.sql`
- Example: `assets_logical_layer/04_events/00_drop_expired_measures_nightly.sql`


## 2. Deployment Sequence

### Deployment sequence by asset type
The deployment sequence by type of the asset is defined in the following order:
  1. Functions
  2. Procedures
  3. Views
  4. Templates
  5. Events

Based on current order, an asset in `Templates` is always deployed before an asset in `Views`.

### Deployment sequence for same asset type
The `<run_order>` value on a asset filename indicates the order in which the assets are deployed from each directory.
- If you want to create a view in `assets_logical_layer/02_views/` that doesn't depend on any other views, you would name the file `00_v_<view_name>.sql`
- If you want to create a view in `assets_logical_layer/02_views/` that depends on a view called `00_v_<view_name>.sql` in the same directory, you would give the view a higher run_order, i.e. `01_v_<view_name>.sql`, so it will be deployed after the view it depends on.
- We currently only allow 2-digits for the run_order. If there is a need for more, please reach out to Data team.


## 3. Decrypting Values for JSON Reports
Certain JSON Views, eg `02_views/03_v_json_revision.sql`, can output encrypted values, eg contacts.dob (date of birth), in plain text.
To accomplish this, the following steps must first be taken on the customer's database:
  1. Tunnel onto the s'more of the client who needs decrypted values in a JSON Report
  2. Get into a Python REPL and retrieve the plaintext of the KRYPT_KEY, eg:
  ```
  sudo -iu ubuntu
  bc
  direnv allow
  source .venv3/bin/activate
  python
  import sys
  sys.path.append('lib')
  from core.utils import KRYPT_KEY
  KRYPT_KEY
  ```
  3. Once you have the KRYPT_KEY value, then run the following on the DB:

  > `select bc_decrypt('Configure|THE_KRYPT_KEY_VALUE');`

  4. This will return an encrypted copy of the encryption key for you to store in the DB

  > `insert into custom_data (id, name, value) values (uuid(), 'lola_bc_decrypt_value', 'the_encrypted_key');`

  5. Once this insert has been completed, you can then decrypt any PII field as follows:

  > `select bc_decrypt(dob) from contacts where dob is not null limit 1;`

**Note Well** at this point decrypted fields should only be provided to `v_json_` views as those results
are not Indexed/Stored in Attachments.  At a future date we may add PII detection to other report formats
(eg CSV) so that carriers can export data that includes PII without those results being stored in plain-text
downloadable links under Reports/Attachments.

## 4. Excel HYPERLINKs
While you *can* create an Excel HYPERLINK by using `concat('=HYPERLINK("...", "...")')`, we have also included a helper
function, `bc_excel_link(relative_url, link_text)` which will automatically retrieve the carrier's base-hostname from
`settings.option = 'report-link-hostname-override'` and build out the Excel formula for you, eg:
> `select bc_excel_link(concat('britecore/policies/builder?policyId=', r.policy_id), r.policy_number) from v_revisions r`.
