# Modern Data Warehouse on Databricks (Medallion Architecture)

## Overview

This project started as a SQL-first data warehouse built on Databricks using a Medallion Architecture (Bronze, Silver, Gold).

The initial implementation focused heavily on SQL scripts, stored procedures, and structured transformations to build a clean analytical model from multiple source systems (ERP and CRM). While the solution was functional, detailed, and production-like from a traditional warehouse perspective, it didn’t fully reflect how modern data engineering teams typically build pipelines today.

Since there’s always room to improve and move closer to current industry practices, the project has been upgraded to a more modern, lakehouse-oriented approach.

## Project Evolution

### Version 1.0 (SQL-first approach)

Folder: `sql-version-1.0-implementation/`

- SQL-based ETL scripts
- Bronze → Silver → Gold transformations using stored procedures
- Star schema modelling
- Batch ingestion from CSV
- Analytical queries written in SQL

This version demonstrates:

- Core data warehousing fundamentals
- Dimensional modelling
- Data cleansing and integration
- Structured ETL design

Good foundation, but closer to traditional warehouse engineering than modern lakehouse workflows.

### Version 2.0 (Modern Lakehouse approach)

The current version reimplements the same architecture using Databricks-native and PySpark-based workflows.

Key changes:

- PySpark transformations instead of SQL stored procedures
- Databricks Notebooks for modular development
- Delta Lake tables for all layers
- Automated pipelines using Databricks Workflows/Jobs
- Incremental ingestion patterns
- Data quality checks and validations
- Visual analytics using:
  - Databricks visualizations
  - Power BI dashboards

This version is designed to better reflect how modern companies actually build data platforms:
code-driven, automated, scalable, and analytics-ready.

## Architecture

The project follows the Medallion Architecture:

### Bronze

Raw ingestion layer
Stores source data as-is from ERP and CRM systems.

### Silver

Cleansed and standardized layer
Handles:

- data cleaning
- deduplication
- normalization
- business rules

### Gold

Business-ready layer

- Star schema
- Fact and dimension tables
- Optimized for BI and analytics

## Tech Stack

- Databricks (Lakehouse platform)
- PySpark
- Delta Lake
- Databricks Workflows / Jobs
- SQL (analytics layer)
- Power BI
- GitHub for version control
- Notion for project tracking

# Repository Structure

```
sql-version-1.0-implementation/   # Original SQL-based warehouse (V1.0)

notebooks/                       # Databricks notebooks (Bronze/Silver/Gold)
  bronze/                        # Raw ingestion (e.g. 01_bronze_ingestion)
  silver/                        # Cleansed CRM & ERP tables
  gold/                          # Dimension & fact tables
orchestration/                   # Orchestration notebooks (e.g. run_silver, run_gold)
pipelines/                       # Workflow/job definitions
  databricks_medallion_pipeline_job.yaml
datasets/                        # Sample source data
docs/                            # V2.0 docs: data catalog, naming conventions
                                # (separate from sql-version-1.0-implementation/docs/)
```

You can add a `dashboards/` folder if you want to store BI and visualization assets (e.g. Power BI reports, Databricks dashboards).

# Goals of This Project

This project is meant to demonstrate:

- End-to-end data warehousing
- Medallion architecture design
- Modern lakehouse engineering practices
- Data modelling for analytics
- BI-ready datasets and dashboards
- How a traditional SQL warehouse can evolve into a modern pipeline-based system

# Why the Upgrade?

Most real-world teams today:

- use PySpark or Python instead of large SQL procedures
- orchestrate jobs with workflows
- automate pipelines
- add data quality checks
- build dashboards directly on Delta tables

Version 2.0 aligns the project with those practices to better simulate a production-grade data platform.
