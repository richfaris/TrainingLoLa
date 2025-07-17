/* v_payment_batches - payment_batches + payment_entries */
create or replace algorithm = merge view v_payment_batches as
select
  b.id batch_id,
  b.title batch_title,
  b.expectedItemsCount expected_items,
  b.expectedTotalAmount expected_amount,
  b.defaultPaidAmountSource default_paid_amount_source,
  b.captureMode capture_mode,
  b.creatorId creator_contact_id,
  b.batchDatetime batch_date_time,
  b.creationDatetime creation_date_time,
  e.paymentId payment_id,
  e.payorId payor_contact_id,
  e.paymentInstrument payment_instrument,
  e.checkNumber check_number,
  e.paidAmount paid_amount
from payment_batches b
left join payment_entries e on e.batchId = b.id
;
