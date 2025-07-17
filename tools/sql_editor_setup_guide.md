# SQL Editor Setup Guide for BriteCore 🛠️

This guide will help you set up your SQL editor to connect to BriteCore databases and start writing queries with the logical layer views.

## 🎯 Recommended SQL Editors

### 🆓 Free Options (Recommended for Beginners)

#### 1. **DBeaver Community Edition**
- **Download**: https://dbeaver.io/download/
- **Pros**: Universal, supports all databases, excellent UI
- **Cons**: Can be resource-intensive
- **Best for**: Most users, especially beginners

#### 2. **HeidiSQL**
- **Download**: https://www.heidisql.com/download.php
- **Pros**: Lightweight, fast, MySQL-focused
- **Cons**: Windows only, limited to MySQL/MariaDB
- **Best for**: Windows users who want simplicity

#### 3. **Beekeeper Studio**
- **Download**: https://www.beekeeperstudio.io/
- **Pros**: Modern interface, cross-platform
- **Cons**: Newer tool, fewer features
- **Best for**: Users who prefer modern UIs

#### 4. **MySQL Workbench**
- **Download**: https://dev.mysql.com/downloads/workbench/
- **Pros**: Official MySQL tool, comprehensive features
- **Cons**: Complex interface, MySQL only
- **Best for**: Advanced users, MySQL specialists

### 💰 Paid Options

#### 1. **DataGrip (JetBrains)**
- **Price**: $199/year (free for students)
- **Pros**: Professional features, excellent code completion
- **Cons**: Expensive, complex
- **Best for**: Professional developers

#### 2. **Navicat**
- **Price**: $199/year
- **Pros**: Feature-rich, excellent UI
- **Cons**: Expensive, resource-intensive
- **Best for**: Enterprise users

#### 3. **TablePlus**
- **Price**: $59/year
- **Pros**: Clean interface, fast
- **Cons**: Limited features compared to others
- **Best for**: Users who prefer simplicity

## 🔧 Connection Setup

### BriteCore Database Connection Details

You'll need these details from your BriteCore administrator:

| Setting | Description | Example |
|---------|-------------|---------|
| **Host** | Database server address | `your-britecore-db.region.rds.amazonaws.com` |
| **Port** | Database port (usually 3306) | `3306` |
| **Database** | Database name | `britecore_production` |
| **Username** | Your database username | `your_username` |
| **Password** | Your database password | `your_password` |
| **SSL** | Usually required for AWS RDS | `Required` |

### Step-by-Step Setup (DBeaver Example)

1. **Download and Install DBeaver**
   - Go to https://dbeaver.io/download/
   - Download Community Edition
   - Install following the wizard

2. **Create New Connection**
   - Open DBeaver
   - Click "New Database Connection" (plug icon)
   - Select "MySQL" from the list
   - Click "Next"

3. **Enter Connection Details**
   ```
   Server Host: your-britecore-db.region.rds.amazonaws.com
   Port: 3306
   Database: britecore_production
   Username: your_username
   Password: your_password
   ```

4. **Configure SSL (if required)**
   - Click "Driver properties" tab
   - Set `useSSL` to `true`
   - Set `requireSSL` to `true` (if required)

5. **Test Connection**
   - Click "Test Connection" button
   - Should see "Connected" message
   - Click "Finish"

## 📊 Exploring BriteCore Views

### Finding Views in Your Editor

Once connected, you should see a structure like this:

```
britecore_production/
├── Tables/          (Raw database tables - avoid these)
├── Views/           (Logical layer views - use these!)
│   ├── v_contacts
│   ├── v_claims
│   ├── v_properties
│   ├── v_payments
│   └── ... (many more)
├── Functions/
└── Procedures/
```

### Key Views to Start With

1. **v_contacts** - All contact information
2. **v_claims** - Claims data
3. **v_properties** - Property information
4. **v_payments** - Payment processing
5. **v_policy_types** - Policy definitions

## 🎯 Your First Query

### 1. Open Query Editor
- Right-click on your connection
- Select "SQL Editor" → "New SQL Script"

### 2. Write Your First Query
```sql
-- Basic contact information
SELECT 
    contact_id,
    contact_name,
    contact_type,
    primary_email
FROM v_contacts
WHERE deleted = 0
LIMIT 10;
```

### 3. Execute the Query
- Click the "Execute SQL Script" button (▶️)
- Or press `Ctrl+Enter` (Windows) / `Cmd+Enter` (Mac)

## 💡 Editor-Specific Tips

### DBeaver Tips
- **Auto-completion**: Press `Ctrl+Space` for suggestions
- **Format SQL**: Press `Ctrl+Shift+F` to format
- **Execute selection**: Select text and press `Ctrl+Enter`
- **Save queries**: Use `.sql` files to save your work

### HeidiSQL Tips
- **Query history**: Press `F5` to see recent queries
- **Quick connect**: Use connection manager for multiple databases
- **Export results**: Right-click results to export to CSV/Excel

### Beekeeper Studio Tips
- **Query bookmarks**: Save frequently used queries
- **Dark mode**: Toggle in preferences
- **Query formatting**: Automatic formatting on save

## 🔒 Security Best Practices

### 1. **Connection Security**
- Always use SSL for database connections
- Never share your database credentials
- Use strong, unique passwords

### 2. **Query Safety**
- Always use `LIMIT` when exploring data
- Test queries on small datasets first
- Avoid `DELETE` or `UPDATE` without `WHERE` clauses

### 3. **Data Protection**
- Don't save sensitive data in query files
- Be careful with `SELECT *` on large tables
- Respect data privacy and company policies

## 🚨 Troubleshooting

### Common Connection Issues

#### "Connection Refused"
- Check if the database server is running
- Verify the host and port are correct
- Ensure your IP is whitelisted (if required)

#### "Access Denied"
- Verify username and password
- Check if your user has proper permissions
- Contact your database administrator

#### "SSL Connection Required"
- Enable SSL in connection settings
- Set `useSSL=true` in driver properties
- Verify SSL certificate if required

### Performance Issues

#### Slow Queries
- Use `LIMIT` to test queries first
- Avoid `SELECT *` on large views
- Use appropriate WHERE clauses

#### Editor Slow
- Close unused query tabs
- Limit result set sizes
- Restart the editor if needed

## 📚 Next Steps

1. **Practice with Sample Queries**
   - Start with the exercises in this course
   - Experiment with different views
   - Try different filtering and sorting

2. **Learn Editor Features**
   - Explore auto-completion
   - Learn keyboard shortcuts
   - Practice saving and organizing queries

3. **Join the Community**
   - Ask questions in class
   - Share tips with classmates
   - Practice with real business scenarios

## 🆘 Getting Help

### In Class
- Ask questions during lessons
- Work with classmates on exercises
- Use office hours for individual help

### Online Resources
- **DBeaver Documentation**: https://dbeaver.io/docs/
- **MySQL Documentation**: https://dev.mysql.com/doc/
- **Stack Overflow**: For specific technical questions

### Contact Information
- **Instructor**: [Your Name]
- **Email**: [your.email@example.com]
- **Office Hours**: [Schedule]

---

**🎉 You're ready to start writing SQL with BriteCore!**

*Remember: The best way to learn is by doing. Start with simple queries and gradually build up to more complex ones.* 