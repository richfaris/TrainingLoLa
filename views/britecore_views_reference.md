# BriteCore Views Reference Guide 📊

This guide provides comprehensive documentation for all BriteCore logical layer views. Use this as your go-to reference when writing SQL queries.

## 📋 View Categories

### 🔗 Core Business Views
- [v_contacts](#v_contacts) - Contact information
- [v_claims](#v_claims) - Claims data
- [v_properties](#v_properties) - Property information
- [v_policy_types](#v_policy_types) - Policy type definitions
- [v_payments](#v_payments) - Payment processing
- [v_commission_details](#v_commission_details) - Commission tracking

### 📍 Supporting Views
- [v_addresses](#v_addresses) - Address management
- [v_notes](#v_notes) - System notes
- [v_files](#v_files) - Document management
- [v_system_tags](#v_system_tags) - Tagging system

---

## 🔗 Core Business Views

### v_contacts
**Purpose**: Single source for all contact information (agents, insureds, vendors, etc.)

#### Key Fields
| Field | Type | Description |
|-------|------|-------------|
| `contact_id` | INT | Unique contact identifier |
| `contact_name` | VARCHAR | Full name of contact |
| `contact_type` | VARCHAR | 'individual' or 'organization' |
| `deleted` | TINYINT | 1 if contact is soft deleted, 0 if active |
| `primary_email` | VARCHAR | Primary email address |
| `primary_phone` | VARCHAR | Primary phone number |
| `cell_phone` | VARCHAR | Cell phone number |
| `home_phone` | VARCHAR | Home phone number |
| `work_phone` | VARCHAR | Work phone number |
| `full_address` | VARCHAR | Complete formatted address |
| `address_line_1` | VARCHAR | Street address line 1 |
| `address_city` | VARCHAR | City |
| `address_state` | VARCHAR | State |
| `address_zip` | VARCHAR | ZIP code |
| `roles` | VARCHAR | Comma-separated list of assigned roles |
| `system_tags` | VARCHAR | System tags for categorization |

#### Example Queries
```sql
-- Find all active agents
SELECT contact_name, primary_email, roles
FROM v_contacts
WHERE deleted = 0 
  AND roles LIKE '%agent%';

-- Find contacts in specific state
SELECT contact_name, full_address
FROM v_contacts
WHERE address_state = 'CA'
  AND deleted = 0;
```

---

### v_claims
**Purpose**: Claims data with policy relationships and loss information

#### Key Fields
| Field | Type | Description |
|-------|------|-------------|
| `claim_id` | INT | Unique claim identifier |
| `claim_number` | VARCHAR | Human-readable claim number |
| `claim_status` | VARCHAR | Current status (open, closed, etc.) |
| `claim_type` | VARCHAR | Type of claim |
| `claim_active_flag` | TINYINT | 1 if claim is active |
| `policy_number` | VARCHAR | Associated policy number |
| `revision_id` | INT | Policy revision ID |
| `loss_date` | DATE | Date of loss |
| `date_reported` | DATE | Date claim was reported |
| `date_added` | DATETIME | When claim was created |
| `last_modified` | DATETIME | Last modification date |
| `description` | TEXT | Claim description |
| `loss_location_address` | VARCHAR | Where loss occurred |
| `loss_cause` | VARCHAR | Cause of loss (perils) |
| `claim_system_tags` | VARCHAR | System tags for claim |

#### Example Queries
```sql
-- Find all open claims
SELECT claim_number, policy_number, loss_date, description
FROM v_claims
WHERE claim_status = 'open'
  AND claim_active_flag = 1;

-- Claims by loss cause
SELECT loss_cause, COUNT(*) as claim_count
FROM v_claims
WHERE claim_active_flag = 1
GROUP BY loss_cause
ORDER BY claim_count DESC;
```

---

### v_properties
**Purpose**: Property information including addresses and characteristics

#### Key Fields
| Field | Type | Description |
|-------|------|-------------|
| `property_id` | INT | Unique property identifier |
| `property_type` | VARCHAR | Type of property |
| `address_line_1` | VARCHAR | Street address |
| `address_city` | VARCHAR | City |
| `address_state` | VARCHAR | State |
| `address_zip` | VARCHAR | ZIP code |
| `address_county` | VARCHAR | County |
| `construction_type` | VARCHAR | Construction type |
| `year_built` | INT | Year property was built |
| `policy_number` | VARCHAR | Associated policy |
| `revision_id` | INT | Policy revision ID |

#### Example Queries
```sql
-- Properties by construction type
SELECT construction_type, COUNT(*) as property_count
FROM v_properties
GROUP BY construction_type
ORDER BY property_count DESC;

-- Properties built in specific year range
SELECT address_line_1, address_city, year_built
FROM v_properties
WHERE year_built BETWEEN 2000 AND 2010
ORDER BY year_built;
```

---

### v_policy_types
**Purpose**: Policy type definitions and form information

#### Key Fields
| Field | Type | Description |
|-------|------|-------------|
| `policy_type_id` | INT | Unique policy type identifier |
| `policy_type_name` | VARCHAR | Name of policy type |
| `policy_type_code` | VARCHAR | Short code |
| `active` | TINYINT | 1 if active, 0 if inactive |
| `form_name` | VARCHAR | Associated form name |
| `form_code` | VARCHAR | Form code |

#### Example Queries
```sql
-- All active policy types
SELECT policy_type_name, policy_type_code
FROM v_policy_types
WHERE active = 1
ORDER BY policy_type_name;

-- Policy types by form
SELECT form_name, COUNT(*) as policy_type_count
FROM v_policy_types
WHERE active = 1
GROUP BY form_name;
```

---

### v_payments
**Purpose**: Payment processing and transaction data

#### Key Fields
| Field | Type | Description |
|-------|------|-------------|
| `payment_id` | INT | Unique payment identifier |
| `payment_amount` | DECIMAL | Payment amount |
| `payment_date` | DATE | Date of payment |
| `payment_method` | VARCHAR | How payment was made |
| `payment_status` | VARCHAR | Current status |
| `policy_number` | VARCHAR | Associated policy |
| `batch_id` | INT | Payment batch identifier |

#### Example Queries
```sql
-- Payments by method
SELECT payment_method, COUNT(*) as payment_count, SUM(payment_amount) as total_amount
FROM v_payments
WHERE payment_status = 'completed'
GROUP BY payment_method;

-- Daily payment totals
SELECT payment_date, COUNT(*) as payment_count, SUM(payment_amount) as daily_total
FROM v_payments
WHERE payment_status = 'completed'
GROUP BY payment_date
ORDER BY payment_date DESC;
```

---

### v_commission_details
**Purpose**: Commission tracking and calculations

#### Key Fields
| Field | Type | Description |
|-------|------|-------------|
| `commission_id` | INT | Unique commission identifier |
| `agent_id` | INT | Agent identifier |
| `policy_number` | VARCHAR | Associated policy |
| `commission_amount` | DECIMAL | Commission amount |
| `commission_rate` | DECIMAL | Commission rate |
| `commission_date` | DATE | Date commission earned |
| `commission_status` | VARCHAR | Status of commission |

#### Example Queries
```sql
-- Agent commission totals
SELECT agent_id, SUM(commission_amount) as total_commission
FROM v_commission_details
WHERE commission_status = 'paid'
GROUP BY agent_id
ORDER BY total_commission DESC;

-- Commission by date range
SELECT commission_date, SUM(commission_amount) as daily_commission
FROM v_commission_details
WHERE commission_date BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY commission_date
ORDER BY commission_date;
```

---

## 📍 Supporting Views

### v_addresses
**Purpose**: Address management and validation

#### Key Fields
| Field | Type | Description |
|-------|------|-------------|
| `address_id` | INT | Unique address identifier |
| `contact_id` | INT | Associated contact |
| `address_type` | VARCHAR | Type of address |
| `address_line_1` | VARCHAR | Street address |
| `address_city` | VARCHAR | City |
| `address_state` | VARCHAR | State |
| `address_zip` | VARCHAR | ZIP code |

### v_notes
**Purpose**: System notes and comments

#### Key Fields
| Field | Type | Description |
|-------|------|-------------|
| `note_id` | INT | Unique note identifier |
| `note_type` | VARCHAR | Type of note |
| `note_text` | TEXT | Note content |
| `created_date` | DATETIME | When note was created |
| `contact_id` | INT | Associated contact (if applicable) |

### v_files
**Purpose**: Document management

#### Key Fields
| Field | Type | Description |
|-------|------|-------------|
| `file_id` | INT | Unique file identifier |
| `file_name` | VARCHAR | Name of file |
| `file_type` | VARCHAR | File type/extension |
| `file_size` | INT | File size in bytes |
| `upload_date` | DATETIME | When file was uploaded |

### v_system_tags
**Purpose**: Tagging and categorization system

#### Key Fields
| Field | Type | Description |
|-------|------|-------------|
| `tag_id` | INT | Unique tag identifier |
| `tag_name` | VARCHAR | Name of tag |
| `tag_category` | VARCHAR | Category of tag |
| `tag_description` | TEXT | Description of tag |

---

## 🎯 Common Query Patterns

### 1. **Basic Data Retrieval**
```sql
SELECT [fields] FROM [view] WHERE [conditions];
```

### 2. **Aggregations**
```sql
SELECT [group_field], COUNT(*), SUM([numeric_field])
FROM [view]
GROUP BY [group_field];
```

### 3. **Date Filtering**
```sql
SELECT * FROM [view]
WHERE [date_field] BETWEEN '2024-01-01' AND '2024-12-31';
```

### 4. **Text Search**
```sql
SELECT * FROM [view]
WHERE [text_field] LIKE '%search_term%';
```

### 5. **Joining Views**
```sql
SELECT c.contact_name, cl.claim_number
FROM v_contacts c
JOIN v_claims cl ON c.contact_id = cl.contact_id;
```

---

## 💡 Best Practices

1. **Always use LIMIT** when exploring data
2. **Check for NULL values** in important fields
3. **Use appropriate date formats** (YYYY-MM-DD)
4. **Test queries on small datasets** first
5. **Use meaningful field aliases** for clarity

---

## 🔍 Performance Tips

- Views are optimized for common query patterns
- Use indexed fields in WHERE clauses when possible
- Avoid SELECT * in production queries
- Use appropriate data types for comparisons

---

*This reference guide covers the most commonly used BriteCore views. For complete documentation of all 763+ views, refer to the generated Excel file: `LoLa_Item_Details.xlsx`* 