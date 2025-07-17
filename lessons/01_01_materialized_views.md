# Lesson 1.0: Introduction to Materialized Views - m_inforce_policies

## 🎯 Learning Objectives
- Understand what materialized views are and how they differ from regular views
- Learn to query the `m_inforce_policies` materialized view
- Master basic JOIN operations to combine data from multiple views
- Extract data from JSON fields using JSON functions
- Build comprehensive policy reports

## 📊 What is m_inforce_policies?

The `m_inforce_policies` is a **materialized view** that contains all active insurance policies in BriteCore. Unlike regular views that compute data on-the-fly, materialized views store pre-computed results for faster query performance.

### Key Fields in m_inforce_policies

| Field | Type | Description |
|-------|------|-------------|
| `revision_id` | CHAR | Unique identifier for the policy revision |
| `policy_type_id` | CHAR | Type of insurance policy |
| `primary_insured_id` | CHAR | ID of the main policyholder |
| `agency_id` | CHAR | ID of the insurance agency |
| `inforce_premium` | DECIMAL | Current premium amount |

## 🔍 Starting Simple: Basic Query

Let's begin with the most basic query to see what data is available:

```sql
SELECT * FROM m_inforce_policies;
```

**What you'll see:**
- A table with 5 columns containing IDs and premium amounts
- Each row represents one active insurance policy
- The IDs are long alphanumeric strings (UUIDs) that reference other tables
- Premium amounts are decimal values

**Example Results:**
```
revision_id: 666459ba-198e-437b-a495-4f08d44efb28
policy_type_id: abbadb61-bb82-4175-b30a-c74e752af2d0
primary_insured_id: 51338c16-8e3b-4aa9-97ba-1949d1bc7a84
agency_id: 01b39260-6fbd-4a84-9ff2-1c87005d2299
inforce_premium: 994.00
```

## 🔗 Understanding JOINs

**What are JOINs?**
JOINs allow you to combine data from multiple tables or views based on matching values. Think of it like connecting puzzle pieces - you match IDs from one table to IDs in another table to get complete information.

### Types of JOINs:
- **INNER JOIN**: Only shows records that exist in both tables
- **LEFT JOIN**: Shows all records from the left table, even if no match in right table
- **RIGHT JOIN**: Shows all records from the right table, even if no match in left table

## 📋 Simple Policies in Force Report

Now let's create a more useful report by joining with other views to get readable information:

```sql
-- pick ONE address per policy (here: the first alphabetically)
SELECT 
    t.state,
    t.policy_type,
    r.policy_number,
    MIN(l.full_address) AS full_address
FROM m_inforce_policies i
JOIN v_policy_types t ON t.policy_type_id = i.policy_type_id
JOIN v_revisions r ON r.revision_id = i.revision_id
JOIN v_properties l ON l.revision_id = i.revision_id
GROUP BY t.state, t.policy_type, r.policy_number;
```

**What this query does:**
1. **FROM m_inforce_policies i**: Starts with all active policies
2. **JOIN v_policy_types t**: Gets policy type names (like "Homeowners 2") instead of IDs
3. **JOIN v_revisions r**: Gets policy numbers (like "GB-2023-29666") instead of revision IDs
4. **JOIN v_properties l**: Gets property addresses
5. **GROUP BY**: Combines multiple properties per policy, using MIN() to pick one address
6. **MIN(l.full_address)**: Selects the first address alphabetically when a policy has multiple properties

**Example Results:**
```
state: NJ
policy_type: Homeowners 2
policy_number: GB-2023-29666
full_address: 9 W Winifred Ave, Long Beach Township, NJ 08008
```

## 🏗️ Advanced: Extracting JSON Data

Some BriteCore data is stored in JSON format. Let's extract specific information from the `BuilderObject` JSON field:

```sql
SELECT 
    t.state,
    t.policy_type,
    r.policy_number,
    l.full_address,
    max(case c.item_name 
        when 'Property Characteristics' 
        then json_unquote(json_extract(c.builder_obj, '$.categories."Construction Type"'))
    end) as 'Construction Type',
    sum(case c.item_name when 'Coverage A - Dwelling' then c.coverage_limit end) as 'Cov A Limit',
    sum(case c.item_name when 'Coverage B - Other Structures' then c.coverage_limit end) as 'Cov B Lim'
FROM m_inforce_policies i
JOIN v_policy_types t ON t.policy_type_id = i.policy_type_id
JOIN v_revisions r ON r.revision_id = i.revision_id
JOIN v_properties l ON l.revision_id = i.revision_id
JOIN v_property_items c ON c.property_id = l.property_id
WHERE c.item_name IN ('Property Characteristics', 'Coverage A - Dwelling', 'Coverage B - Other Structures')
GROUP BY r.policy_number;
```

**What this query does:**
1. **Same JOINs as before**: Gets policy type, policy number, and address
2. **JOIN v_property_items c**: Accesses detailed property information including JSON data
3. **json_extract()**: Pulls specific data from the JSON field
4. **json_unquote()**: Removes quotes from the extracted JSON value
5. **CASE statements**: Filters and aggregates different types of coverage information

**JSON Extraction Explained:**
- `c.builder_obj` contains JSON data like: `{"categories": {"Construction Type": "Frame"}}`
- `json_extract(c.builder_obj, '$.categories."Construction Type"')` gets the value "Frame"
- `json_unquote()` removes the quotes, giving us just "Frame"

**Note:** This report will not extract data until property categories have been matched to your lines/products. This serves as an example of extracting data from the BuilderObject using the json_unquote mechanism.

## 💡 Key Takeaways

1. **Start Simple**: Always begin with `SELECT *` to see what data is available
2. **Use JOINs**: Connect related tables using matching ID fields
3. **Group When Needed**: Use GROUP BY when you have multiple records per policy
4. **Extract JSON**: Use `json_extract()` and `json_unquote()` for JSON data
5. **Test Incrementally**: Add one JOIN at a time to build complex queries

## 🔗 Next Steps

In the next lesson, we'll explore more materialized views and learn advanced JOIN techniques for comprehensive reporting.

---

**💡 Pro Tip**: Materialized views like `m_inforce_policies` are pre-computed for performance. They're perfect for reports that need to run quickly on large datasets. 