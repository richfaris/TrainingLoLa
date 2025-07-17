/* v_notes */
create or replace algorithm = merge view v_notes as
select
  id note_id,
  referenceId reference_id,
  revisionId revision_id,
  enteredById entered_by_id,
  enteredBy entered_by_label,
  date date_added,
  dateMicro added_microseconds,
  title,
  contents,
  generation system_or_user,
  fileId file_id,
  alertDate alert_date,
  alertDisplayed alert_displayed,
  alertEmail alert_email,
  alertNow alert_now,
  alertSent alert_sent,
  alertStatus alert_status,
  eventAlert event_alert,
  eventPreset event_preset,
  eventFired event_fired,
  externalSystemReference external_system_reference
from notes
;
