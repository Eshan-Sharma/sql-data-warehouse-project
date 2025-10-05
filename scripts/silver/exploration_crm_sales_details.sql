-- =====================================================================
-- Exploration Script: bronze.crm_sales_details
-- File: exploration_crm_sales_details.sql
-- Purpose: Step-by-step data quality checks and transformations 
--          leading to the final cleaned dataset for Silver layer
-- =====================================================================

USE CATALOG datawarehouse;

--------------------------------------------------------------------------------
-- Step 1: Unwanted leading/trailing spaces
-- Expectation: no rows should be returned
--------------------------------------------------------------------------------
SELECT sls_ord_num
FROM bronze.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num)

SELECT sls_prd_key
FROM bronze.crm_sales_details
WHERE sls_prd_key != TRIM(sls_prd_key)

SELECT sls_cust_id
FROM bronze.crm_sales_details
WHERE sls_cust_id != TRIM(sls_cust_id)

--------------------------------------------------------------------------------
-- Step 2: Referential integrity checks (product key and customer id exist)
-- Expectation: no rows should be returned
--------------------------------------------------------------------------------
-- products missing in product master
SELECT DISTINCT sls_prd_key
FROM bronze.crm_sales_details 
WHERE sls_prd_key NOT IN 
(
  SELECT prd_key
  FROM silver.crm_prd_info
)

-- customers missing in customer master
SELECT DISTINCT sls_cust_id
FROM bronze.crm_sales_details 
WHERE sls_cust_id NOT IN 
(
  SELECT cst_id
  FROM silver.crm_cust_info
)

--------------------------------------------------------------------------------
-- Step 3: Order / ship / due date validation
-- Expectation: no rows should be returned
-- Notes: handle ints/strings by casting to string before length checks
--------------------------------------------------------------------------------
-- order date checks
-- order date checks
SELECT sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt IS NULL
   OR sls_order_dt <= 0
   OR LENGTH(CAST(sls_order_dt AS STRING)) != 8

-- ship date checks
SELECT sls_ship_dt
FROM bronze.crm_sales_details
WHERE sls_ship_dt IS NULL
   OR sls_ship_dt <= 0
   OR LENGTH(CAST(sls_ship_dt AS STRING)) != 8

-- due date checks
SELECT sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt IS NULL
   OR sls_due_dt <= 0
   OR LENGTH(CAST(sls_due_dt AS STRING)) != 8

--------------------------------------------------------------------------------
-- Step 4: Date parsing preview (we'll convert to proper dates)
--------------------------------------------------------------------------------
SELECT
  CASE 
    WHEN sls_order_dt <= 0 OR LENGTH(CAST(sls_order_dt AS STRING)) != 8 THEN NULL
    ELSE TO_DATE(CAST(sls_order_dt AS STRING), 'yyyyMMdd')
  END AS sls_order_dt,
  CASE 
    WHEN sls_ship_dt <= 0 OR LENGTH(CAST(sls_ship_dt AS STRING)) != 8 THEN NULL
    ELSE TO_DATE(CAST(sls_ship_dt AS STRING), 'yyyyMMdd')
  END AS sls_ship_dt,
  CASE 
    WHEN sls_due_dt <= 0 OR LENGTH(CAST(sls_due_dt AS STRING)) != 8 THEN NULL
    ELSE TO_DATE(CAST(sls_due_dt AS STRING), 'yyyyMMdd')
  END AS sls_due_dt
FROM bronze.crm_sales_details

  --------------------------------------------------------------------------------
-- Step 5: Chronology checks (order date should not be after ship/due)
-- Expectation: no rows should be returned
--------------------------------------------------------------------------------
SELECT *
FROM (
  SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    CASE WHEN sls_order_dt <= 0 OR LENGTH(CAST(sls_order_dt AS STRING)) != 8
         THEN NULL ELSE TO_DATE(CAST(sls_order_dt AS STRING),'yyyyMMdd') END AS sls_order_dt,
    CASE WHEN sls_ship_dt <= 0 OR LENGTH(CAST(sls_ship_dt AS STRING)) != 8
         THEN NULL ELSE TO_DATE(CAST(sls_ship_dt AS STRING),'yyyyMMdd') END AS sls_ship_dt,
    CASE WHEN sls_due_dt <= 0 OR LENGTH(CAST(sls_due_dt AS STRING)) != 8
         THEN NULL ELSE TO_DATE(CAST(sls_due_dt AS STRING),'yyyyMMdd') END AS sls_due_dt,
    sls_sales, sls_quantity, sls_price
  FROM bronze.crm_sales_details
) t
WHERE (sls_order_dt IS NOT NULL AND sls_ship_dt IS NOT NULL AND sls_order_dt > sls_ship_dt)
   OR (sls_order_dt IS NOT NULL AND sls_due_dt IS NOT NULL  AND sls_order_dt > sls_due_dt)
 --------------------------------------------------------------------------------
-- Step 6: Quantity, Price, Sales basic checks
-- Expectation: no rows should be returned
--------------------------------------------------------------------------------
-- quantity < 1 or null
SELECT sls_ord_num, sls_prd_key, sls_cust_id, sls_quantity, sls_price, sls_sales
FROM bronze.crm_sales_details
WHERE sls_quantity IS NULL OR sls_quantity < 1

-- price < 1 or null
SELECT sls_ord_num, sls_prd_key, sls_cust_id, sls_quantity, sls_price, sls_sales
FROM bronze.crm_sales_details
WHERE sls_price IS NULL OR sls_price < 1

-- sales < 1 or null
SELECT sls_ord_num, sls_prd_key, sls_cust_id, sls_quantity, sls_price, sls_sales
FROM bronze.crm_sales_details
WHERE sls_sales IS NULL OR sls_sales < 1


--------------------------------------------------------------------------------
-- Step 7: Business rule check - sales = quantity * price
-- Expectation: no rows should be returned (or raise to business)
--------------------------------------------------------------------------------
SELECT sls_ord_num, sls_prd_key, sls_cust_id, sls_quantity, sls_price, sls_sales,
       sls_quantity * sls_price AS expected_sales
FROM bronze.crm_sales_details
WHERE sls_sales IS NULL
   OR sls_quantity IS NULL
   OR sls_price IS NULL
   OR sls_sales != sls_quantity * sls_price

  -- rules to be applied after talking to business
--   1. if sales is negative, zero or null then derive it using quantity and price
--   2. if price is zeor or null then calculate it using sales and quantity
--   3. if price is negative convert it to a positive value

-- If rows are returned above: talk to business to decide rules.
-- Proposed rules (implemented below):
-- 1) if sales is null or <=0 OR inconsistent => derive using quantity * ABS(price)
-- 2) if price is null or =0 => derive using sales / quantity (when possible)
-- 3) if price is negative => convert to positive (ABS)

