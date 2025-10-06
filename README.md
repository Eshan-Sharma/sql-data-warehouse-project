# Data Warehouse and Analytics Project

This project showcases a comprehensive **data warehousing and analytics solution**, spanning from raw data ingestion to analytical insights.Designed as a portfolio project to demonstrate end-to-end data engineering skills with a strong focus on **exploration**, **modeling**, and **integration**.

👉 I also mimicked a real-world Agile/Jira-style project management workflow in [Notion](https://wandering-engineer-849.notion.site/Data-Warehouse-Project-1cfb006f747f80db8f4edc4331512eca)

## 🏗️ Procedure Followed

1. Requirement Analysis & Planning
   - Defined business goals (analyzing customers, products, and sales trends).
   - Outlined deliverables and structured the project using Agile methodology.

2. Data Exploration

   - Performed deep profiling on CRM and ERP datasets.   
   - Identified data quality issues (missing values, inconsistent categories, surrogate key needs).
   - Documented findings in `docs/data_catalog.md`.

3. Data Modeling

   - Designed a **Medallion Architecture (Bronze → Silver → Gold)**.
   - Created a Star Schema with `dim_customers`, `dim_products`, and `fact_sales`.
   - Captured architecture, flow, and models in diagrams (`docs/`).

4. ETL Implementation

   - Bronze: Raw ingestion from CSV files.
   - Silver: Standardization, cleansing, and integration of ERP & CRM sources.
   - Gold: Business-ready star schema for analytics, with integrity checks.

5. Analytics & Reporting

   - SQL-based insights into **Customer behavior**, **Product performance**, and **Sales trends**.
   - Ensured **referential integrity** with foreign key checks.

6. Documentation

   - Maintained **data catalog**, **naming conventions**, and **data models** for clarity.
   - Structured repository for easy navigation and reuse.

## 📖 Data Architecture

The data architecture for this project follows a Medallion Architecture **Bronze**, **Silver**, and **Gold** layers:

1. Bronze Layer: Stores raw data as-is from the source systems. Data is ingested from CSV Files into the Databricks Database.
2. Silver Layer: This layer includes data cleansing, standardisation, and normalisation processes to prepare data for analysis.
3. Gold Layer: Houses business-ready data modelled into a star schema required for reporting and analytics.
   
   <img width="806" height="511" alt="Data_Architecture" src="https://github.com/user-attachments/assets/11d0933d-8d32-4b4c-ae48-5d69dc6536e5" />

## 🚀 Project Requirements

### Building the Data Warehouse (Data Engineering)

#### Objective

Develop a modern data warehouse using Databricks to consolidate sales data, enabling analytical reporting and informed decision-making.

#### Specifications

- **Data Sources:** Import data from two source systems (ERP and CRM) provided as CSV files into Databricks.
- **Data Quality:** Cleanse and resolve data quality issues prior to analysis using Databricks workflows.
- **Integration:** Combine both sources into a single, user-friendly data model designed for analytical queries.
- **Scope:** Focus on the latest dataset only; historization of data is not required.
- **Documentation:** Provide clear documentation of the data model to support both business stakeholders and analytics teams.

### BI: Analytics & Reporting (Data Analysis)

#### Objective

Develop SQL-based analytics to deliver detailed insights into:

- Customer Behaviour
- Product Performance
- Sales Trends

These insights empower stakeholders with key business metrics, enabling strategic decision-making.

## 📂 Repository Structure

```
data-warehouse-project/
│
├── datasets/                           # Raw datasets (input data sources for the warehouse)
│   ├── source_crm/                     # CRM source system exports
│   │   ├── cust_info.csv               # Customer master data from CRM
│   │   ├── prd_info.csv                # Product master data from CRM
│   │   └── sales_details.csv           # Sales transaction data from CRM
│   │
│   └── source_erp/                     # ERP source system exports
│       ├── CUST_AZ12.csv               # Customer demographic data (ERP)
│       ├── LOC_A101.csv                # Customer location/geographic data (ERP)
│       └── PX_CAT_G1V2.csv             # Product category mapping (ERP)
│
├── docs/                               # Project documentation and diagrams
│   ├── data_architecture.png           # High-level data architecture overview
│   ├── data_catalog.md                 # Data catalog with field definitions and metadata
│   ├── data_flow.png                   # Data flow diagram (ETL pipeline steps)
│   ├── data_integration.png            # Diagram of integration between CRM and ERP sources
│   ├── data_model.png                  # Star schema / dimensional model visualization
│   └── naming_conventions.md           # Standards for naming tables, columns, and files
│
├── scripts/                            # SQL scripts for ETL processes and transformations
│   ├── init_database.sql               # Script to initialize database schema and setup
│   │
│   ├── bronze/                         # Raw staging layer (Bronze)
│   │   ├── ddl_bronze.sql              # DDL scripts for Bronze tables
│   │   └── proc_load_bronze.sql        # Procedures to load raw CRM/ERP data into Bronze
│   │
│   ├── silver/                         # Cleansed & standardized layer (Silver)
│   │   ├── ddl_silver.sql              # DDL scripts for Silver tables
│   │   ├── exploration_crm_cust_info.sql     # Data profiling for CRM customer info
│   │   ├── exploration_crm_prd_info.sql      # Data profiling for CRM product info
│   │   ├── exploration_crm_sales_details.sql # Data profiling for CRM sales transactions
│   │   ├── exploration_erp_cust_az12.sql     # Data profiling for ERP customer demographics
│   │   ├── exploration_erp_loc_a101.sql      # Data profiling for ERP customer locations
│   │   ├── exploration_erp_px_cat_g1v2.sql   # Data profiling for ERP product categories
│   │   └── proc_load_silver.sql        # Procedures to transform Bronze → Silver
│   │
│   └── gold/                           # Business-ready analytics layer (Gold)
|       ├── data_analysis.sql           # Exploratory data analysis(EDA) and Advanced data analysis for business insights
│       ├── exploration_customer.sql    # Dimension build / validation for customers
│       ├── exploration_product.sql     # Dimension build / validation for products
│       ├── exploration_sales.sql       # Fact build / validation for sales
│       ├── integrity_check_goal.sql    # Foreign key & data integrity checks
│       └── proc_load_gold.sql          # Procedures to load Silver → Gold
│
├── README.md                           # Project overview, setup, and usage instructions
```
