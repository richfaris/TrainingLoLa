# Lesson 4.2: Commission Tracking and Agent Performance

## 🎯 Learning Objectives
- Understand the structure of v_commission_details view
- Analyze commission calculations and rates
- Create agent performance reports
- Track commission payments and trends
- Build commission vs policy relationship queries

## 📊 Understanding v_commission_details Structure

The `v_commission_details` view contains detailed commission information for agents. This is essential for agent performance analysis and financial reporting.

### Key Fields in v_commission_details

| Field | Type | Description | Business Use |
|-------|------|-------------|--------------|
| `commission_id` | INT | Unique commission identifier | Primary key for commissions |
| `agent_id` | INT | Agent identifier | Agent relationship |
| `policy_number` | VARCHAR | Associated policy | Policy relationship |
| `commission_amount` | DECIMAL | Commission amount | Financial calculations |
| `commission_rate` | DECIMAL | Commission percentage | Rate analysis |
| `commission_date` | DATE | Date commission earned | Timing analysis |
| `commission_status` | VARCHAR | Payment status | Status tracking |
| `policy_type_id` | INT | Policy type identifier | Policy type analysis |

## 🔍 Basic Commission Queries

### 1. All Paid Commissions
```sql
SELECT 
    commission_id,
    commission_amount,
    commission_rate,
    commission_date,
    commission_status
FROM v_commission_details
WHERE commission_status = 'paid'
ORDER BY commission_date DESC
LIMIT 10;
```

###2mmissions by Agent
```sql
SELECT 
    con.contact_name as agent_name,
    COUNT(cd.commission_id) as commission_count,
    SUM(cd.commission_amount) as total_commission
FROM v_commission_details cd
JOIN v_contacts con ON cd.agent_id = con.contact_id
WHERE cd.commission_status = 'paid'
GROUP BY con.contact_name
ORDER BY total_commission DESC;
```

### 3. Commission Rates Analysis
```sql
SELECT 
    commission_rate,
    COUNT(*) as commission_count,
    SUM(commission_amount) as total_amount,
    AVG(commission_amount) as avg_amount
FROM v_commission_details
WHERE commission_status = 'paid'
GROUP BY commission_rate
ORDER BY commission_rate DESC;
```

## 💰 Commission Performance Analysis

### Monthly Commission Trends
```sql
SELECT 
    DATE_FORMAT(commission_date, '%Y-%m') as commission_month,
    COUNT(*) as commission_count,
    SUM(commission_amount) as monthly_commission,
    AVG(commission_amount) as avg_commission
FROM v_commission_details
WHERE commission_status = 'paid'
GROUP BY DATE_FORMAT(commission_date, '%Y-%m')
ORDER BY commission_month DESC;
```

### Agent Performance Rankings
```sql
SELECT 
    con.contact_name as agent_name,
    COUNT(cd.commission_id) as policies_sold,
    SUM(cd.commission_amount) as total_commission,
    AVG(cd.commission_amount) as avg_commission_per_policy,
    ROUND(SUM(cd.commission_amount) / COUNT(cd.commission_id), 2) as avg_commission_rate
FROM v_commission_details cd
JOIN v_contacts con ON cd.agent_id = con.contact_id
WHERE cd.commission_status = 'paid'
GROUP BY con.contact_name
ORDER BY total_commission DESC;
```

## 🏢 Commission vs Policy Analysis

### Commissions by Policy Type
```sql
SELECT 
    pt.policy_type_name,
    COUNT(cd.commission_id) as commission_count,
    SUM(cd.commission_amount) as total_commission,
    AVG(cd.commission_rate) as avg_commission_rate
FROM v_commission_details cd
JOIN v_policy_types pt ON cd.policy_type_id = pt.policy_type_id
WHERE cd.commission_status = 'paid'
GROUP BY pt.policy_type_name
ORDER BY total_commission DESC;
```

### Commission vs Revenue Analysis
```sql
SELECT 
    con.contact_name as agent_name,
    COUNT(DISTINCT cd.policy_number) as policies_sold,
    SUM(p.payment_amount) as total_revenue,
    SUM(cd.commission_amount) as total_commission,
    ROUND(SUM(cd.commission_amount) / SUM(p.payment_amount) * 100, 2) as commission_percentage
FROM v_commission_details cd
JOIN v_contacts con ON cd.agent_id = con.contact_id
JOIN v_payments p ON cd.policy_number = p.policy_number
WHERE cd.commission_status = 'paid'
  AND p.payment_status = 'completed'
GROUP BY con.contact_name
ORDER BY total_commission DESC;
```

