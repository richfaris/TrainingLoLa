-- =====================================================
-- Module 3 Exercises: Policy Types and Property Data
-- =====================================================

-- Exercise 3.1: Basic Policy Type Analysis
-- ==========================================
-- Write a query to retrieve all policy types
-- Include: policy_type, line_of_business, and state
-- Order by policy type

-- Your query here:
-- SELECT ...

-- Exercise 3.2: Policy Types by Line of Business
-- ===================================
-- Find all lines of business and count how many policy types use each line
-- Show the line of business and policy type count
-- Only include lines that have policy types
-- Order by count descending

-- Your query here:
-- SELECT ...

-- Exercise 3.3: Policy Types with Most Policies
-- =============================================
-- Join v_policy_types with v_revisions to see which policy types have the most policies
-- Show policy type and policy count
-- Only include active policy types
-- Order by policy count descending

-- Your query here:
-- SELECT ...

-- Exercise 3.4: Property Analysis
-- ===============================
-- Find all properties and their characteristics
-- Include: property_id, property_name, address_city, address_state
-- Only show active properties
-- Limit to 10 results

-- Your query here:
-- SELECT ...

-- Exercise 3.5: Properties by Year Built
-- =============================================
-- Find all years built and count properties for each year
-- Show year built and property count
-- Only include years that have properties (not NULL)
-- Order by property count descending

-- Your query here:
-- SELECT ...

-- =====================================================
-- Challenge Exercise: Policy Portfolio Analysis
-- =====================================================
-- Create a comprehensive policy portfolio analysis showing:
-- 1. Policy types with their policy counts
-- 2. Properties by policy type
-- 3. Geographic distribution of properties
-- 4. Construction type analysis

-- Your comprehensive query here:
-- SELECT ...

-- =====================================================
-- Solutions (Remove the -- before each query to see the answer)
-- =====================================================

-- Solution 3.1:
SELECT policy_type, line_of_business, state
FROM v_policy_types
ORDER BY policy_type;

-- Solution 3.2:
SELECT line_of_business, COUNT(*) as policy_type_count
FROM v_policy_types
GROUP BY line_of_business
ORDER BY policy_type_count DESC;

-- Solution 3.3:
SELECT 
    pt.policy_type,
    COUNT(r.revision_id) as policy_count
FROM v_policy_types pt
LEFT JOIN v_revisions r ON pt.policy_type_id = r.policy_type_id
GROUP BY pt.policy_type
ORDER BY policy_count DESC;

-- Solution 3.4:
SELECT property_id, property_name, address_city, address_state
FROM v_properties
WHERE deleted = 0
LIMIT 10;

-- Solution 3.5:
SELECT year_built, COUNT(*) as property_count
FROM v_properties
WHERE deleted = 0 AND year_built IS NOT NULL
GROUP BY year_built
ORDER BY property_count DESC;

-- Solution Challenge:
SELECT 
    pt.policy_type,
    COUNT(DISTINCT r.revision_id) as policy_count,
    COUNT(DISTINCT prop.property_id) as property_count,
    COUNT(DISTINCT prop.address_city) as cities_covered
FROM v_policy_types pt
LEFT JOIN v_revisions r ON pt.policy_type_id = r.policy_type_id
LEFT JOIN v_properties prop ON r.revision_id = prop.revision_id
WHERE prop.deleted = 0
GROUP BY pt.policy_type
ORDER BY policy_count DESC; 