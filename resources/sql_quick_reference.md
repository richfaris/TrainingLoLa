# SQL Quick Reference Guide for BriteCore

## 🚀 Getting Started

### View All Available Views and Fields
```sql
SELECT * FROM v_logical_catalog;
```

### Basic Query Structure
```sql
SELECT column1, column2, ...
FROM view_name
WHERE condition
GROUP BY column
HAVING group_condition
ORDER BY column
LIMIT number;
```

## 📊 SELECT Statements

### Basic Selection
```sql
-- Select specific columns
SELECT claim_number, claim_status, loss_date
FROM v_claims
WHERE claim_active_flag = 1;

-- Select all columns
SELECT * FROM v_policy_types WHERE active = 1;

-- Select with aliases
SELECT 
    pt.policy_type_name as type,
    COUNT(*) as count
FROM v_policy_types pt
WHERE pt.active = 1;
```

### Filtering with WHERE
```sql
-- Basic conditions
WHERE claim_status = 'open'
WHERE payment_amount > 100
WHERE loss_date >= '2024-01-01'

-- Multiple conditions
WHERE claim_active_flag = 1 AND loss_date >= '2024-01-01' AND claim_status IN ('open', 'investigating')

-- NULL handling
WHERE loss_cause IS NOT NULL
WHERE address_city IS NULL

-- Pattern matching
WHERE contact_name LIKE '%Smith%'
WHERE policy_number LIKE 'POL%'
```

## 🔗 JOIN Operations

### INNER JOIN
```sql
SELECT 
    c.claim_number,
    pt.policy_type_name
FROM v_claims c
JOIN v_policy_types pt ON c.policy_type_id = pt.policy_type_id
WHERE c.claim_active_flag = 1;
```

### LEFT JOIN
```sql
SELECT 
    pt.policy_type_name,
    COUNT(r.revision_id) as policy_count
FROM v_policy_types pt
LEFT JOIN v_revisions r ON pt.policy_type_id = r.policy_type_id
WHERE pt.active = 1
GROUP BY pt.policy_type_name;
```

### Multiple JOINs
```sql
SELECT 
    c.claim_number,
    pt.policy_type_name,
    con.contact_name as insured_name
FROM v_claims c
JOIN v_policy_types pt ON c.policy_type_id = pt.policy_type_id
JOIN v_contacts con ON c.primary_insured_id = con.contact_id
WHERE c.claim_active_flag = 1;
```

## 📈 Aggregation Functions

### Basic Aggregations
```sql
-- Count records
COUNT(*) as total_count
COUNT(DISTINCT policy_number) as unique_policies

-- Sum and average
SUM(payment_amount) as total_revenue
AVG(commission_amount) as avg_commission

-- Min and max
MIN(loss_date) as earliest_loss
MAX(payment_date) as latest_payment
```

### GROUP BY
```sql
SELECT 
    claim_status,
    COUNT(*) as claim_count,
    AVG(DATEDIFF(date_reported, loss_date)) as avg_delay
FROM v_claims
WHERE claim_active_flag = 1
GROUP BY claim_status
ORDER BY claim_count DESC;
```

### HAVING
```sql
SELECT 
    loss_cause,
    COUNT(*) as claim_count
FROM v_claims
WHERE claim_active_flag = 1
GROUP BY loss_cause
HAVING COUNT(*) >= 5
ORDER BY claim_count DESC;
```

## 📅 Date Functions

### Date Formatting
```sql
-- Extract year
YEAR(loss_date) as loss_year

-- Extract month
MONTH(loss_date) as loss_month

-- Format as YYYY-MM
DATE_FORMAT(loss_date, '%Y-%m') as loss_month

-- Format as readable date
DATE_FORMAT(loss_date, '%M %Y') as month_year
```

### Date Calculations
```sql
-- Days between dates
DATEDIFF(date_reported, loss_date) as reporting_delay

-- Add/subtract days
DATE_ADD(loss_date, INTERVAL 30 DAY) as thirty_days_later
DATE_SUB(CURDATE(), INTERVAL 1 YEAR) as one_year_ago

-- Current date
CURDATE() as today
NOW() as current_timestamp
```

### Date Filtering
```sql
-- This year
WHERE YEAR(loss_date) = YEAR(CURDATE())

-- Last 30 days
WHERE loss_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)

-- This month
WHERE DATE_FORMAT(loss_date, '%Y-%m') = DATE_FORMAT(CURDATE(), '%Y-%m')
```

## 🔢 Window Functions

### Running Totals
```sql
SELECT 
    payment_date,
    payment_amount,
    SUM(payment_amount) OVER (
        ORDER BY payment_date 
        ROWS UNBOUNDED PRECEDING
    ) as running_total
FROM v_payments
WHERE payment_status = 'completed';
```

### Moving Averages
```sql
WITH monthly_claims AS (
    SELECT 
        DATE_FORMAT(loss_date, '%Y-%m') as loss_month,
        COUNT(*) as claim_count
    FROM v_claims
    WHERE claim_active_flag = 1 AND loss_date IS NOT NULL
    GROUP BY DATE_FORMAT(loss_date, '%Y-%m')
)
SELECT 
    loss_month,
    claim_count,
    AVG(claim_count) OVER (
        ORDER BY loss_month
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) as moving_avg_3months
FROM monthly_claims
ORDER BY loss_month;
```

