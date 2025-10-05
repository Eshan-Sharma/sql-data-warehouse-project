-- =====================================================================
-- Exploration Script: bronze.erp_loc_a101
-- File: exploration_erp_loc_a101.sql
-- Purpose: Step-by-step data quality checks and transformations 
--          leading to the final cleaned dataset for Silver layer
-- =====================================================================

USE CATALOG datawarehouse;

-- ==================================================
-- Step 1: CID references to cst_key in crm_cust_info
-- Note: CID contains some invalid values like '-'
-- ==================================================
SELECT cst_key 
FROM bronze.crm_cust_info;

SELECT CID 
FROM bronze.erp_loc_a101;

-- ==================================================
-- Step 2: Remove the '-' and null values
-- ==================================================
SELECT REPLACE(CID, '-', '') 
FROM bronze.erp_loc_a101;
-- Check for distinct values in CNTRY
SELECT DISTINCT(CNTRY) from bronze.erp_loc_a101;

-- ==================================================
-- Step 4: Normalize country names
-- ==================================================
SELECT 
    DISTINCT(CNTRY),
    CASE 
        WHEN UPPER(TRIM(CNTRY)) IN ('US','USA','UNITED STATES') THEN 'United States'
        WHEN UPPER(TRIM(CNTRY)) IN ('GERMANY','DE')             THEN 'Germany'
        WHEN UPPER(TRIM(CNTRY)) IN ('UNITED KINGDOM','AUSTRALIA','CANADA','FRANCE') 
             THEN CNTRY
        ELSE 'n/a' 
    END AS CNTRY
FROM bronze.erp_loc_a101;

-- ==================================================
-- Final Silver table
-- ==================================================
SELECT 
    REPLACE(CID, '-', '') AS CID,
    CASE 
        WHEN UPPER(TRIM(CNTRY)) IN ('US','USA','UNITED STATES') THEN 'United States'
        WHEN UPPER(TRIM(CNTRY)) IN ('GERMANY','DE')             THEN 'Germany'
        WHEN UPPER(TRIM(CNTRY)) IN ('UNITED KINGDOM','AUSTRALIA','CANADA','FRANCE') 
             THEN CNTRY
        ELSE 'n/a' 
    END AS CNTRY
FROM bronze.erp_loc_a101;
