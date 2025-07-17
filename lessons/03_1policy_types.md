# Lesson3.1: Policy Types and Forms

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
| `policy_type_name` | VARCHAR | Name of policy type | Human-readable identification |
| `policy_type_code` | VARCHAR | Short code for policy type | System identification |
| `active` | TINYINT |1ive, 0 if inactive | Filtering active policy types |
| `form_name` | VARCHAR | Associated form name | Form tracking |
| `form_code` | VARCHAR | Form code | Form identification |

## 🔍 Basic Policy Type Queries

### 1. All Active Policy Types
```sql
SELECT 
    policy_type_name,
    policy_type_code,
    form_name
FROM v_policy_types
WHERE active =1DER BY policy_type_name;
```

### 2licy Types by Form
```sql
SELECT 
    form_name,
    COUNT(*) as policy_type_count
FROM v_policy_types
WHERE active = 1
GROUP BY form_name
ORDER BY policy_type_count DESC;
```

### 3. Policy Type Summary
```sql
SELECT Total Policy Types' as metric,
    COUNT(*) as value
FROM v_policy_types
WHERE active = 1UNION ALL
SELECT 
Active Policy Types',
    COUNT(*)
FROM v_policy_types
WHERE active = 1UNION ALL
SELECT 
  Inactive Policy Types',
    COUNT(*)
FROM v_policy_types
WHERE active = 0;
```

## 🏗️ Policy Type Analysis

### Policy Types with Most Policies
```sql
SELECT 
    pt.policy_type_name,
    COUNT(r.revision_id) as policy_count
FROM v_policy_types pt
LEFT JOIN v_revisions r ON pt.policy_type_id = r.policy_type_id
WHERE pt.active = 1
GROUP BY pt.policy_type_name
ORDER BY policy_count DESC;
```

### Policy Types by Year
```sql
SELECT 
    pt.policy_type_name,
    YEAR(r.date_added) as policy_year,
    COUNT(r.revision_id) as policy_count
FROM v_policy_types pt
LEFT JOIN v_revisions r ON pt.policy_type_id = r.policy_type_id
WHERE pt.active = 1  AND r.date_added IS NOT NULL
GROUP BY pt.policy_type_name, YEAR(r.date_added)
ORDER BY pt.policy_type_name, policy_year DESC;
```

## 📋 Policy Forms Analysis

### Forms with Multiple Policy Types
```sql
SELECT 
    form_name,
    COUNT(*) as policy_type_count,
    GROUP_CONCAT(policy_type_name ORDER BY policy_type_name SEPARATOR ', ) as policy_types
FROM v_policy_types
WHERE active = 1D form_name IS NOT NULL
GROUP BY form_name
HAVING COUNT(*) >1DER BY policy_type_count DESC;
```

### Policy Types Without Forms
```sql
SELECT 
    policy_type_name,
    policy_type_code
FROM v_policy_types
WHERE active = 1 form_name IS NULL
ORDER BY policy_type_name;
```

## 🎯 Business Intelligence Queries

### Policy Type Portfolio Analysis
```sql
SELECT 
    pt.policy_type_name,
    COUNT(r.revision_id) as total_policies,
    COUNT(CASE WHEN r.active = 1 THEN 1as active_policies,
    COUNT(CASE WHEN r.active = 0 THEN 1END) as inactive_policies
FROM v_policy_types pt
LEFT JOIN v_revisions r ON pt.policy_type_id = r.policy_type_id
WHERE pt.active = 1
GROUP BY pt.policy_type_name
ORDER BY total_policies DESC;
```

### Policy Type Growth Analysis
```sql
SELECT 
    pt.policy_type_name,
    COUNT(CASE WHEN YEAR(r.date_added) = YEAR(CURDATE()) THEN 1 END) as policies_this_year,
    COUNT(CASE WHEN YEAR(r.date_added) = YEAR(CURDATE()) - 1 THEN 1) as policies_last_year
FROM v_policy_types pt
LEFT JOIN v_revisions r ON pt.policy_type_id = r.policy_type_id
WHERE pt.active = 1
GROUP BY pt.policy_type_name
HAVING policies_this_year > 0policies_last_year > 0
ORDER BY policies_this_year DESC;
```

## 🔗 Related Views

### v_policy_type_items
Contains individual items within policy types:
```sql
SELECT 
    pti.item_name,
    pti.item_type,
    pt.policy_type_name
FROM v_policy_type_items pti
JOIN v_policy_types pt ON pti.policy_type_id = pt.policy_type_id
WHERE pt.active = 1
ORDER BY pt.policy_type_name, pti.item_name;
```

### v_policy_type_items_forms
Contains form information for policy type items:
```sql
SELECT 
    ptif.form_name,
    ptif.form_code,
    pt.policy_type_name
FROM v_policy_type_items_forms ptif
JOIN v_policy_types pt ON ptif.policy_type_id = pt.policy_type_id
WHERE pt.active = 1
ORDER BY pt.policy_type_name, ptif.form_name;
```

## 💡 Best Practices for Policy Type Analysis

### 1**Always Filter by Active Policy Types**
```sql
WHERE active = 1`
This ensures you're only working with current, available policy types.

### 2. **Use LEFT JOINs for Comprehensive Analysis**
```sql
FROM v_policy_types pt
LEFT JOIN v_revisions r ON pt.policy_type_id = r.policy_type_id
```
This shows all policy types, even those without policies.

### 3. **Handle NULL Values in Forms**
```sql
WHERE form_name IS NOT NULL
```
Many policy types may not have associated forms.

### 4**Use GROUP_CONCAT for Readable Lists**
```sql
GROUP_CONCAT(policy_type_name ORDER BY policy_type_name SEPARATOR ', ')
```
This creates readable lists in your results.

## 📝 Practice Questions

1. **How many active policy types do you have?**2Which policy types are most popular (have the most policies)?**
3e there any policy types without associated forms?**
4. **How has policy type usage changed over the last year?**

## 🔗 Next Steps

In the next lesson, we'll explore property data using v_properties, including:
- Property characteristics and types
- Geographic analysis
- Construction type analysis
- Property vs policy relationships

---

**💡 Pro Tip**: Policy types are the foundation of your insurance portfolio. Understanding their distribution and usage patterns helps with product development and business planning. 