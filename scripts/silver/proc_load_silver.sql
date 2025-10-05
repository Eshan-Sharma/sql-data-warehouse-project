-- Customer Information
INSERT OVERWRITE datawarehouse.silver.crm_cust_info
SELECT 
    cst_id, 
    cst_key, 
    cst_firstname, 
    cst_lastname, 
    cst_marital_status, 
    cst_gndr, 
    cst_create_date,
    current_timestamp() AS dwh_create_date
FROM
(
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
    )t
    WHERE flag_last = 1
);

-- Product Information
INSERT OVERWRITE datawarehouse.silver.crm_prd_info
SELECT 
    prd_id, 
    cat_id,
    prd_key, 
    prd_nm, 
    prd_cost, 
    prd_line, 
    prd_start_dt, 
    prd_end_dt,
    current_timestamp() AS dwh_create_date
FROM 
(
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
    FROM bronze.crm_prd_info
);

-- Sales Information
INSERT OVERWRITE datawarehouse.silver.crm_sales_details
SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price,
    current_timestamp() AS dwh_create_date   
FROM
(
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
);

-- erp_cust_az12
INSERT OVERWRITE datawarehouse.silver.erp_CUST_AZ12
SELECT
  CID,
  BDATE,
  GEN,
  current_timestamp() AS dwh_create_date  
FROM
(
    SELECT 
        CASE WHEN CID like 'NAS%' THEN SUBSTRING(CID, 4, LENGTH(CID)) 
            ELSE CID 
        END AS CID,
        CASE 
            WHEN BDATE < DATEADD(YEAR, -100, GETDATE()) OR BDATE > GETDATE() THEN NULL
            ELSE BDATE
        END AS BDATE,
        CASE 
            WHEN UPPER(GEN) ='MALE' THEN 'Male'
            WHEN UPPER(GEN) ='FEMALE' THEN 'Female'
            WHEN UPPER(GEN) = 'M' THEN 'Male'
            WHEN UPPER(GEN) = 'F' THEN 'Female'
            ELSE 'n/a' 
        END AS GEN
    FROM bronze.erp_cust_az12
);

-- erp_loc_a101
INSERT OVERWRITE datawarehouse.silver.erp_LOC_A101
SELECT
    CID,
    CNTRY,
    current_timestamp() AS dwh_create_date
FROM
(
    SELECT 
        REPLACE(CID, '-', '') AS CID,
        CASE 
            WHEN UPPER(TRIM(CNTRY)) IN ('US','USA','UNITED STATES') THEN 'United States'
            WHEN UPPER(TRIM(CNTRY)) IN ('GERMANY','DE')             THEN 'Germany'
            WHEN UPPER(TRIM(CNTRY)) IN ('UNITED KINGDOM','AUSTRALIA','CANADA','FRANCE') 
                THEN CNTRY
            ELSE 'n/a' 
        END AS CNTRY
    FROM bronze.erp_loc_a101
);

-- erp_px_cat_g1v2
INSERT OVERWRITE datawarehouse.silver.erp_PX_CAT_G1V2
SELECT
    ID,
    CAT,
    SUBCAT,
    MAINTENANCE,
    current_timestamp() AS dwh_create_date
FROM bronze.erp_px_cat_g1v2;