# Lesson 3.1: Policy Types and Forms

## 🎯 Learning Objectives
- Understand the structure of v_policy_types view
- Analyze policy type distributions
- Work with policy forms and configurations
- Create policy type summary reports
- Understand the relationship between policy types and other business data

## 📊 Understanding v_policy_types Structure

The `v_policy_types` view contains information about different types of insurance policies available in BriteCore. This is fundamental for understanding your insurance portfolio.

### Key Fields in v_policy_types

| Field | Type | Description | Business Use |
|-------|------|-------------|--------------|
| `policy_type_id` | INT | Unique policy type identifier | Primary key for policy types |
| `policy_type` | VARCHAR | Name of policy type | Human-readable identification |
| `line_of_business` | VARCHAR | Line of business | Business categorization |
| `state` | VARCHAR | State availability | Geographic availability |
| `active` | TINYINT | 1 if active, 0 if inactive | Filtering active policy types |

## 🔍 Basic Policy Type Queries

### 1. All Active Policy Types
```sql
SELECT 
    policy_type,
    line_of_business,
    state
FROM v_policy_types
ORDER BY policy_type;
```

### 2. Policy Types by Line of Business
```sql
SELECT 
    line_of_business,
    COUNT(*) as policy_type_count
FROM v_policy_types
GROUP BY line_of_business
ORDER BY policy_type_count DESC;
```

### 3. Policy Type Summary
```sql
SELECT 'Total Policy Types' as metric,
    COUNT(*) as value
FROM v_policy_types
UNION ALL
SELECT 
    'Policy Types by Line of Business',
    COUNT(*)
FROM v_policy_types
WHERE line_of_business IS NOT NULL
UNION ALL
SELECT 
    'Policy Types by State',
    COUNT(*)
FROM v_policy_types
WHERE state IS NOT NULL;
```

## 🏗️ Policy Type Analysis

### Policy Types with Most Policies
```sql
SELECT 
    pt.policy_type,
    COUNT(r.revision_id) as policy_count
FROM v_policy_types pt
LEFT JOIN v_revisions r ON pt.policy_type_id = r.policy_type_id
GROUP BY pt.policy_type
ORDER BY policy_count DESC;
```

### Policy Types by Year
```sql
SELECT 
    pt.policy_type,
    YEAR(r.date_added) as policy_year,
    COUNT(r.revision_id) as policy_count
FROM v_policy_types pt
LEFT JOIN v_revisions r ON pt.policy_type_id = r.policy_type_id
WHERE r.date_added IS NOT NULL
GROUP BY pt.policy_type, YEAR(r.date_added)
ORDER BY pt.policy_type, policy_year DESC;
```

## 📋 Policy Forms Analysis

### Lines of Business with Multiple Policy Types
```sql
SELECT 
    line_of_business,
    COUNT(*) as policy_type_count,
    GROUP_CONCAT(policy_type ORDER BY policy_type SEPARATOR ', ') as policy_types
FROM v_policy_types
WHERE line_of_business IS NOT NULL
GROUP BY line_of_business
HAVING COUNT(*) > 1
ORDER BY policy_type_count DESC;
```

### Policy Types Without Line of Business
```sql
SELECT 
    policy_type,
    state
FROM v_policy_types
WHERE line_of_business IS NULL
ORDER BY policy_type;
```

## 🎯 Business Intelligence Queries

### Policy Type Portfolio Analysis
```sql
SELECT 
    pt.policy_type,
    COUNT(r.revision_id) as total_policies,
    COUNT(CASE WHEN r.active = 1 THEN 1 END) as active_policies,
    COUNT(CASE WHEN r.active = 0 THEN 1 END) as inactive_policies
FROM v_policy_types pt
LEFT JOIN v_revisions r ON pt.policy_type_id = r.policy_type_id
GROUP BY pt.policy_type
ORDER BY total_policies DESC;
```

### Policy Type Growth Analysis
```sql
SELECT 
    pt.policy_type,
    COUNT(CASE WHEN YEAR(r.date_added) = YEAR(CURDATE()) THEN 1 END) as policies_this_year,
    COUNT(CASE WHEN YEAR(r.date_added) = YEAR(CURDATE()) - 1 THEN 1 END) as policies_last_year
FROM v_policy_types pt
LEFT JOIN v_revisions r ON pt.policy_type_id = r.policy_type_id
GROUP BY pt.policy_type
HAVING policies_this_year > 0 OR policies_last_year > 0
ORDER BY policies_this_year DESC;
```

## 🔗 Related Views

### v_policy_type_items
Contains individual items within policy types:
```sql
SELECT 
    pti.item_name,
    pti.item_type,
    pt.policy_type
FROM v_policy_type_items pti
JOIN v_policy_types pt ON pti.policy_type_id = pt.policy_type_id
ORDER BY pt.policy_type, pti.item_name;
```

### v_policy_type_items_forms
Contains form information for policy type items:
```sql
SELECT 
    ptif.form_name,
    ptif.form_code,
    pt.policy_type
FROM v_policy_type_items_forms ptif
JOIN v_policy_types pt ON ptif.policy_type_id = pt.policy_type_id
ORDER BY pt.policy_type, ptif.form_name;
```

## 💡 Best Practices for Policy Type Analysis

### 1. **Always Filter by Active Policy Types**
```sql
WHERE active = 1
```
This ensures you're only working with current, available policy types.

### 2. **Use LEFT JOINs for Comprehensive Analysis**
```sql
FROM v_policy_types pt
LEFT JOIN v_revisions r ON pt.policy_type_id = r.policy_type_id
```
This shows all policy types, even those without policies.

### 3. **Handle NULL Values in Line of Business**
```sql
WHERE line_of_business IS NOT NULL
```
Many policy types may not have associated line of business.

### 4. **Use GROUP_CONCAT for Readable Lists**
```sql
GROUP_CONCAT(policy_type ORDER BY policy_type SEPARATOR ', ')
```
This creates readable lists in your results.

## 📝 Practice Questions

1. **How many policy types do you have?**
2. **Which policy types are most popular (have the most policies)?**
3. **Are there any policy types without associated line of business?**
4. **How has policy type usage changed over the last year?**

## 🔗 Next Steps

In the next lesson, we'll explore property data using v_properties, including:
- Property characteristics and types
- Geographic analysis
- Construction type analysis
- Property vs policy relationships

---

**💡 Pro Tip**: Policy types are the foundation of your insurance portfolio. Understanding their distribution and usage patterns helps with product development and business planning. 