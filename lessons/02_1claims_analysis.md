# Lesson 2.1: Claims Analysis with v_claims

## 🎯 Learning Objectives
- Understand the structure of v_claims view
- Write queries to analyze claims data
- Filter claims by status, type, and date
- Create claims summary reports
- Understand the relationship between claims and policies

## 📊 Understanding v_claims Structure

The `v_claims` view is your primary source for claims data in BriteCore. It combines claims information with policy relationships and loss details.

### Key Fields in v_claims

| Field | Type | Description | Business Use |
|-------|------|-------------|--------------|
| `claim_id` | INT | Unique claim identifier | Primary key for claims |
| `claim_number` | VARCHAR | Human-readable claim number | Easy identification |
| `claim_status` | VARCHAR | Current status (open, closed, etc.) | Status tracking |
| `claim_type` | VARCHAR | Type of claim | Categorization |
| `claim_active_flag` | TINYINT | 1 if claim is active | Filtering active claims |
| `policy_number` | VARCHAR | Associated policy number | Policy relationship |
| `revision_id` | INT | Policy revision ID | Policy version tracking |
| `loss_date` | DATE | Date of loss | Loss timing analysis |
| `date_reported` | DATE | Date claim was reported | Reporting analysis |
| `date_added` | DATETIME | When claim was created | Creation tracking |
| `last_modified` | DATETIME | Last modification date | Update tracking |
| `description` | TEXT | Claim description | Narrative analysis |
| `loss_location_address` | VARCHAR | Where loss occurred | Geographic analysis |
| `loss_cause` | VARCHAR | Cause of loss (perils) | Loss cause analysis |

## 🔍 Basic Claims Queries

### 1. All Active Claims
```sql
SELECT 
    claim_number,
    claim_status,
    claim_type,
    loss_date,
    description
FROM v_claims
WHERE claim_active_flag = 1
LIMIT 10;
```

### 2. Claims by Status
```sql
SELECT 
    claim_status,
    COUNT(*) as claim_count
FROM v_claims
WHERE claim_active_flag = 1
GROUP BY claim_status
ORDER BY claim_count DESC;
```

### 3. Claims by Loss Cause
```sql
SELECT 
    loss_cause,
    COUNT(*) as claim_count
FROM v_claims
WHERE claim_active_flag = 1 AND loss_cause IS NOT NULL
GROUP BY loss_cause
ORDER BY claim_count DESC;
```

## 📅 Date-Based Analysis

### Claims by Month
```sql
SELECT 
    DATE_FORMAT(loss_date, '%Y-%m') as loss_month,
    COUNT(*) as claim_count
FROM v_claims
WHERE claim_active_flag = 1 AND loss_date IS NOT NULL
GROUP BY DATE_FORMAT(loss_date, '%Y-%m')
ORDER BY loss_month DESC;
```

### Claims by Year
```sql
SELECT 
    YEAR(loss_date) as loss_year,
    COUNT(*) as claim_count
FROM v_claims
WHERE claim_active_flag = 1 AND loss_date IS NOT NULL
GROUP BY YEAR(loss_date)
ORDER BY loss_year DESC;
```

## 🏢 Business Intelligence Queries

### Claims Summary Dashboard
```sql
SELECT 'Total Active Claims' as metric,
    COUNT(*) as value
FROM v_claims
WHERE claim_active_flag = 1
UNION ALL
SELECT 
    'Open Claims',
    COUNT(*)
FROM v_claims
WHERE claim_active_flag = 1
  AND claim_status = 'open'
UNION ALL
SELECT 
    'Claims This Year',
    COUNT(*)
FROM v_claims
WHERE claim_active_flag = 1 AND YEAR(loss_date) = YEAR(CURDATE())
UNION ALL
SELECT 
    'Claims This Month',
    COUNT(*)
FROM v_claims
WHERE claim_active_flag = 1
  AND DATE_FORMAT(loss_date, '%Y-%m') = DATE_FORMAT(CURDATE(), '%Y-%m');
```

### Claims by Policy Type
```sql
SELECT 
    pt.policy_type,
    COUNT(c.claim_id) as claim_count
FROM v_claims c
JOIN v_policy_types pt ON c.policy_type_id = pt.policy_type_id
WHERE c.claim_active_flag = 1
GROUP BY pt.policy_type
ORDER BY claim_count DESC;
```

## 🎯 Common Claims Analysis Scenarios

### 1. **Loss Trend Analysis**
Track claims over time to identify patterns:
```sql
SELECT 
    YEAR(loss_date) as year,
    MONTH(loss_date) as month,
    COUNT(*) as claim_count
FROM v_claims
WHERE claim_active_flag = 1 AND loss_date >= DATE_SUB(CURDATE(), INTERVAL 2 YEAR)
GROUP BY YEAR(loss_date), MONTH(loss_date)
ORDER BY year DESC, month DESC;
```

### 2. **Geographic Analysis**
Analyze claims by location:
```sql
SELECT 
    SUBSTRING_INDEX(loss_location_address, ',', 1) as city,
    COUNT(*) as claim_count
FROM v_claims
WHERE claim_active_flag = 1
  AND loss_location_address IS NOT NULL
GROUP BY SUBSTRING_INDEX(loss_location_address, ',', 1)
ORDER BY claim_count DESC
LIMIT 10;
```

### 3. **Claims vs Policies Analysis**
Compare claims to policy information:
```sql
SELECT 
    c.claim_number,
    c.loss_date,
    c.claim_status,
    p.policy_number,
    p.policy_type
FROM v_claims c
JOIN v_policy_types p ON c.policy_type_id = p.policy_type_id
WHERE c.claim_active_flag = 1
ORDER BY c.loss_date DESC
LIMIT 20;
```

## 💡 Best Practices for Claims Analysis

### 1. **Always Filter by Active Claims**
```sql
WHERE claim_active_flag = 1
```
This ensures you're only working with current, relevant claims.

### 2. **Use Date Ranges for Performance**
```sql
WHERE loss_date >= '2024-01-01' AND loss_date <= '2024-12-31'
```
Large date ranges can slow down queries.

### 3. **Handle NULL Values**
```sql
WHERE loss_cause IS NOT NULL
```
Many fields can be NULL, so check before grouping.

### 4. **Use Appropriate Date Functions**
- `YEAR()` for year analysis
- `MONTH()` for month analysis
- `DATE_FORMAT()` for custom formatting

## 📝 Practice Questions

1. **How would you find all claims reported in the last 30 days?**
2. **What's the most common loss cause in your claims data?**
3. **How do you calculate the average time between loss date and report date?**
4. **Which policy types have the highest claim frequency?**

## 🔗 Next Steps

In the next lesson, we'll explore advanced claims filtering and status analysis, including:
- Complex WHERE clauses
- Claims status transitions
- Claims vs policy relationships
- Loss cause analysis

---

**💡 Pro Tip**: Claims data is often time-sensitive. Always consider the business context when analyzing claims - recent claims may still be in progress, while older claims may be closed. 