--------------------------------------------------------------------------------
-- Step 8: Preview of derived columns (sls_price1, sls_sales1) with applied rules
--------------------------------------------------------------------------------

SELECT
  sls_ord_num,
  sls_prd_key,
  sls_cust_id,
    -- proposed normalized sales (quantity * ABS(price))
  CASE 
    WHEN sls_sales IS NULL or sls_sales<=0 OR sls_sales != sls_quantity * ABS(sls_price) 
        THEN sls_quantity * ABS(sls_price) 
    ELSE sls_sales 
  END as sls_sales,
  sls_quantity,
    -- proposed normalized price
  CASE 
    WHEN sls_price IS NULL OR sls_price<=0 
        THEN sls_sales/NULLIF(sls_quantity,0)
    WHEN sls_price <0 
        THEN ABS(sls_price )
    ELSE sls_price
   END AS sls_price
FROM bronze.crm_sales_details 

--------------------------------------------------------------------------------
-- Final cleanup:
-- - Trim string keys
-- - Parse dates safely to DATE (NULL when invalid)
-- - Normalize price (derive / abs)
-- - Normalize sales (derive using normalized price)
--------------------------------------------------------------------------------
SELECT
  sls_ord_num,
  sls_prd_key,
  sls_cust_id,
    CASE WHEN sls_order_dt <= 0 OR LENGTH(CAST(sls_order_dt AS STRING)) != 8
         THEN NULL ELSE TO_DATE(CAST(sls_order_dt AS STRING),'yyyyMMdd') END AS sls_order_dt,
    CASE WHEN sls_ship_dt <= 0 OR LENGTH(CAST(sls_ship_dt AS STRING)) != 8
         THEN NULL ELSE TO_DATE(CAST(sls_ship_dt AS STRING),'yyyyMMdd') END AS sls_ship_dt,
    CASE WHEN sls_due_dt <= 0 OR LENGTH(CAST(sls_due_dt AS STRING)) != 8
         THEN NULL ELSE TO_DATE(CAST(sls_due_dt AS STRING),'yyyyMMdd') END AS sls_due_dt,
  CASE 
    WHEN sls_sales IS NULL or sls_sales<=0 OR sls_sales != sls_quantity * ABS(sls_price) 
        THEN sls_quantity * ABS(sls_price) 
    ELSE sls_sales 
  END as sls_sales,
  sls_quantity,
    CASE WHEN sls_price IS NULL OR sls_price <= 0 
         THEN sls_sales / NULLIF(sls_quantity,0)
         WHEN sls_price < 0 
         THEN ABS(sls_price) ELSE sls_price END AS sls_price
FROM bronze.crm_sales_details 