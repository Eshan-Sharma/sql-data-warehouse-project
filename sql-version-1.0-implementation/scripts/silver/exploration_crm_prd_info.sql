-- =====================================================================
-- Exploration Script: bronze.crm_prd_info
-- Purpose: Step-by-step data quality checks and transformations 
--          leading to the final cleaned dataset for Silver layer
-- =====================================================================

USE CATALOG datawarehouse;

-- ==================================================
-- Step 1: Check for duplicates or nulls in primary key
-- Expected result: no output
-- ==================================================
SELECT prd_id, COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;


-- ==================================================
-- Step 2: Extract the category id and product id for joining 
-- ==================================================
SELECT 
    prd_id,
    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
    SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
FROM bronze.crm_prd_info;


-- ==================================================
-- Step 3: Check for unwanted spaces
-- Expected result: no output
-- ==================================================
SELECT prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);


-- ==================================================
-- Step 4: Check for nulls or negative numbers in product cost
-- ==================================================
SELECT prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- ==================================================
-- Step 5: Extract cat_id, prd_key and clean product cost
-- ==================================================
SELECT 
    prd_id,
    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
    SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key,
    prd_nm,
    COALESCE(prd_cost, 0) AS prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
FROM bronze.crm_prd_info;
-- ==================================================
-- Step 6: Data standardization & consistency
-- Check distinct product lines
-- ==================================================
SELECT DISTINCT(prd_line)
FROM bronze.crm_prd_info;


-- ==================================================
-- Step 7: Apply mapping to product line values
-- ==================================================
SELECT 
    prd_id,
    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
    SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key,
    prd_nm,
    COALESCE(prd_cost, 0) AS prd_cost,
    CASE 
        WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
        WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
        WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
        WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
        ELSE 'n/a'
    END AS prd_line,
    prd_start_dt,
    prd_end_dt
FROM bronze.crm_prd_info;


-- ==================================================
-- Step 8: Check for invalid data orders (end date < start date)
-- ==================================================
SELECT *
FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt;


-- ==================================================
-- Step 9: Correct the dates 
-- Compute end date as (next start_dt - 1)
-- ==================================================
SELECT 
    prd_id, 
    prd_key, 
    prd_nm, 
    prd_start_dt,
    LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - 1 AS prd_end_dt
FROM bronze.crm_prd_info;


-- ==================================================
-- Step 10: Final Select with all corrections
-- ==================================================
SELECT 
    prd_id,
    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
    SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key,
    prd_nm,
    COALESCE(prd_cost, 0) AS prd_cost,
    CASE 
        WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
        WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
        WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
        WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
        ELSE 'n/a'
    END AS prd_line,
    prd_start_dt,
    LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - 1 AS prd_end_dt
FROM bronze.crm_prd_info;


