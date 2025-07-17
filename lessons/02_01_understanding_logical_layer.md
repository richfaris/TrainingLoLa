# Lesson 1.1: Understanding the Logical Layer

## 🔍 How to See All BriteCore Views and Fields

To see a complete list of all BriteCore views, their fields, types, and descriptions, run this in your SQL editor:
```sql
SELECT * FROM v_logical_catalog;
```
This is your primary reference for writing queries! You can also browse a formatted version in [`views/logical_catalog_reference.md`](../views/logical_catalog_reference.md).

## 🎯 Learning Objectives
- Understand what the logical layer is and why it exists
- Learn how BriteCore views simplify data access
- Explore the structure of key views
- Understand the benefits of using views vs. raw tables

## 📚 What is the Logical Layer?

The **Logical Layer** is BriteCore's way of simplifying complex database access. Instead of dealing with dozens of interconnected tables, you work with **views** that present data in a business-friendly format.

### Why Use Views Instead of Raw Tables?

| Raw Tables | Logical Layer Views |
|------------|-------------------|
| Complex relationships | Simple, flat structure |
| Technical field names | Business-friendly names |
| Multiple joins required | Pre-joined data |
| Hard to understand | Self-documenting |
| Performance concerns | Optimized queries |

## 🏗️ How Views Work

Views are like **virtual tables** that:
- Combine data from multiple tables
- Apply business logic and calculations
- Provide consistent field names
- Handle complex relationships automatically

### Example: v_contacts View

Instead of writing this complex query(which is NOT compatible with SQL Editor):
```sql
SELECT 
    c.id,
    c.name,
    c.type,
    a.addressLine1,
    a.addressCity,
    a.addressState,
    a.addressZip
FROM contacts c
LEFT JOIN addresses a ON a.contactId = c.id 
    AND a.type LIKE 'Mailing%'
WHERE c.active = 1;
```

You can simply write:
```sql
SELECT 
    contact_id,
    contact_name,
    contact_type,
    address_line_1,
    address_city,
    address_state,
    address_zip
FROM v_contacts
WHERE deleted = 0;
```

## 📊 Key BriteCore Views

### Core Business Views

#### 1. **v_contacts** - All Contact Information
- **Purpose**: Single source for all contact data
- **Key Fields**: 
  - `contact_id` - Unique identifier
  - `contact_name` - Full name
  - `contact_type` - Individual or Organization
  - `primary_email`, `primary_phone` - Contact methods
  - `full_address` - Complete address
  - `roles` - Assigned roles (agent, insured, etc.)

#### 2. **v_claims** - Claims Data
- **Purpose**: Claims with policy relationships
- **Key Fields**:
  - `claim_id`, `claim_number` - Claim identifiers
  - `claim_status`, `claim_type` - Status information
  - `loss_date`, `date_reported` - Timing
  - `loss_location_address` - Where the loss occurred
  - `policy_number` - Related policy

#### 3. **v_properties** - Property Information
- **Purpose**: Property details and addresses
- **Key Fields**:
  - `property_id` - Unique identifier
  - `property_type` - Type of property
  - `address_line_1`, `address_city`, `address_state`
  - `construction_type`, `year_built`
  - `policy_number` - Associated policy

#### 4. **v_payments** - Payment Processing
- **Purpose**: All payment transactions
- **Key Fields**:
  - `payment_id` - Unique identifier
  - `transaction_amount`, `transaction_date_time`
  - `payment_instrument` - How payment was made
  - `completed` - Payment completion status
  - `invoice_number` - Related invoice

## 🔍 View Naming Convention

BriteCore views follow a consistent naming pattern:
- **v_** prefix indicates it's a view
- **Descriptive name** tells you what data it contains
- **Examples**: `v_contacts`, `v_claims`, `v_payments`

## 📋 View Documentation

Each view includes built-in documentation:
- **Field descriptions** in the view definition
- **Business logic** explanations
- **Data relationships** clearly defined
- **Performance considerations** noted

## 🛠️ Your First Query

Let's start with a simple query to explore the v_contacts view:

```sql
-- Basic contact information
SELECT 
    contact_id,
    contact_name,
    contact_type,
    primary_email
FROM v_contacts
LIMIT 10;
```



## 🔗 Next Steps

In the next lesson, we'll set up your SQL editor and write your first queries with BriteCore views!

---

**💡 Pro Tip**: Views are your friends! They handle the complexity so you can focus on getting the data you need. 