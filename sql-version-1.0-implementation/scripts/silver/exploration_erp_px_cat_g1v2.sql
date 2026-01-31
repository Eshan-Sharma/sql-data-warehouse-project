-- =====================================================================
-- Exploration Script: bronze.erp_px_cat_g1v2
-- File: exploration_erp_erp_px_cat_g1v2.sql
-- Purpose: Step-by-step data quality checks and transformations 
--          leading to the final cleaned dataset for Silver layer
-- =====================================================================

USE CATALOG datawarehouse;

-- ==================================================
-- Step 1: Check for primary key duplicates
-- ==================================================
SELECT 
    ID, 
    COUNT(*) 
FROM bronze.erp_px_cat_g1v2 
GROUP BY ID 
HAVING COUNT(*) > 1;

-- ==================================================
-- Step 2: Check if reference is correct 
-- ==================================================
SELECT ID 
FROM bronze.erp_px_cat_g1v2  
WHERE ID NOT IN (
    SELECT cat_id 
    FROM silver.crm_prd_info
);

-- ==================================================
-- Step 3: Check distinct values in category fields
-- ==================================================
SELECT DISTINCT CAT 
FROM bronze.erp_px_cat_g1v2;

SELECT DISTINCT SUBCAT 
FROM bronze.erp_px_cat_g1v2;

SELECT DISTINCT MAINTENANCE 
FROM bronze.erp_px_cat_g1v2;

-- ==================================================
-- Step 4: Check for unwanted spaces
-- Expectation: no results
-- ==================================================
SELECT CAT 
FROM bronze.erp_px_cat_g1v2  
WHERE CAT != TRIM(CAT);

SELECT SUBCAT 
FROM bronze.erp_px_cat_g1v2  
WHERE SUBCAT != TRIM(SUBCAT);

SELECT MAINTENANCE 
FROM bronze.erp_px_cat_g1v2  
WHERE MAINTENANCE != TRIM(MAINTENANCE);