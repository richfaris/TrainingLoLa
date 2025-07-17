-- =====================================================
-- Module 2 Exercises: Introduction to BriteCore Views
-- =====================================================

-- Exercise 2.1: Basic Contact Data Retrieval
-- ==========================================
-- Write a query to retrieve the first 10 contacts with their basic information
-- Include: contact_id, contact_name, contact_type, and primary_email
-- Only show active contacts (not deleted)

-- Your query here:
-- SELECT ...

-- Exercise 2.2: Contact Filtering
-- ===============================
-- Find all contacts who are organizations (not individuals)
-- Show their name, email, and full address
-- Limit to 5 results

-- Your query here:
-- SELECT ...

-- Exercise 2.3: Contact Search
-- ============================
-- Search for contacts whose name contains "Smith"
-- Show their name, type, and primary phone
-- Order by contact name alphabetically

-- Your query here:
-- SELECT ...

-- Exercise 2.4: Geographic Analysis
-- =================================
-- Find all contacts in California (CA)
-- Count how many are individuals vs organizations
-- Show the count for each type

-- Your query here:
-- SELECT ...

-- Exercise 2.5: Role Analysis
-- ===========================
-- Find all contacts who have the role "agent"
-- Show their name, email, and roles
-- Only include active contacts

-- Your query here:
-- SELECT ...

-- =====================================================
-- Challenge Exercise: Contact Summary Report
-- =====================================================
-- Create a summary report showing:
-- 1. Total number of active contacts
-- 2. Breakdown by contact type (individual vs organization)
-- 3. Top 5 states by number of contacts
-- 4. Number of contacts with email addresses

-- Your comprehensive query here:
-- SELECT ...

-- =====================================================
-- Solutions (Remove the -- before each query to see the answer)
-- =====================================================

-- Solution 2.1:
SELECT contact_id, contact_name, contact_type, primary_email
FROM v_contacts
WHERE deleted = 0
LIMIT 10;

-- Solution 2.2:
SELECT contact_name, primary_email, full_address
FROM v_contacts
WHERE contact_type = 'organization' AND deleted = 0
LIMIT 5;

-- Solution 2.3:
SELECT contact_name, contact_type, primary_phone
FROM v_contacts
WHERE contact_name LIKE '%Smith%' AND deleted = 0
ORDER BY contact_name;

-- Solution 2.4:
SELECT contact_type, COUNT(*) as contact_count
FROM v_contacts
WHERE address_state = 'CA' AND deleted = 0
GROUP BY contact_type;

-- Solution 2.5:
SELECT contact_name, primary_email, roles
FROM v_contacts
WHERE roles LIKE '%agent%' AND deleted = 0;

-- Solution Challenge:
SELECT
    (SELECT COUNT(*) FROM v_contacts WHERE deleted = 0) AS total_active_contacts,
    (SELECT COUNT(*) FROM v_contacts WHERE contact_type = 'individual' AND deleted = 0) AS individuals,
    (SELECT COUNT(*) FROM v_contacts WHERE contact_type = 'organization' AND deleted = 0) AS organizations,
    (SELECT COUNT(*) FROM v_contacts WHERE primary_email IS NOT NULL AND deleted = 0) AS with_email_addresses;
