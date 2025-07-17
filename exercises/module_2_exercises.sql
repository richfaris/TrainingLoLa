-- =====================================================
-- Module 2 Exercises: Claims Analysis
-- =====================================================

-- Exercise 2.1: Basic Claims Data Retrieval
-- ==========================================
-- Write a query to retrieve the first 10 claims
-- Include: claim_number, claim_status, claim_type, loss_date, and description
-- Only show active claims

-- Your query here:
-- SELECT ...

-- Exercise 2.2: Claims Status Analysis
-- ====================================
-- Find all claim statuses and count how many claims are in each status
-- Show the status name and count
-- Order by count descending

-- Your query here:
-- SELECT ...

-- Exercise 2.3: Claims by Loss Cause
-- ===================================
-- Find all loss causes and count claims for each cause
-- Only include causes that have claims (not NULL)
-- Show the loss cause and claim count
-- Order by count descending

-- Your query here:
-- SELECT ...

-- Exercise 2.4: Claims by Month
-- =============================
-- Find how many claims occurred each month in the current year
-- Show the month (YYYY-MM format) and claim count
-- Order by month descending

-- Your query here:
-- SELECT ...

-- Exercise 2.5: Claims vs Policy Types
-- ====================================
-- Join v_claims with v_policy_types to see claims by policy type
-- Show policy type and claim count
-- Only include active claims
-- Order by claim count descending

-- Your query here:
-- SELECT ...

-- =====================================================
-- Challenge Exercise: Claims Dashboard
-- =====================================================
-- Create a comprehensive claims dashboard showing:
-- 1. Total active claims
-- 2. Open claims count
-- 3. Claims this year
-- 4. Claims this month
-- 5. Most common loss cause

-- Your comprehensive query here:
-- SELECT ...

-- =====================================================
-- Solutions (Remove the -- before each query to see the answer)
-- =====================================================

-- Solution 2.1:
SELECT claim_number, claim_status, claim_type, loss_date, description
FROM v_claims
WHERE claim_active_flag = 1
LIMIT 10;

-- Solution 2.2:
SELECT claim_status, COUNT(*) as claim_count
FROM v_claims
WHERE claim_active_flag = 1
GROUP BY claim_status
ORDER BY claim_count DESC;

-- Solution 2.3
SELECT loss_cause, COUNT(*) as claim_count
FROM v_claims
WHERE claim_active_flag = 1 AND loss_cause IS NOT NULL
GROUP BY loss_cause
ORDER BY claim_count DESC;

-- Solution 2.4:
SELECT 
    DATE_FORMAT(loss_date, '%Y-%m') as loss_month,
    COUNT(*) as claim_count
FROM v_claims
WHERE claim_active_flag = 1  AND loss_date IS NOT NULL
  AND YEAR(loss_date) = YEAR(CURDATE())
GROUP BY DATE_FORMAT(loss_date, '%Y-%m')
ORDER BY loss_month DESC;

-- Solution 2.5:
SELECT 
    pt.policy_type,
    COUNT(c.claim_id) as claim_count
FROM v_claims c
JOIN v_policy_types pt ON c.policy_type_id = pt.policy_type_id
WHERE c.claim_active_flag = 1
GROUP BY pt.policy_type
ORDER BY claim_count DESC;

-- Solution Challenge:
SELECT
  (SELECT COUNT(*) FROM v_claims WHERE claim_active_flag = 1) AS total_active_claims,
  (SELECT COUNT(*) FROM v_claims WHERE claim_active_flag = 1 AND claim_status = 'open') AS open_claims,
  (SELECT COUNT(*) FROM v_claims WHERE claim_active_flag = 1 AND YEAR(loss_date) = YEAR(CURDATE())) AS claims_this_year,
  (SELECT COUNT(*) FROM v_claims WHERE claim_active_flag = 1 AND DATE_FORMAT(loss_date, '%Y-%m') = DATE_FORMAT(CURDATE(), '%Y-%m')) AS claims_this_month,
  (SELECT loss_cause FROM v_claims
    WHERE claim_active_flag = 1 AND loss_cause IS NOT NULL
    GROUP BY loss_cause
    ORDER BY COUNT(*) DESC
    LIMIT 1) AS most_common_loss_cause,
  (SELECT COUNT(*) FROM v_claims
    WHERE claim_active_flag = 1
      AND loss_cause = (
          SELECT loss_cause FROM v_claims
          WHERE claim_active_flag = 1 AND loss_cause IS NOT NULL
          GROUP BY loss_cause
          ORDER BY COUNT(*) DESC
          LIMIT 1
      )) AS most_common_loss_cause_count;
