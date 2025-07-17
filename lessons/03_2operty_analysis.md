# Lesson 3.2: Property Analysis and Risk Assessment

## 🎯 Learning Objectives
- Understand the structure of v_properties view
- Analyze property characteristics and types
- Perform geographic risk analysis
- Create property vs policy relationship queries
- Build property portfolio dashboards

## 📊 Understanding v_properties Structure

The `v_properties` view contains detailed information about insured properties. This is essential for risk assessment and geographic analysis.

### Key Fields in v_properties

| Field | Type | Description | Business Use |
|-------|------|-------------|--------------|
| `property_id` | INT | Unique property identifier | Primary key for properties |
| `property_type` | VARCHAR | Type of property | Property categorization |
| `construction_type` | VARCHAR | Building construction | Risk assessment |
| `address_city` | VARCHAR | City location | Geographic analysis |
| `address_state` | VARCHAR | State location | Geographic analysis |
| `address_zip` | VARCHAR | ZIP code | Geographic analysis |
| `year_built` | INT | Year property was built | Age analysis |
| `square_footage` | DECIMAL | Property size | Size analysis |
| `active` | TINYINT | 1 if active | Filtering active properties |

## 🔍 Basic Property Queries

### 1. All Active Properties
```sql
SELECT 
    property_id,
    property_type,
    construction_type,
    address_city,
    address_state
FROM v_properties
WHERE active =1DER BY address_city, address_state
LIMIT 10;
```

### 2. Properties by Type
```sql
SELECT 
    property_type,
    COUNT(*) as property_count
FROM v_properties
WHERE active = 1
GROUP BY property_type
ORDER BY property_count DESC;
```

### 3. Construction Types Analysis
```sql
SELECT 
    construction_type,
    COUNT(*) as property_count,
    AVG(square_footage) as avg_square_footage
FROM v_properties
WHERE active =1 construction_type IS NOT NULL
GROUP BY construction_type
ORDER BY property_count DESC;
```

## 🗺️ Geographic Analysis

### Properties by City
```sql
SELECT 
    address_city,
    address_state,
    COUNT(*) as property_count
FROM v_properties
WHERE active =1 address_city IS NOT NULL
GROUP BY address_city, address_state
ORDER BY property_count DESC
LIMIT 20;
```

### Geographic Distribution by State
```sql
SELECT 
    address_state,
    COUNT(*) as property_count,
    COUNT(DISTINCT address_city) as cities_covered
FROM v_properties
WHERE active =1dress_state IS NOT NULL
GROUP BY address_state
ORDER BY property_count DESC;
```

### Property Density Analysis
```sql
SELECT 
    address_zip,
    address_city,
    address_state,
    COUNT(*) as property_count
FROM v_properties
WHERE active =1 address_zip IS NOT NULL
GROUP BY address_zip, address_city, address_state
HAVING property_count >= 5
ORDER BY property_count DESC;
```

## 🏗️ Property Characteristics Analysis

### Age Analysis
```sql
SELECT 
    CASE 
        WHEN year_built < 1950Pre-1950
        WHEN year_built BETWEEN 1950AND 1979 THEN '19501979
        WHEN year_built BETWEEN 1980AND 1999 THEN '19801999
        WHEN year_built BETWEEN 200AND 2019 THEN '20002019
        WHEN year_built >= 2020EN '220     ELSEUnknown'
    END as age_category,
    COUNT(*) as property_count,
    AVG(square_footage) as avg_square_footage
FROM v_properties
WHERE active =1
GROUP BY 
    CASE 
        WHEN year_built < 1950Pre-1950
        WHEN year_built BETWEEN 1950AND 1979 THEN '19501979
        WHEN year_built BETWEEN 1980AND 1999 THEN '19801999
        WHEN year_built BETWEEN 200AND 2019 THEN '20002019
        WHEN year_built >= 2020EN '220     ELSE Unknown
    END
ORDER BY property_count DESC;
```