### Rankings
```sql
SELECT 
    contact_name,
    total_commission,
    RANK() OVER (ORDER BY total_commission DESC) as rank_by_commission,
    DENSE_RANK() OVER (ORDER BY total_commission DESC) as dense_rank
FROM (
    SELECT 
        con.contact_name,
        SUM(cd.commission_amount) as total_commission
    FROM v_commission_details cd
    JOIN v_contacts con ON cd.agent_id = con.contact_id
    WHERE cd.commission_status = 'paid'
    GROUP BY con.contact_name
) agent_totals;
```

## 🎯 CASE Statements

### Simple CASE
```sql
SELECT 
    claim_status,
    CASE 
        WHEN claim_status = 'open' THEN 'High Priority'
        WHEN claim_status = 'investigating' THEN 'Medium Priority'
        ELSE 'Low Priority'
    END as priority_level
FROM v_claims;
```

### Complex CASE with Aggregation
```sql
SELECT 
    policy_type_name,
    COUNT(CASE WHEN YEAR(date_added) = YEAR(CURDATE()) THEN 1 END) as policies_this_year,
    COUNT(CASE WHEN YEAR(date_added) = YEAR(CURDATE()) - 1 THEN 1 END) as policies_last_year
FROM v_policy_types pt
LEFT JOIN v_revisions r ON pt.policy_type_id = r.policy_type_id
WHERE pt.active = 1
GROUP BY policy_type_name;
```

## 📊 UNION Operations

### Combining Results
```sql
SELECT 'Total Policies' as metric,
    COUNT(*) as value
FROM v_revisions
WHERE active = 1
UNION ALL
SELECT 'Active Claims',
    COUNT(*)
FROM v_claims
WHERE claim_active_flag = 1
UNION ALL
SELECT 'Total Revenue',
    SUM(payment_amount)
FROM v_payments
WHERE payment_status = 'completed';
```

## 🔍 Subqueries

### IN Subquery
```sql
SELECT 
    policy_type_name
FROM v_policy_types
WHERE policy_type_id IN (
    SELECT DISTINCT policy_type_id 
    FROM v_claims 
    WHERE claim_active_flag = 1
);
```

### Scalar Subquery
```sql
SELECT 
    claim_status,
    COUNT(*) as claim_count,
    ROUND(COUNT(*) * 100 / (
        SELECT COUNT(*) FROM v_claims WHERE claim_active_flag = 1
    ), 2) as percentage
FROM v_claims
WHERE claim_active_flag = 1
GROUP BY claim_status;
```

## 📋 Common BriteCore Patterns

### Active Records Filter
```sql
-- Always filter by active flags
WHERE claim_active_flag = 1
WHERE active = 1
WHERE deleted = 0
```

### Date Range Queries
```sql
-- Last 12 months
WHERE loss_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)

-- Current year
WHERE YEAR(payment_date) = YEAR(CURDATE())

-- Specific date range
WHERE payment_date BETWEEN '2024-01-01' AND '2024-12-31'
```

### NULL Handling
```sql
-- Check for NULL
WHERE loss_cause IS NOT NULL
WHERE address_city IS NULL

-- Use COALESCE for defaults
COALESCE(description, 'No description') as claim_description
```

### String Functions
```sql
-- Extract city from address
SUBSTRING_INDEX(address_city, ',', 1) as city_only

-- Concatenate strings
CONCAT(contact_name, ' (', contact_id, ')') as full_contact

-- Case conversion
UPPER(policy_type_name) as type_upper
LOWER(claim_status) as status_lower
```

## 🎯 Performance Tips

### Use LIMIT for Testing
```sql
-- Always test with LIMIT first
SELECT * FROM v_claims WHERE claim_active_flag = 1 LIMIT 10;
```

### Filter Early
```sql
-- Good: Filter in WHERE clause
FROM v_claims c
JOIN v_policy_types pt ON c.policy_type_id = pt.policy_type_id
WHERE c.claim_active_flag = 1 AND pt.active = 1

-- Avoid: Filtering after JOIN
FROM v_claims c
JOIN v_policy_types pt ON c.policy_type_id = pt.policy_type_id
WHERE c.claim_active_flag = 1
```

### Use Appropriate Indexes
```sql
-- Use indexed columns in WHERE and JOIN
WHERE claim_active_flag = 1  -- Usually indexed
WHERE policy_number = 'POL123'  -- Usually indexed
```

## 🔧 Troubleshooting

### Common Errors
```sql
-- Error: Unknown column
-- Solution: Check column name in v_logical_catalog

-- Error: Unknown table/view
-- Solution: Check view name in v_logical_catalog

-- Error: GROUP BY missing
-- Solution: Include all non-aggregated columns in GROUP BY

-- Error: Subquery returns more than one row
-- Solution: Use IN instead of = for subqueries
```

### Debugging Queries
```sql
-- Test each part separately
SELECT * FROM v_claims WHERE claim_active_flag = 1 LIMIT 5;

-- Check data types
SELECT 
    claim_number,
    typeof(claim_number) as data_type
FROM v_claims LIMIT 1;

-- Verify joins work
SELECT COUNT(*) FROM v_claims c
JOIN v_policy_types pt ON c.policy_type_id = pt.policy_type_id;
```

---

**💡 Pro Tip**: Always start with `SELECT * FROM v_logical_catalog;` to see all available views and their fields before writing complex queries! 