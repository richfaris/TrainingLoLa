/* v_claims_dates [claim_dates] */
create or replace algorithm = merge view v_claims_dates as
select
  `claimId` claim_id,
  `date` claim_date,
  `type` date_type
from claim_dates d
;
