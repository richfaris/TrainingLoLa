# Lesson 5.1: Advanced Multi-View JOINs

## 🎯 Learning Objectives
- Master complex JOIN operations with multiple BriteCore views
- Understand view relationships and foreign keys
- Create comprehensive business reports using multiple views
- Optimize queries with proper JOIN strategies
- Build complex analytical dashboards

## 🔗 Understanding View Relationships

BriteCore views are designed to work together. Understanding their relationships is key to advanced analysis.

### Common JOIN Patterns

| Primary View | Related View | Join Field | Business Purpose |
|--------------|--------------|------------|------------------|
| `v_claims` | `v_policy_types` | `policy_type_id` | Claims by policy type |
| `v_claims` | `v_contacts` | `contact_id` | Claims by insured |
| `v_payments` | `v_policy_types` | `policy_type_id` | Payments by policy type |
| `v_properties` | `v_policy_types` | `policy_type_id` | Properties by policy type |
| `v_commission_details` | `v_contacts` | `agency_id` | Commissions by agent |

## 🔍 Basic Multi-View JOINs

### 1. Claims with Policy and Contact Information
```sql
SELECT 
    c.claim_number,
    c.claim_status,
    c.loss_date,
    pt.policy_type,
    con.contact_name as insured_name
FROM v_claims c
JOIN v_policy_types pt ON c.policy_type_id = pt.policy_type_id
JOIN v_contacts con ON c.primary_insured_id = con.contact_id
WHERE c.claim_active_flag = 1
ORDER BY c.loss_date DESC
LIMIT 10;
```

### 2. Payments with Policy and Contact Details
```sql
SELECT 
    p.transaction_amount,
    p.transaction_date_time,
    p.payment_instrument,
    pt.policy_type,
    con.contact_name as policyholder
FROM v_payments p
JOIN v_policy_types pt ON p.policy_type_id = pt.policy_type_id
JOIN v_contacts con ON p.primary_insured_id = con.contact_id
WHERE p.completed = 1
ORDER BY p.transaction_date_time DESC
LIMIT 10;
```

## 🏢 Complex Business Analysis

### Claims Analysis by Agent and Policy Type
```sql
SELECT 
    agent.contact_name as agent_name,
    pt.policy_type,
    COUNT(c.claim_id) as claim_count,
    AVG(DATEDIFF(c.date_reported, c.loss_date)) as avg_reporting_delay
FROM v_claims c
JOIN v_policy_types pt ON c.policy_type_id = pt.policy_type_id
JOIN v_contacts agent ON c.agent_id = agent.contact_id
WHERE c.claim_active_flag = 1
  AND agent.roles LIKE '%agent%'
GROUP BY agent.contact_name, pt.policy_type
ORDER BY claim_count DESC;
```

### Financial Performance by Agent
```sql
SELECT 
    agent.contact_name as agent_name,
    COUNT(DISTINCT p.invoice_number) as policy_count,
    SUM(p.transaction_amount) as total_revenue,
    AVG(p.transaction_amount) as avg_payment,
    COUNT(c.claim_id) as claim_count
FROM v_payments p
JOIN v_contacts agent ON p.agent_id = agent.contact_id
LEFT JOIN v_claims c ON p.invoice_number = c.policy_number
WHERE p.completed = 1
  AND agent.roles LIKE '%agent%'
GROUP BY agent.contact_name
ORDER BY total_revenue DESC;
```

## 📊 Advanced Aggregations

### Policy Portfolio Analysis
```sql
SELECT 
    pt.policy_type,
    COUNT(DISTINCT r.revision_id) as policy_count,
    COUNT(DISTINCT c.claim_id) as claim_count,
    SUM(p.transaction_amount) as total_revenue,
    ROUND(COUNT(DISTINCT c.claim_id) / COUNT(DISTINCT r.revision_id) * 100, 2) as claim_frequency
FROM v_policy_types pt
LEFT JOIN v_revisions r ON pt.policy_type_id = r.policy_type_id
LEFT JOIN v_claims c ON r.revision_id = c.revision_id
LEFT JOIN v_payments p ON r.policy_number = p.invoice_number
GROUP BY pt.policy_type
ORDER BY total_revenue DESC;
```

### Geographic Risk Analysis
```sql
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
```

## 🎯 Business Intelligence Dashboards

### Executive Summary Dashboard
```sql
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
```

### Agent Performance Dashboard
```sql
SELECT 
    agent.contact_name as agent_name,
    COUNT(DISTINCT r.revision_id) as policies_written,
    SUM(p.transaction_amount) as total_revenue,
    COUNT(c.claim_id) as claims_handled,
    ROUND(SUM(cd.commission_amount), 2) as total_commission
FROM v_contacts agent
LEFT JOIN v_revisions r ON agent.contact_id = r.agent_id
LEFT JOIN v_payments p ON r.policy_number = p.invoice_number
LEFT JOIN v_claims c ON r.revision_id = c.revision_id
LEFT JOIN v_commission_details cd ON agent.contact_id = cd.agency_id
WHERE agent.roles LIKE '%agent%'
  AND agent.deleted = 0
GROUP BY agent.contact_name
ORDER BY total_revenue DESC;
```

## 💡 JOIN Best Practices

### 1. Use Appropriate JOIN Types
- `INNER JOIN`: When you need matching records from both tables
- `LEFT JOIN`: When you want all records from the left table
- `RIGHT JOIN`: When you want all records from the right table

### 2. Optimize JOIN Order
```sql
-- Good: Start with the most filtered table
FROM v_claims c
JOIN v_policy_types pt ON c.policy_type_id = pt.policy_type_id
WHERE c.claim_active_flag = 1

-- Better: Apply filters early
FROM v_claims c
JOIN v_policy_types pt ON c.policy_type_id = pt.policy_type_id
WHERE c.claim_active_flag = 1 AND pt.active = 1
```

### 3. Use Table Aliases
```sql
FROM v_claims c
JOIN v_policy_types pt ON c.policy_type_id = pt.policy_type_id
JOIN v_contacts con ON c.primary_insured_id = con.contact_id
```
This makes queries more readable and maintainable.

### 4. Handle NULL Values
```sql
WHERE c.loss_cause IS NOT NULL
```
Many fields can be NULL, affecting your JOIN results.

## 📝 Practice Questions

1. **How would you create a report showing claims by agent and policy type?**
2. **What's the relationship between payments and claims for each policy type?**
3. **How do you calculate agent performance including policies, claims, and revenue?**
4. **Which geographic areas have the highest claim rates?**

## 🔗 Next Steps

In the next lesson, we'll explore window functions for trend analysis, including:
- Running totals and moving averages
- Rank and percentile calculations
- Time-series analysis
- Advanced statistical functions

---

**💡 Pro Tip**: Complex JOINs can be resource-intensive. Always test with LIMIT clauses first, and consider breaking complex queries into smaller, more manageable pieces. 