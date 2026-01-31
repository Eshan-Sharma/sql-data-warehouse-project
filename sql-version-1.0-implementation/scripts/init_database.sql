/*
=============================================================
Create Database and Schemas
=============================================================
    SQL script to initialize the database structure in Databricks.
    This script creates a catalog named 'datawarehouse' and three schemas: bronze, silver, and gold.
*/

-- Create a catalog in databricks
CREATE CATALOG IF NOT EXISTS datawarehouse;

-- Switch to the new catalog
USE CATALOG datawarehouse;

-- Create the schemas 
CREATE SCHEMA IF NOT EXISTS bronze;
CREATE SCHEMA IF NOT EXISTS silver;
CREATE SCHEMA IF NOT EXISTS gold;