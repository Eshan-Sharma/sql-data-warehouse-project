-- =====================================================================
-- Exploration Script: bronze.crm_cust_info
-- Purpose: Step-by-step data quality checks and transformations 
--          leading to the final cleaned dataset for Silver layer
-- =====================================================================

USE CATALOG datawarehouse;

-- ==================================================
-- Step 1: Check for duplicates in primary key (cst_id)
-- ==================================================
SELECT cst_id, COUNT(*) AS record_count
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1;


-- ==================================================
-- Step 2: Primary key correction
-- Keep only the latest record per customer using cst_create_date
-- ==================================================
SELECT COUNT(*)
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
    FROM bronze.crm_cust_info
    WHERE cst_id IS NOT NULL
) t
WHERE flag_last = 1;


-- ==================================================
-- Step 3: Check for leading/trailing spaces
-- Expectation: No rows should be returned
-- ==================================================
SELECT cst_firstname 
FROM bronze.crm_cust_info 
WHERE cst_firstname != TRIM(cst_firstname);

SELECT cst_lastname 
FROM bronze.crm_cust_info 
WHERE cst_lastname != TRIM(cst_lastname);

SELECT cst_gndr 
FROM bronze.crm_cust_info 
WHERE cst_gndr != TRIM(cst_gndr);

SELECT cst_marital_status 
FROM bronze.crm_cust_info 
WHERE cst_marital_status != TRIM(cst_marital_status);


-- ==================================================
-- Step 4: Apply trimming and primary key correction
-- ==================================================
SELECT cst_id,
       cst_key, 
       TRIM(cst_firstname) AS cst_firstname, 
       TRIM(cst_lastname)  AS cst_lastname,
       cst_marital_status,
       cst_gndr,
       cst_create_date
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
    FROM bronze.crm_cust_info
    WHERE cst_id IS NOT NULL
) t
WHERE flag_last = 1;


-- ==================================================
-- Step 5: Standardize Gender values
-- ==================================================
-- Check distinct gender values after trimming
SELECT DISTINCT(cst_gndr)
FROM (
    SELECT cst_id,
           cst_key,
           TRIM(cst_firstname) AS cst_firstname, 
           TRIM(cst_lastname)  AS cst_lastname,
           cst_marital_status,
           cst_gndr,
           cst_create_date
    FROM (
        SELECT *,
               ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
        FROM bronze.crm_cust_info
        WHERE cst_id IS NOT NULL
    ) t
    WHERE flag_last = 1
);

-- Replace inconsistent gender values
SELECT cst_id,
       cst_key,
       TRIM(cst_firstname) AS cst_firstname, 
       TRIM(cst_lastname)  AS cst_lastname,
       cst_marital_status,
       CASE 
            WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
            WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
            ELSE 'n/a' 
       END AS cst_gndr,
       cst_create_date
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
    FROM bronze.crm_cust_info
    WHERE cst_id IS NOT NULL
) t
WHERE flag_last = 1;


-- ==================================================
-- Step 6: Standardize Marital Status values
-- ==================================================
-- Check distinct marital status values
SELECT DISTINCT(cst_marital_status)
FROM (
    SELECT cst_id,
           cst_key,
           TRIM(cst_firstname) AS cst_firstname, 
           TRIM(cst_lastname)  AS cst_lastname,
           cst_marital_status,
           CASE 
                WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
                WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
                ELSE 'n/a' 
           END AS cst_gndr,
           cst_create_date
    FROM (
        SELECT *,
               ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
        FROM bronze.crm_cust_info
        WHERE cst_id IS NOT NULL
    ) t
    WHERE flag_last = 1
);

-- Apply transformations to marital status and gender
SELECT cst_id,
       cst_key,
       TRIM(cst_firstname) AS cst_firstname, 
       TRIM(cst_lastname)  AS cst_lastname,
       CASE 
            WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
            WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married' 
            ELSE 'n/a' 
       END AS cst_marital_status,
       CASE 
            WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
            WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
            ELSE 'n/a' 
       END AS cst_gndr,
       cst_create_date
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
    FROM bronze.crm_cust_info
    WHERE cst_id IS NOT NULL
) t
WHERE flag_last = 1;
