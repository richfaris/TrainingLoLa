# Lesson 5.2: Window Functions for Trend Analysis

> **🚧 UNDER CONSTRUCTION 🚧**
> 
> This lesson is currently being developed and tested. The queries below may not work correctly with the current BriteCore view structure. We will complete this lesson once we have verified all field mappings and relationships.

## 🎯 Learning Objectives
- Master window functions for advanced analytics
- Create running totals and moving averages
- Perform rank and percentile calculations
- Analyze time-series data with window functions
- Build advanced statistical reports

## 📊 Understanding Window Functions

Window functions allow you to perform calculations across a set of rows related to the current row. They're powerful for trend analysis and statistical calculations.

### Basic Window Function Syntax
```sql
SELECT 
    column1,
    column2,
    window_function() OVER (
        PARTITION BY partition_column 
        ORDER BY order_column
        ROWS/RANGE frame_specification
    ) as result_column
FROM table_name;
```

## 🔢 Running Totals and Cumulative Analysis

### Running Total of Payments
```sql
SELECT 
    payment_date,
    payment_amount,
    SUM(payment_amount) OVER (
        ORDER BY payment_date 
        ROWS UNBOUNDED PRECEDING
    ) as running_total
FROM v_payments
WHERE payment_status = 'completed'
ORDER BY payment_date;
```

### Monthly Running Revenue
```sql
WITH monthly_data AS (
    SELECT 
        DATE_FORMAT(payment_date, '%Y-%m') as payment_month,
        SUM(payment_amount) as monthly_revenue
    FROM v_payments
    WHERE payment_status = 'completed'
    GROUP BY DATE_FORMAT(payment_date, '%Y-%m')
)
SELECT 
    payment_month,
    monthly_revenue,
    SUM(monthly_revenue) OVER (
        ORDER BY payment_month
        ROWS UNBOUNDED PRECEDING
    ) as cumulative_revenue
FROM monthly_data
ORDER BY payment_month;
```

### Agent Commission Running Totals
```sql
SELECT 
    con.contact_name as agent_name,
    commission_date,
    commission_amount,
    SUM(commission_amount) OVER (
        PARTITION BY con.contact_name
        ORDER BY commission_date
        ROWS UNBOUNDED PRECEDING
    ) as agent_running_total
FROM v_commission_details cd
JOIN v_contacts con ON cd.agent_id = con.contact_id
WHERE cd.commission_status = 'paid'
ORDER BY con.contact_name, commission_date;
```

## 📈 Moving Averages and Trends

### 3-Month Moving Average of Claims
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

### 12-Month Moving Average of Revenue
```sql
WITH monthly_revenue AS (
    SELECT 
        DATE_FORMAT(payment_date, '%Y-%m') as payment_month,
        SUM(payment_amount) as monthly_revenue
    FROM v_payments
    WHERE payment_status = 'completed'
    GROUP BY DATE_FORMAT(payment_date, '%Y-%m')
)
SELECT 
    payment_month,
    monthly_revenue,
    AVG(monthly_revenue) OVER (
        ORDER BY payment_month
        ROWS BETWEEN 11 PRECEDING AND CURRENT ROW
    ) as moving_avg_12months
FROM monthly_revenue
ORDER BY payment_month;
```

## 🏆 Ranking and Percentile Analysis

### Agent Performance Rankings
```sql
SELECT 
    con.contact_name as agent_name,
    SUM(cd.commission_amount) as total_commission,
    RANK() OVER (ORDER BY SUM(cd.commission_amount) DESC) as rank_by_commission,
    DENSE_RANK() OVER (ORDER BY SUM(cd.commission_amount) DESC) as dense_rank_by_commission,
    ROW_NUMBER() OVER (ORDER BY SUM(cd.commission_amount) DESC) as row_number_by_commission
FROM v_commission_details cd
JOIN v_contacts con ON cd.agent_id = con.contact_id
WHERE cd.commission_status = 'paid'
GROUP BY con.contact_name
ORDER BY total_commission DESC;
```

### Policy Type Performance Percentiles
```sql
SELECT 
    pt.policy_type_name,
    COUNT(r.revision_id) as policy_count,
    NTILE(4) OVER (ORDER BY COUNT(r.revision_id) DESC) as performance_quartile,
    PERCENT_RANK() OVER (ORDER BY COUNT(r.revision_id) DESC) as percentile_rank
FROM v_policy_types pt
LEFT JOIN v_revisions r ON pt.policy_type_id = r.policy_type_id
WHERE pt.active = 1
GROUP BY pt.policy_type_name
ORDER BY policy_count DESC;
```

## 📊 Advanced Statistical Analysis

### Claims by Loss Cause with Percentiles
```sql
SELECT 
    loss_cause,
    COUNT(*) as claim_count,
    PERCENT_RANK() OVER (ORDER BY COUNT(*) DESC) as percentile_rank,
    CUME_DIST() OVER (ORDER BY COUNT(*) DESC) as cumulative_distribution
FROM v_claims
WHERE claim_active_flag = 1 AND loss_cause IS NOT NULL
GROUP BY loss_cause
ORDER BY claim_count DESC;
```