### Size Analysis
```sql
SELECT 
    CASE 
        WHEN square_footage < 10 THEN Under 1,0q ft'
        WHEN square_footage BETWEEN 1000 AND 1999 THEN 1,000-1,999q ft'
        WHEN square_footage BETWEEN 2000 AND 2999 THEN 2,000-2,999q ft'
        WHEN square_footage BETWEEN 3000 AND 4999 THEN 3,000-4,999q ft'
        WHEN square_footage >=500THEN '5,00q ft'
        ELSEUnknown'
    END as size_category,
    COUNT(*) as property_count
FROM v_properties
WHERE active =1
GROUP BY 
    CASE 
        WHEN square_footage < 10 THEN Under 1,0q ft'
        WHEN square_footage BETWEEN 1000 AND 1999 THEN 1,000-1,999q ft'
        WHEN square_footage BETWEEN 2000 AND 2999 THEN 2,000-2,999q ft'
        WHEN square_footage BETWEEN 3000 AND 4999 THEN 3,000-4,999q ft'
        WHEN square_footage >=500THEN '5,00q ft'
        ELSE Unknown
    END
ORDER BY property_count DESC;
```

## 🎯 Property vs Policy Analysis

### Properties by Policy Type
```sql
SELECT 
    pt.policy_type_name,
    COUNT(prop.property_id) as property_count,
    AVG(prop.square_footage) as avg_square_footage
FROM v_properties prop
JOIN v_policy_types pt ON prop.policy_type_id = pt.policy_type_id
WHERE prop.active =1 pt.active =1
GROUP BY pt.policy_type_name
ORDER BY property_count DESC;
```

### Property Risk Analysis
```sql
SELECT 
    prop.property_type,
    prop.construction_type,
    COUNT(prop.property_id) as property_count,
    COUNT(c.claim_id) as claim_count,
    ROUND(COUNT(c.claim_id) / COUNT(prop.property_id) * 100claim_rate_percent
FROM v_properties prop
LEFT JOIN v_claims c ON prop.property_id = c.loss_address_id
WHERE prop.active =1
GROUP BY prop.property_type, prop.construction_type
HAVING property_count >= 5
ORDER BY claim_rate_percent DESC;
```

## 📊 Property Portfolio Dashboards

### Property Summary Dashboard
```sql
SELECT Total Properties' as metric,
    COUNT(*) as value
FROM v_properties
WHERE active =1UNION ALL
SELECTProperties by Type',
    COUNT(DISTINCT property_type)
FROM v_properties
WHERE active =1UNION ALL
SELECTCities Covered',
    COUNT(DISTINCT address_city)
FROM v_properties
WHERE active =1 address_city IS NOT NULL
UNION ALL
SELECTStates Covered',
    COUNT(DISTINCT address_state)
FROM v_properties
WHERE active =1dress_state IS NOT NULL
UNION ALL
SELECTAverage Square Footage,  ROUND(AVG(square_footage),0v_properties
WHERE active =1 square_footage IS NOT NULL;
```

### Geographic Risk Dashboard
```sql
SELECT 
    address_city,
    address_state,
    COUNT(prop.property_id) as property_count,
    COUNT(c.claim_id) as claim_count,
    ROUND(COUNT(c.claim_id) / COUNT(prop.property_id) * 100claim_rate_percent
FROM v_properties prop
LEFT JOIN v_claims c ON prop.property_id = c.loss_address_id
WHERE prop.active =1 prop.address_city IS NOT NULL
GROUP BY address_city, address_state
HAVING property_count >=10RDER BY claim_rate_percent DESC
LIMIT 10;
```

## 💡 Property Analysis Best Practices

### 1**Always Filter by Active Properties**
```sql
WHERE active = 1`
This ensures youre only analyzing current, insured properties.

### 2**Handle NULL Values in Geographic Data**
```sql
WHERE address_city IS NOT NULL
```
Many properties may have incomplete address information.

### 3se Appropriate Aggregations for Size/Age**
```sql
AVG(square_footage) as avg_square_footage
```
Use averages for continuous data like square footage.

### 4**Group by Geographic Hierarchy**
```sql
GROUP BY address_city, address_state
```
This provides meaningful geographic groupings.

## 📝 Practice Questions

1**How many properties do you have in each state?**
2. **Whats the most common construction type?**3*Which cities have the highest property density?**
4. **How do property characteristics relate to claims?**

## 🔗 Next Steps

In the next lesson, we'll explore financial data analysis, including:
- Payment processing and revenue analysis
- Commission tracking and agent performance
- Financial reporting and dashboards
- Revenue vs claims correlation

---

**💡 Pro Tip**: Property analysis is crucial for risk assessment. Always consider the relationship between property characteristics and claims history for accurate risk modeling. 