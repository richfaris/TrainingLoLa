# BriteCore SQL Editor Training Class 🚀

> **How to See All BriteCore Views and Fields**
>
> To explore all available BriteCore views, their fields, types, and descriptions, run this in your SQL editor:
> ```sql
> SELECT * FROM v_logical_catalog;
> ```
> This will show you every view, its fields, data types, and (where available) descriptions. You can also browse a formatted reference in [`views/logical_catalog_reference.md`](views/logical_catalog_reference.md).

Welcome to the **BriteCore SQL Editor Training Class**! This specialized course teaches you how to access and analyze BriteCore Application data using predefined views in modern SQL editors.

## 🎯 What You'll Learn

- **BriteCore Views**: Understanding the logical layer views that simplify data access
- **SQL Fundamentals**: SELECT, WHERE, JOIN, GROUP BY using BriteCore data
- **Business Intelligence**: Claims analysis, policy reporting, contact management
- **Real-world Queries**: Practical examples using actual BriteCore business data
- **Best Practices**: Query optimization and naming conventions for BriteCore

## 📋 Prerequisites

- Basic computer literacy
- No prior SQL experience required
- Access to BriteCore database (AWS RDS/MySQL)
- A modern SQL editor (we'll help you choose one)

## 🛠️ Setup Instructions

### Option 1: Quick Start (Recommended)
```bash
git clone https://github.com/yourusername/Prod-LoLa.git
cd Prod-LoLa
```

### Option 2: Download ZIP
- Click the green "Code" button above
- Select "Download ZIP"
- Extract to your preferred location

## 📁 Course Structure

```
Prod-LoLa/
├── 📚 lessons/           # Course lessons and materials
├── 💾 databases/         # Sample data and schemas
├── 🧪 exercises/         # Practice exercises
├── ✅ solutions/         # Exercise solutions
├── 🛠️ tools/            # SQL editor setup guides
├── 📖 resources/         # Additional learning materials
├── 🎯 projects/          # Real-world projects
└── 📊 views/             # BriteCore view documentation
```

## 🎓 Course Modules

### Module 1: Materialized Views - m_inforce_policies (Module 1)
- **Lesson 1.1**: Introduction to Materialized Views - m_inforce_policies
- **Exercise 1**: Basic m_inforce_policies Queries

### Module 2: Introduction to BriteCore Views (Module 2)
- **Lesson 2.1**: Understanding the Logical Layer
- **Lesson 2.2**: Setting Up Your SQL Editor for BriteCore
- **Exercise 2**: Basic Contact Data Retrieval

### Module 3: Claims Analysis (Module 3)
- **Lesson 3.1**: Understanding v_claims Structure
- **Lesson 3.2**: Claims Filtering and Status Analysis
- **Exercise 3**: Claims Reporting Queries

### Module 4: Policy and Property Data (Module 4)
- **Lesson 4.1**: Policy Types and Forms (v_policy_types)
- **Lesson 4.2**: Property Information (v_properties)
- **Exercise 4**: Policy Analysis Projects

### Module 5: Financial Data Analysis (Module 5)
- **Lesson 5.1**: Payment Processing (v_payments)
- **Lesson 5.2**: Commission Tracking (v_commission_details)
- **Exercise 5**: Financial Reporting

### Module 6: Advanced Analytics (Module 6)
- **Lesson 6.1**: Multi-view JOINs
- **Lesson 6.2**: Window Functions for Trends
- **Exercise 6**: Advanced Business Intelligence

## 🛠️ Recommended SQL Editors

### Free Options
- **DBeaver** - Universal database tool (Recommended)
- **HeidiSQL** - Lightweight and fast
- **Beekeeper Studio** - Modern and intuitive
- **MySQL Workbench** - Official MySQL tool

### Paid Options
- **DataGrip** - JetBrains professional tool
- **Navicat** - Feature-rich database management
- **TablePlus** - Clean and modern interface

## 📊 BriteCore Views Overview

This course focuses on these key BriteCore views:

### Core Business Views
- **v_contacts** - All contact information (agents, insureds, vendors)
- **v_claims** - Claims data with policy relationships
- **v_properties** - Property information and addresses
- **v_policy_types** - Policy type definitions and forms
- **v_payments** - Payment processing and batches
- **v_commission_details** - Commission tracking and calculations
- **v_revisions** - Policy revision information
- **v_revision_items** - Individual items within policy revisions

### Financial Views
- **m_accounting_terms** - Accounting term details and balances
- **m_premium_terms** - Premium and fee information over date ranges
- **m_premium_transactions** - Premium transaction history
- **m_inforce_policies** - Policies in force as of specific dates

### Supporting Views
- **v_addresses** - Address management
- **v_notes** - System notes and comments
- **v_files** - Document management
- **v_system_tags** - Tagging and categorization
- **v_insureds** - Insured party information
- **v_roles** - Role definitions and assignments

## 🎯 Learning Objectives

By the end of this course, you will be able to:
- ✅ Write complex SQL queries using BriteCore views
- ✅ Understand BriteCore's logical layer architecture
- ✅ Generate business intelligence reports
- ✅ Analyze claims, policies, and financial data
- ✅ Use modern SQL editors effectively with BriteCore

## 🔍 View Documentation

The course includes comprehensive documentation for all BriteCore views, including:
- Field descriptions and data types
- Business logic explanations
- Common use cases and examples
- Performance considerations

## 🤝 Contributing

Found an error or have a suggestion? 
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📞 Support

- **Instructor**: [Your Name]
- **Email**: [your.email@example.com]
- **Office Hours**: [Schedule]
- **Slack**: [Workspace link]

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- BriteCore development team for the logical layer architecture
- SQL community for best practices and examples
- Students for feedback and suggestions

---

**Ready to master BriteCore SQL? Let's dive in! 🚀**

*"The best way to learn SQL is to write SQL with real business data"* - Every BriteCore instructor ever 