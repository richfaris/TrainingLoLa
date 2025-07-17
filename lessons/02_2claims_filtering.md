# Lesson 2.2nced Claims Filtering and Status Analysis

## 🎯 Learning Objectives
- Master complex WHERE clauses for claims filtering
- Analyze claims status transitions and patterns
- Create claims vs policy relationship queries
- Build advanced claims reporting dashboards
- Understand claims lifecycle analysis

## 🔍 Advanced Claims Filtering

### Complex WHERE Clauses

#### Claims by Date Range and Status
```sql
SELECT 
    claim_number,
    claim_status,
    loss_date,
    date_reported,
    DATEDIFF(date_reported, loss_date) as reporting_delay
FROM v_claims
WHERE claim_active_flag =1  AND loss_date >= 2024-11  AND loss_date <= 2024-12  AND claim_status IN ('open',investigating')
ORDER BY reporting_delay DESC;
```

#### Claims by Loss Cause and Geographic Area
```sql
SELECT 
    claim_number,
    loss_cause,
    loss_location_address,
    claim_status
FROM v_claims
WHERE claim_active_flag = 1 AND loss_cause IN ('Fire,Water Damage', 'Theft')
  AND loss_location_address LIKE '%Springfield%'
ORDER BY loss_date DESC;
```

## 📊 Claims Status Analysis

### Status Distribution Over Time
```sql
SELECT 
    DATE_FORMAT(loss_date, '%Y-%m)as loss_month,
    claim_status,
    COUNT(*) as claim_count
FROM v_claims
WHERE claim_active_flag =1  AND loss_date >= DATE_SUB(CURDATE(), INTERVAL 12NTH)
GROUP BY DATE_FORMAT(loss_date, '%Y-%m'), claim_status
ORDER BY loss_month DESC, claim_count DESC;
```

### Claims Status Transitions
```sql
SELECT 
    claim_status,
    COUNT(*) as current_count,
    COUNT(CASE WHEN loss_date >= DATE_SUB(CURDATE(), INTERVAL 30AY) THEN 1 END) as recent_count,
    COUNT(CASE WHEN loss_date >= DATE_SUB(CURDATE(), INTERVAL 7AY) THEN 1 END) as this_week_count
FROM v_claims
WHERE claim_active_flag = 1
GROUP BY claim_status
ORDER BY current_count DESC;
```

## 🏢 Claims vs Policy Analysis

### Claims by Policy Type and Status
```sql
SELECT 
    pt.policy_type_name,
    c.claim_status,
    COUNT(c.claim_id) as claim_count,
    AVG(DATEDIFF(c.date_reported, c.loss_date)) as avg_reporting_delay
FROM v_claims c
JOIN v_policy_types pt ON c.policy_type_id = pt.policy_type_id
WHERE c.claim_active_flag = 1
GROUP BY pt.policy_type_name, c.claim_status
ORDER BY pt.policy_type_name, claim_count DESC;
```

### Claims Frequency by Policy Type
```sql
SELECT 
    pt.policy_type_name,
    COUNT(DISTINCT r.revision_id) as total_policies,
    COUNT(c.claim_id) as total_claims,
    ROUND(COUNT(c.claim_id) / COUNT(DISTINCT r.revision_id) * 100as claim_frequency_percent
FROM v_policy_types pt
LEFT JOIN v_revisions r ON pt.policy_type_id = r.policy_type_id
LEFT JOIN v_claims c ON r.revision_id = c.revision_id
WHERE pt.active = 1
GROUP BY pt.policy_type_name
ORDER BY claim_frequency_percent DESC;
```

## 📅 Claims Lifecycle Analysis

### Claims by Reporting Delay
```sql
SELECT 
    CASE 
        WHEN DATEDIFF(date_reported, loss_date) = 0Same Day'
        WHEN DATEDIFF(date_reported, loss_date) <= 1 THEN '1 Day'
        WHEN DATEDIFF(date_reported, loss_date) <= 32-3Days'
        WHEN DATEDIFF(date_reported, loss_date) <= 74-7Days'
        WHEN DATEDIFF(date_reported, loss_date) <= 30 THEN '1eeks'
        ELSE Over 4 Weeks'
    END as reporting_delay_category,
    COUNT(*) as claim_count,
    ROUND(COUNT(*) *100SUM(COUNT(*)) OVER(),2as percentage
FROM v_claims
WHERE claim_active_flag =1  AND loss_date IS NOT NULL
  AND date_reported IS NOT NULL
GROUP BY 
    CASE 
        WHEN DATEDIFF(date_reported, loss_date) = 0Same Day'
        WHEN DATEDIFF(date_reported, loss_date) <= 1 THEN '1 Day'
        WHEN DATEDIFF(date_reported, loss_date) <= 32-3Days'
        WHEN DATEDIFF(date_reported, loss_date) <= 74-7Days'
        WHEN DATEDIFF(date_reported, loss_date) <= 30 THEN '1eeks'
        ELSE Over4eksEND
ORDER BY claim_count DESC;
```

