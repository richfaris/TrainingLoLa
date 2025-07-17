# I need the dollar value and number of transactions by customer paid on:
# Return premiums
# Commissions
# Claims
# Ideally, if I could get a spreadsheet of all payments showing for a period of 12 months, that would do the trick:
# Customer Name | Date Time | Payout Type | Payee | Payee Type (optional) | Amount
# Payout Type = return premium, commission or claims
# Payee Type = agency, insured, claimant/loss payee, claims legal payee, claims adjusting payee, etc.
#
#
-- Unified Payout Summary: Return Premiums, Commissions, Claims (Last 12 Months)

-- Note: Adjust `p.customerId` if needed — use actual link from policy to customer

-- Unified Payout Summary: Return Premiums, Commissions, Claims (Last 12 Months)
-- All joins use views only (v_ prefixed)

-- RETURN PREMIUMS
SELECT 
  c.contact_name AS `Customer Name`,
  rp.date_exported AS `Date Time`,
  'Return Premium' AS `Payout Type`,
  c.contact_name AS `Payee`,
  c.contact_type AS `Payee Type`,
  rp.return_amount AS `Amount`
FROM v_return_premium rp
LEFT JOIN v_revisions r ON r.policy_id = rp.policy_id
LEFT JOIN v_contacts c ON c.contact_id = r.contact_id
WHERE rp.date_exported >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)

UNION ALL

-- COMMISSION PAYMENTS
SELECT 
  c.contact_name AS `Customer Name`,
  cp.transaction_date AS `Date Time`,
  'Commission' AS `Payout Type`,
  c.contact_name AS `Payee`,
  c.contact_type AS `Payee Type`,
  cp.payment_amount AS `Amount`
FROM v_commission_payments cp
LEFT JOIN v_contacts c ON c.contact_id = cp.payee_contact_id
WHERE cp.transaction_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)

UNION ALL

-- CLAIM PAYMENTS
SELECT 
  NULL AS `Customer Name`,
  clp.date_entered AS `Date Time`,
  'Claim' AS `Payout Type`,
  clp.pay_to AS `Payee`,
  clp.payment_classification AS `Payee Type`,
  clp.payment_amount AS `Amount`
FROM v_claim_payments clp
WHERE clp.date_entered >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH);