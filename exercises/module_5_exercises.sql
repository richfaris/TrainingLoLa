-- =====================================================
-- Module 5 Exercises: Advanced Analytics
-- =====================================================
-- 
-- 🚧 UNDER CONSTRUCTION 🚧
-- 
-- This module is currently being developed and tested. The exercises below may not work correctly 
-- with the current BriteCore view structure. We will complete this module once we have verified 
-- all field mappings and relationships.
-- 
-- =====================================================

-- Exercise 5.1: Multi-View JOIN
-- ==========================================
-- Write a query to join v_claims with v_policy_types and v_contacts
-- Include: claim_number, claim_status, policy_type, and insured_name
-- Only show active claims
-- Limit to 10 results

-- Your query here:
-- SELECT ...

-- Exercise 5.2: Agent Performance Analysis
-- =========================================
-- Create a comprehensive agent performance report
-- Include: agent_name, policy_count, total_revenue, claim_count
-- Join v_contacts (agents), v_revisions, v_payments, and v_claims
-- Only include active agents and completed payments
-- Order by total revenue descending

-- Your query here:
-- SELECT ...

-- Exercise 5.3: Geographic Risk Analysis
-- =======================================
-- Analyze claims by geographic location
-- Join v_claims with v_properties to see claim rates by city
-- Show city, property_count, claim_count, and claim_rate
-- Only include cities with more than 5 properties
-- Order by claim rate descending

-- Your query here:
-- SELECT ...

-- Exercise 5.4: Policy Portfolio Analysis
-- =======================================
-- Create a comprehensive policy portfolio analysis
-- Join v_policy_types, v_revisions, v_claims, and v_payments
-- Show policy_type, policy_count, claim_count, total_revenue, claim_frequency
-- Calculate claim frequency as (claims/policies * 100)
-- Order by total revenue descending

-- Your query here:
-- SELECT ...

-- Exercise 5.5: Executive Dashboard
-- ==================================
-- Create an executive summary dashboard using UNION ALL
-- Include: Total Policies, Active Claims, Total Revenue, Active Agents, Properties Insured
-- Use appropriate views for each metric

-- Your query here:
-- SELECT ...

-- =====================================================
-- Challenge Exercise: Advanced Business Intelligence
-- =====================================================
-- Create a comprehensive business intelligence report showing:
-- 1. Agent performance rankings
-- 2. Policy type profitability analysis
-- 3. Geographic risk assessment
-- 4. Claims vs revenue correlation
-- 5. Monthly trends analysis

-- Your comprehensive query here:
-- SELECT ...

-- =====================================================
-- Solutions (Remove the -- before each query to see the answer)
-- =====================================================

-- Solution 5.1:
SELECT 
    c.claim_number,
    c.claim_status,
    pt.policy_type,
    con.contact_name as insured_name
FROM v_claims c
JOIN v_policy_types pt ON c.policy_type_id = pt.policy_type_id
JOIN v_claims_contacts cc ON c.claim_id = cc.claim_id AND cc.relationship = 'named_insured'
JOIN v_contacts con ON cc.contact_id = con.contact_id
WHERE c.claim_active_flag = 1
ORDER BY c.loss_date DESC
LIMIT 10;

-- Solution 5.2:
SELECT 
    agent.contact_name as agent_name,
    COUNT(DISTINCT r.revision_id) as policy_count,
    SUM(p.transaction_amount) as total_revenue,
    COUNT(c.claim_id) as claim_count
FROM v_contacts agent
LEFT JOIN v_revisions_contacts rc ON agent.contact_id = rc.contact_id AND rc.relationship = 'agency'
LEFT JOIN v_revisions r ON rc.revision_id = r.revision_id
LEFT JOIN v_payments p ON r.policy_number = p.invoice_number
LEFT JOIN v_claims c ON r.revision_id = c.revision_id
WHERE agent.roles LIKE '%agent%' 
  AND agent.deleted = 0
  AND p.completed = 1
GROUP BY agent.contact_name
ORDER BY total_revenue DESC;

-- Solution 5.3:
SELECT 
    prop.address_city as city,
    COUNT(DISTINCT prop.property_id) as property_count,
    COUNT(c.claim_id) as claim_count,
    ROUND(COUNT(c.claim_id) / COUNT(DISTINCT prop.property_id) * 100, 2) as claim_rate
FROM v_properties prop
LEFT JOIN v_claims c ON prop.property_id = c.property_id
WHERE prop.address_city IS NOT NULL
  AND prop.deleted = 0
GROUP BY prop.address_city
HAVING property_count > 5
ORDER BY claim_rate DESC;

-- Solution 5.4:
SELECT 
    pt.policy_type,
    COUNT(DISTINCT r.revision_id) as policy_count,
    COUNT(DISTINCT c.claim_id) as claim_count,
    SUM(CASE WHEN p.completed = 1 THEN p.transaction_amount ELSE 0 END) as total_revenue,
    ROUND(COUNT(DISTINCT c.claim_id) / COUNT(DISTINCT r.revision_id) * 100, 2) as claim_frequency
FROM v_policy_types pt
LEFT JOIN v_revisions r ON pt.policy_type_id = r.policy_type_id
LEFT JOIN v_claims c ON r.revision_id = c.revision_id
LEFT JOIN v_payments p ON r.policy_number = p.invoice_number
WHERE pt.active = 1
GROUP BY pt.policy_type
ORDER BY total_revenue DESC;

-- Solution 5.5:
SELECT 'Total Policies' as metric,
    COUNT(DISTINCT r.revision_id) as value
FROM v_revisions r
WHERE r.active = 1
UNION ALL
SELECT 'Active Claims',
    COUNT(DISTINCT c.claim_id)
FROM v_claims c
WHERE c.claim_active_flag = 1
UNION ALL
SELECT 'Total Revenue',
    SUM(p.transaction_amount)
FROM v_payments p
WHERE p.completed = 1
UNION ALL
SELECT 'Active Agents',
    COUNT(DISTINCT con.contact_id)
FROM v_contacts con
WHERE con.roles LIKE '%agent%' AND con.deleted = 0
UNION ALL
SELECT 'Properties Insured',
    COUNT(DISTINCT prop.property_id)
FROM v_properties prop
WHERE prop.deleted = 0;

-- Solution Challenge:
SELECT 
    'Agent Performance Rankings' as analysis_type,
    agent.contact_name as agent_name,
    COUNT(DISTINCT r.revision_id) as policies_written,
    SUM(p.transaction_amount) as total_revenue,
    ROUND(SUM(cd.commission_amount), 2) as total_commission
FROM v_contacts agent
LEFT JOIN v_revisions_contacts rc ON agent.contact_id = rc.contact_id AND rc.relationship = 'agency'
LEFT JOIN v_revisions r ON rc.revision_id = r.revision_id
LEFT JOIN v_payments p ON r.policy_number = p.invoice_number
LEFT JOIN v_commission_details cd ON agent.contact_id = cd.agency_id
WHERE agent.roles LIKE '%agent%' 
  AND agent.deleted = 0
  AND p.completed = 1
GROUP BY agent.contact_name
ORDER BY total_revenue DESC
LIMIT 10; 