### Claims Processing Time Analysis
```sql
SELECT 
    claim_status,
    COUNT(*) as claim_count,
    AVG(DATEDIFF(CURDATE(), date_added)) as avg_days_since_creation,
    MIN(DATEDIFF(CURDATE(), date_added)) as min_days_since_creation,
    MAX(DATEDIFF(CURDATE(), date_added)) as max_days_since_creation
FROM v_claims
WHERE claim_active_flag = 1
GROUP BY claim_status
ORDER BY avg_days_since_creation DESC;
```

## 🎯 Advanced Claims Reporting

### Claims Dashboard with Multiple Metrics
```sql
SELECT 'Total Active Claims' as metric,
    COUNT(*) as value
FROM v_claims
WHERE claim_active_flag = 1UNION ALL
SELECT OpenClaims',
    COUNT(*)
FROM v_claims
WHERE claim_active_flag = 1
  AND claim_status =openUNION ALL
SELECT Claims This Month',
    COUNT(*)
FROM v_claims
WHERE claim_active_flag =1
  AND DATE_FORMAT(loss_date, '%Y-%m) = DATE_FORMAT(CURDATE(), %Y-%m')
UNION ALL
SELECT Average Reporting Delay (Days),   ROUND(AVG(DATEDIFF(date_reported, loss_date)),1ROM v_claims
WHERE claim_active_flag =1  AND loss_date IS NOT NULL
  AND date_reported IS NOT NULL
UNION ALL
SELECTClaims Requiring Investigation',
    COUNT(*)
FROM v_claims
WHERE claim_active_flag = 1
  AND claim_status IN (investigating',pending');
```

### Claims Risk Analysis
```sql
SELECT 
    loss_cause,
    COUNT(*) as claim_count,
    COUNT(CASE WHEN claim_status = open' THEN 1 END) as open_claims,
    COUNT(CASE WHEN claim_status = 'closed' THEN1) as closed_claims,
    ROUND(COUNT(CASE WHEN claim_status = open' THEN 1 END) * 100 / COUNT(*), 2) as open_percentage
FROM v_claims
WHERE claim_active_flag = 1 AND loss_cause IS NOT NULL
GROUP BY loss_cause
HAVING claim_count >= 5
ORDER BY open_percentage DESC;
```

## 💡 Advanced Filtering Techniques

### Using CASE Statements for Complex Logic
```sql
SELECT 
    claim_number,
    claim_status,
    loss_date,
    CASE 
        WHEN claim_status =openHEN 'High Priority'
        WHEN claim_status = 'investigating' THEN Medium Priority'
        WHEN claim_status = 'pending' THEN 'Low Priority'
        ELSE Standard'
    END as priority_level
FROM v_claims
WHERE claim_active_flag = 1
ORDER BY 
    CASE 
        WHEN claim_status = 'open' THEN 1
        WHEN claim_status = 'investigating' THEN 2
        WHEN claim_status =pending' THEN3        ELSE 4
    END,
    loss_date DESC;
```

### Subqueries for Comparative Analysis
```sql
SELECT 
    claim_status,
    COUNT(*) as claim_count,
    ROUND(COUNT(*) * 1000/ (SELECT COUNT(*) FROM v_claims WHERE claim_active_flag = 1), 2) as percentage_of_total
FROM v_claims
WHERE claim_active_flag = 1
GROUP BY claim_status
ORDER BY claim_count DESC;
```

## 📝 Practice Questions

1How would you find claims that have been open for more than 30 days?**
2. **What's the average reporting delay by loss cause?**3Which policy types have the highest claim frequency?**
4. **How do you identify claims that may need immediate attention?**

## 🔗 Next Steps

In the next lesson, well explore policy types and forms, including:
- Policy type structure and relationships
- Form analysis and configuration
- Policy type vs claims analysis
- Policy portfolio management

---

**💡 Pro Tip**: Advanced filtering often requires understanding the business context. Always consider the implications of your filters and how they affect the completeness of your analysis. 