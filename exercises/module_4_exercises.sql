-- =====================================================
-- Module 4 Exercises: Financial Data Analysis
-- =====================================================

-- Exercise 4.1: Basic Payment Analysis
-- ==========================================
-- Write a query to retrieve the first 10 completed payments
-- Include: payment_id, transaction_amount, transaction_date_time, payment_instrument, invoice_number
-- Order by transaction date descending

-- Your query here:
-- SELECT ...

-- Exercise 4.2: Payments by Method
-- ===================================
-- Find all payment instruments and count payments for each method
-- Show payment instrument, payment count, and total amount
-- Only include completed payments
-- Order by total amount descending

-- Your query here:
-- SELECT ...

-- Exercise 4.3: Monthly Revenue Analysis
-- ======================================
-- Find monthly revenue for the current year
-- Show month (YYYY-MM format), payment count, and total revenue
-- Only include completed payments
-- Order by month descending

-- Your query here:
-- SELECT ...

-- Exercise 4.4: Commission Analysis
-- ===================================
-- Find all agents and their commission totals
-- Show agent name and total commission amount
-- Only include paid commissions
-- Order by total commission descending

-- Your query here:
-- SELECT ...

-- Exercise 4.5: Payment Method Analysis
-- =============================================
-- Group payments by payment instrument to see revenue by payment method
-- Show payment instrument, payment count, and total revenue
-- Only include completed payments
-- Order by total revenue descending

-- Your query here:
-- SELECT ...

-- =====================================================
-- Challenge Exercise: Financial Dashboard
-- =====================================================
-- Create a comprehensive financial dashboard showing:
-- 1. Total revenue
-- 2. Revenue by payment method
-- 3. Monthly revenue trends
-- 4. Top earning agents
-- 5. Revenue by payment method

-- Your comprehensive query here:
-- SELECT ...

-- =====================================================
-- Solutions (Remove the -- before each query to see the answer)
-- =====================================================

-- Solution 4.1:
SELECT payment_id, transaction_amount, transaction_date_time, payment_instrument, invoice_number
FROM v_payments
WHERE completed = 1
ORDER BY transaction_date_time DESC
LIMIT 10;

-- Solution 4.2:
SELECT 
    payment_instrument,
    COUNT(*) as payment_count,
    SUM(transaction_amount) as total_amount
FROM v_payments
WHERE completed = 1
GROUP BY payment_instrument
ORDER BY total_amount DESC;

-- Solution 4.3:
SELECT 
    DATE_FORMAT(transaction_date_time, '%Y-%m') as payment_month,
    COUNT(*) as payment_count,
    SUM(transaction_amount) as monthly_revenue
FROM v_payments
WHERE completed = 1
  AND YEAR(transaction_date_time) = YEAR(CURDATE())
GROUP BY DATE_FORMAT(transaction_date_time, '%Y-%m')
ORDER BY payment_month DESC;

-- Solution 4.4:
SELECT 
    con.contact_name as agent_name,
    SUM(cd.commission_amount) as total_commission
FROM v_commission_details cd
JOIN v_contacts con ON cd.agency_id = con.contact_id
GROUP BY con.contact_name
ORDER BY total_commission DESC;

-- Solution 4.5:
SELECT 
    payment_instrument,
    COUNT(payment_id) as payment_count,
    SUM(transaction_amount) as total_revenue
FROM v_payments
WHERE completed = 1
GROUP BY payment_instrument
ORDER BY total_revenue DESC;

-- Solution Challenge (Single Query with Subqueries):
SELECT 
    (SELECT SUM(transaction_amount) FROM v_payments WHERE completed = 1) as total_revenue,
    (SELECT SUM(transaction_amount) FROM v_payments WHERE completed = 1 AND payment_instrument = 'Credit Card') as credit_card_revenue,
    (SELECT SUM(transaction_amount) FROM v_payments WHERE completed = 1 AND DATE_FORMAT(transaction_date_time, '%Y-%m') = DATE_FORMAT(CURDATE(), '%Y-%m')) as revenue_this_month,
    (SELECT SUM(cd.commission_amount) FROM v_commission_details cd WHERE cd.agency_id = (
        SELECT agency_id FROM v_commission_details GROUP BY agency_id ORDER BY SUM(commission_amount) DESC LIMIT 1
    )) as top_agent_commission,
    (SELECT SUM(transaction_amount) FROM v_payments WHERE completed = 1 AND payment_instrument = 'Credit Card') as auto_policy_revenue; 