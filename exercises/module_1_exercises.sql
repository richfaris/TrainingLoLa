-- =====================================================
-- Module 1 Exercises: Materialized Views - m_inforce_policies
-- =====================================================

-- Exercise 1.1: Basic m_inforce_policies Query
-- ============================================
-- Write a query to see all data in m_inforce_policies
-- Limit to 10 results to avoid overwhelming output

-- Your query here:
-- SELECT ...

-- Exercise 1.2: Simple Policy Report
-- ==================================
-- Create a basic policy report showing:
-- Include: state, policy_type, policy_number, inforce_premium
-- Join m_inforce_policies with v_policy_types and v_revisions
-- Order by inforce_premium descending
-- Limit to 10 results

-- Your query here:
-- SELECT ...

-- Exercise 1.3: Policy Count by State
-- ===================================
-- Count how many policies exist in each state
-- Join m_inforce_policies with v_policy_types
-- Group by state
-- Order by policy count descending

-- Your query here:
-- SELECT ...

-- Exercise 1.4: Premium Analysis by Policy Type
-- =============================================
-- Analyze premium amounts by policy type
-- Show: policy_type, policy_count, total_premium, avg_premium
-- Join m_inforce_policies with v_policy_types
-- Group by policy_type
-- Order by total_premium descending

-- Your query here:
-- SELECT ...

-- Exercise 1.5: Policy with Address Information
-- ============================================
-- Create a report showing policies with their addresses
-- Include: state, policy_type, policy_number, full_address
-- Join m_inforce_policies, v_policy_types, v_revisions, and v_properties
-- Use GROUP BY to handle multiple properties per policy
-- Limit to 10 results

-- Your query here:
-- SELECT ...

-- =====================================================
-- Challenge Exercise: Advanced Policy Analysis
-- =====================================================
-- Create a comprehensive policy analysis showing:
-- 1. Policy count and total premium by state and policy type
-- 2. Average premium by policy type
-- 3. Policy distribution across states
-- 4. Premium range analysis (min, max, avg)

-- Your comprehensive query here:
-- SELECT ...

-- =====================================================
-- Solutions (Remove the -- before each query to see the answer)
-- =====================================================

-- Solution 1.1:
SELECT * FROM m_inforce_policies LIMIT 10;

-- Solution 1.2:
SELECT 
    t.state,
    t.policy_type,
    r.policy_number,
    i.inforce_premium
FROM m_inforce_policies i
JOIN v_policy_types t ON t.policy_type_id = i.policy_type_id
JOIN v_revisions r ON r.revision_id = i.revision_id
ORDER BY i.inforce_premium DESC
LIMIT 10;

-- Solution 1.3:
SELECT 
    t.state,
    COUNT(*) as policy_count
FROM m_inforce_policies i
JOIN v_policy_types t ON t.policy_type_id = i.policy_type_id
GROUP BY t.state
ORDER BY policy_count DESC;

-- Solution 1.4:
SELECT 
    t.policy_type,
    COUNT(*) as policy_count,
    SUM(i.inforce_premium) as total_premium,
    ROUND(AVG(i.inforce_premium), 2) as avg_premium
FROM m_inforce_policies i
JOIN v_policy_types t ON t.policy_type_id = i.policy_type_id
GROUP BY t.policy_type
ORDER BY total_premium DESC;

-- Solution 1.5:
SELECT 
    t.state,
    t.policy_type,
    r.policy_number,
    MIN(l.full_address) AS full_address
FROM m_inforce_policies i
JOIN v_policy_types t ON t.policy_type_id = i.policy_type_id
JOIN v_revisions r ON r.revision_id = i.revision_id
JOIN v_properties l ON l.revision_id = i.revision_id
GROUP BY t.state, t.policy_type, r.policy_number
LIMIT 10;

-- Solution Challenge:
SELECT 
    t.state,
    t.policy_type,
    COUNT(*) as policy_count,
    SUM(i.inforce_premium) as total_premium,
    ROUND(AVG(i.inforce_premium), 2) as avg_premium,
    MIN(i.inforce_premium) as min_premium,
    MAX(i.inforce_premium) as max_premium
FROM m_inforce_policies i
JOIN v_policy_types t ON t.policy_type_id = i.policy_type_id
GROUP BY t.state, t.policy_type
ORDER BY total_premium DESC;
