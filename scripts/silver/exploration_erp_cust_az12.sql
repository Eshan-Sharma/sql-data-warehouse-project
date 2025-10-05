-- =====================================================================
-- Exploration Script: bronze.erp_cust_az12
-- File: exploration_crm_sales_details.sql
-- Purpose: Step-by-step data quality checks and transformations 
--          leading to the final cleaned dataset for Silver layer
-- =====================================================================

USE CATALOG datawarehouse;

-- ==================================================
-- Step 1: Check for duplicates in primary key (CID)
-- ==================================================
SELECT 
    CID, 
    COUNT(*) AS record_count
FROM bronze.erp_cust_az12
GROUP BY CID
HAVING COUNT(*) > 1;

-- ==================================================
-- Step 2: Check CID to the cst_key in crm_cust_info
-- Note: Found erp_cust_az12.CID has 'NAS' prefix in some records
-- ==================================================
SELECT * 
FROM bronze.crm_cust_info;

-- ==================================================
-- Step 3: Remove the extra 'NAS' from CID
-- ==================================================
SELECT 
    CASE 
        WHEN CID LIKE 'NAS%' THEN SUBSTRING(CID, 4, LENGTH(CID)) 
        ELSE CID 
    END AS CID
FROM bronze.erp_cust_az12;

-- ==================================================
-- Step 4: Check for distinct values in gender
-- ==================================================
SELECT DISTINCT GEN
FROM bronze.erp_cust_az12;

-- ==================================================
-- Step 5: Normalize gender values
-- ==================================================
SELECT 
    CID,
    BDATE,
    CASE 
        WHEN UPPER(GEN) = 'MALE'   THEN 'Male'
        WHEN UPPER(GEN) = 'FEMALE' THEN 'Female'
        WHEN UPPER(GEN) = 'M'      THEN 'Male'
        WHEN UPPER(GEN) = 'F'      THEN 'Female'
        ELSE 'n/a' 
    END AS GEN
FROM bronze.erp_cust_az12;

-- ==================================================
-- Step 6: Check date validity (BDATE)
-- Rule: more than 100 years old OR future dates are invalid
-- ==================================================
SELECT *
FROM bronze.erp_cust_az12
WHERE BDATE < DATEADD(YEAR, -100, GETDATE())
   OR BDATE > GETDATE();

-- ==================================================
-- Step 7: Fix invalid dates
-- ==================================================
SELECT 
    CID,
    CASE 
        WHEN BDATE < DATEADD(YEAR, -100, GETDATE()) 
          OR BDATE > GETDATE() 
        THEN NULL
        ELSE BDATE
    END AS BDATE,
    GEN
FROM bronze.erp_cust_az12;

-- ==================================================
-- Final Select with all transformations
-- ==================================================
SELECT 
    CASE 
        WHEN CID LIKE 'NAS%' THEN SUBSTRING(CID, 4, LENGTH(CID)) 
        ELSE CID 
    END AS CID,
    CASE 
        WHEN BDATE < DATEADD(YEAR, -100, GETDATE()) 
          OR BDATE > GETDATE() 
        THEN NULL
        ELSE BDATE
    END AS BDATE,
    CASE 
        WHEN UPPER(GEN) = 'MALE'   THEN 'Male'
        WHEN UPPER(GEN) = 'FEMALE' THEN 'Female'
        WHEN UPPER(GEN) = 'M'      THEN 'Male'
        WHEN UPPER(GEN) = 'F'      THEN 'Female'
        ELSE 'n/a' 
    END AS GEN
FROM bronze.erp_cust_az12;