### Payment Amount Distribution Analysis
```sql
SELECT 
    payment_amount,
    COUNT(*) as payment_count,
    PERCENT_RANK() OVER (ORDER BY payment_amount) as amount_percentile,
    NTILE(10) OVER (ORDER BY payment_amount) as decile
FROM v_payments
WHERE payment_status = 'completed'
ORDER BY payment_amount;
```

## 🎯 Time-Series Analysis

### Month-over-Month Growth
```sql
WITH monthly_revenue AS (
    SELECT 
        DATE_FORMAT(payment_date, '%Y-%m') as payment_month,
        SUM(payment_amount) as monthly_revenue
    FROM v_payments
    WHERE payment_status = 'completed'
    GROUP BY DATE_FORMAT(payment_date, '%Y-%m')
)
SELECT 
    payment_month,
    monthly_revenue,
    LAG(monthly_revenue) OVER (ORDER BY payment_month) as prev_month_revenue,
    ROUND(
        (monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY payment_month)) / 
        LAG(monthly_revenue) OVER (ORDER BY payment_month) * 100, 2) as growth_percentage
FROM monthly_revenue
ORDER BY payment_month;
```

### Claims Trend Analysis
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
    LAG(claim_count) OVER (ORDER BY loss_month) as prev_month_claims,
    LEAD(claim_count) OVER (ORDER BY loss_month) as next_month_claims
FROM monthly_claims
ORDER BY loss_month;
```

## 🏢 Business Intelligence with Window Functions

### Agent Performance with Rankings
```sql
SELECT 
    con.contact_name as agent_name,
    COUNT(DISTINCT r.revision_id) as policies_written,
    SUM(p.payment_amount) as total_revenue,
    SUM(cd.commission_amount) as total_commission,
    RANK() OVER (ORDER BY SUM(p.payment_amount) DESC) as revenue_rank,
    RANK() OVER (ORDER BY SUM(cd.commission_amount) DESC) as commission_rank,
    ROUND(SUM(cd.commission_amount) / SUM(p.payment_amount) * 100, 2) as commission_percentage
FROM v_contacts con
LEFT JOIN v_revisions r ON con.contact_id = r.agent_id
LEFT JOIN v_payments p ON r.policy_number = p.policy_number
LEFT JOIN v_commission_details cd ON con.contact_id = cd.agent_id
WHERE con.roles LIKE '%agent%' 
  AND con.deleted = 0
  AND p.payment_status = 'completed'
  AND cd.commission_status = 'paid'
GROUP BY con.contact_name
ORDER BY total_revenue DESC;
```

### Policy Type Profitability Analysis
```sql
SELECT 
    pt.policy_type_name,
    COUNT(DISTINCT r.revision_id) as policy_count,
    SUM(p.payment_amount) as total_revenue,
    COUNT(c.claim_id) as claim_count,
    ROUND(COUNT(c.claim_id) / COUNT(DISTINCT r.revision_id) * 100, 2) as claim_frequency,
    RANK() OVER (ORDER BY SUM(p.payment_amount) DESC) as revenue_rank,
    RANK() OVER (ORDER BY COUNT(c.claim_id) DESC) as claim_rank
FROM v_policy_types pt
LEFT JOIN v_revisions r ON pt.policy_type_id = r.policy_type_id
LEFT JOIN v_payments p ON r.policy_number = p.policy_number
LEFT JOIN v_claims c ON r.revision_id = c.revision_id
WHERE pt.active = 1
  AND p.payment_status = 'completed'
GROUP BY pt.policy_type_name
ORDER BY total_revenue DESC;
```

## 💡 Window Function Best Practices

### 1**Choose Appropriate Window Frame**
```sql
-- For running totals
ROWS UNBOUNDED PRECEDING

-- For moving averages
ROWS BETWEEN N PRECEDING AND CURRENT ROW

-- For specific ranges
RANGE BETWEEN INTERVAL 30 DAY PRECEDING AND CURRENT ROW
```

### 2**Use PARTITION BY for Grouped Analysis**
```sql
PARTITION BY agent_id ORDER BY commission_date
```
This creates separate calculations for each agent.

### 3**Consider Performance with Large Datasets**
```sql
-- Limit the window frame for better performance
ROWS BETWEEN 12 PRECEDING AND CURRENT ROW
```

### 4**Combine with Other Aggregations**
```sql
SUM(SUM(payment_amount)) OVER (ORDER BY month)
```
Use nested aggregations for complex calculations.

## 📝 Practice Questions

1. **How do you calculate a 6-month moving average of claims?**
2. **What's the rank of each agent by total commission?**
3. **How do you find month-over-month revenue growth?**
4. **Which policy types are in the top 25 by revenue?**

## 🔗 Next Steps

Congratulations! You've completed the comprehensive SQL Editor training course. You now have the skills to:
- Navigate BriteCore's logical layer views
- Perform complex data analysis
- Create business intelligence reports
- Build executive dashboards
- Use advanced SQL techniques

---

**💡 Pro Tip**: Window functions are powerful but can be resource-intensive. Always test with smaller datasets first and consider the performance implications of your window frame specifications. 