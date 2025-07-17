/* v_policy_change_log */
create or replace algorithm = merge view v_policy_change_log as
select
  id policy_change_log_id,
  policyId policy_id,
  revisionId revision_id,
  propertyId property_id,
  contactId contact_id,
  dateCursor date_cursor,
  dateStamp date_added,
  dateUpdated date_updated,
  deleted log_deleted,
  dirty log_dirty,
  transaction policy_change_log_type
from policy_change_log
;
