# Data Warehouse and Analytics Project

This project showcases a comprehensive data warehousing and analytics solution, spanning the development of a data warehouse to the generation of actionable insights. Designed as a portfolio project, it highlights industry best practices in data engineering and analytics.

## Data Architecture
The data architecture for this project follows a Medallion Architecture **Bronze**, **Silver**, and **Gold** layers:

<img width="806" height="511" alt="Data_Architecture" src="https://github.com/user-attachments/assets/11d0933d-8d32-4b4c-ae48-5d69dc6536e5" />

1. Bronze Layer: Stores raw data as-is from the source systems. Data is ingested from CSV Files into the Databricks Database.
2. Silver Layer: This layer includes data cleansing, standardisation, and normalisation processes to prepare data for analysis.
3. Gold Layer: Houses business-ready data modelled into a star schema required for reporting and analytics.

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