## 📅 Time-Based Commission Analysis

### Year-over-Year Commission Comparison
```sql
SELECT 
    YEAR(commission_date) as commission_year,
    COUNT(*) as commission_count,
    SUM(commission_amount) as yearly_commission
FROM v_commission_details
WHERE commission_status = 'paid'
GROUP BY YEAR(commission_date)
ORDER BY commission_year DESC;
```

### Commission Growth Analysis
```sql
SELECT 
    con.contact_name as agent_name,
    COUNT(CASE WHEN YEAR(cd.commission_date) = YEAR(CURDATE()) THEN 1 END) as commissions_this_year,
    COUNT(CASE WHEN YEAR(cd.commission_date) = YEAR(CURDATE()) - 1 THEN 1 END) as commissions_last_year,
    SUM(CASE WHEN YEAR(cd.commission_date) = YEAR(CURDATE()) THEN cd.commission_amount ELSE 0 END) as commission_this_year,
    SUM(CASE WHEN YEAR(cd.commission_date) = YEAR(CURDATE()) - 1 THEN cd.commission_amount ELSE 0 END) as commission_last_year
FROM v_commission_details cd
JOIN v_contacts con ON cd.agent_id = con.contact_id
WHERE cd.commission_status = 'paid'
GROUP BY con.contact_name
HAVING commissions_this_year > 0 AND commissions_last_year > 0
ORDER BY commission_this_year DESC;
```

## 🎯 Commission Dashboards

### Commission Summary Dashboard
```sql
SELECT 'Total Paid Commissions' as metric,
    COUNT(*) as value
FROM v_commission_details
WHERE commission_status = 'paid'
UNION ALL
SELECT 'Total Commission Paid',
    SUM(commission_amount)
FROM v_commission_details
WHERE commission_status = 'paid'
UNION ALL
SELECT 'Average Commission',
    AVG(commission_amount)
FROM v_commission_details
WHERE commission_status = 'paid'
UNION ALL
SELECT 'Commissions This Month',
    COUNT(*)
FROM v_commission_details
WHERE commission_status = 'paid'
  AND DATE_FORMAT(commission_date, '%Y-%m') = DATE_FORMAT(CURDATE(), '%Y-%m')
UNION ALL
SELECT 'Commission This Month',
    SUM(commission_amount)
FROM v_commission_details
WHERE commission_status = 'paid'
  AND DATE_FORMAT(commission_date, '%Y-%m') = DATE_FORMAT(CURDATE(), '%Y-%m');
```

### Top Performing Agents Dashboard
```sql
SELECT 
    con.contact_name as agent_name,
    COUNT(cd.commission_id) as policies_sold,
    SUM(cd.commission_amount) as total_commission,
    ROUND(SUM(cd.commission_amount) / COUNT(cd.commission_id), 2) as avg_commission_per_policy
FROM v_commission_details cd
JOIN v_contacts con ON cd.agent_id = con.contact_id
WHERE cd.commission_status = 'paid'
GROUP BY con.contact_name
ORDER BY total_commission DESC
LIMIT 10;
```

## 💡 Commission Analysis Best Practices

### 1**Always Filter by Commission Status**
```sql
WHERE commission_status = 'paid'
```This ensures youre only analyzing actual paid commissions.

### 2e Appropriate Date Ranges**
```sql
WHERE commission_date >= '2024-01-01' AND commission_date <= '2024-12-31'
```Large date ranges can slow down queries.

### 3**Handle Commission Rate Calculations**
```sql
ROUND(commission_amount / policy_premium * 100, 2) as calculated_rate
```
Always verify commission rate calculations.

### 4**Use Agent Performance Metrics**
- Total commission amount
- Commission per policy
- Commission growth rate
- Policy count

## 📝 Practice Questions

1**Who are your top5earning agents?**
2. **What's the average commission rate by policy type?**3How has agent performance changed over the last year?**4Which policy types generate the highest commissions?**

## 🔗 Next Steps

In the next lesson, we'll explore advanced analytics with complex joins, including:
- Multi-view JOIN operations
- Complex business intelligence queries
- Advanced aggregations and calculations
- Executive dashboards

---

**💡 Pro Tip**: Commission analysis is critical for agent motivation and business planning. Always consider the relationship between commission rates, policy types, and agent performance for optimal results. 