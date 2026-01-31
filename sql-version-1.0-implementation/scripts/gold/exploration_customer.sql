-- Join the customer info with demographic and location data
SELECT 
    ci.cst_id, 
    ci.cst_key, 
    ci.cst_firstname, 
    ci.cst_lastname,
    ci.cst_marital_status, 
    ci.cst_gndr, 
    ci.cst_create_date,
    ca.BDATE,
    ca.GEN,
    la.CNTRY
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
    ON ci.cst_key = ca.CID
LEFT JOIN silver.erp_loc_a101 la
    ON ci.cst_key = la.CID;


-- Check for duplicates
SELECT 
    cst_id, 
    COUNT(*) 
FROM (
    SELECT 
        ci.cst_id, 
        ci.cst_key, 
        ci.cst_firstname, 
        ci.cst_lastname,
        ci.cst_marital_status, 
        ci.cst_gndr, 
        ci.cst_create_date,
        ca.BDATE,
        ca.GEN,
        la.CNTRY
    FROM silver.crm_cust_info ci
    LEFT JOIN silver.erp_cust_az12 ca
        ON ci.cst_key = ca.CID
    LEFT JOIN silver.erp_loc_a101 la
        ON ci.cst_key = la.CID
) 
GROUP BY cst_id 
HAVING COUNT(*) > 1;


-- Compare gender fields from CRM and ERP
SELECT DISTINCT
    ci.cst_gndr, 
    ca.GEN
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
    ON ci.cst_key = ca.CID
LEFT JOIN silver.erp_loc_a101 la
    ON ci.cst_key = la.CID
GROUP BY 1, 2;


-- Gender resolution: prefer CRM, fallback to ERP
SELECT DISTINCT
    ci.cst_gndr, 
    ca.GEN,
    CASE 
        WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
        WHEN ci.cst_gndr = 'n/a' THEN COALESCE(ca.GEN, 'n/a')   
        ELSE ci.cst_gndr 
    END AS Gender
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
    ON ci.cst_key = ca.CID
LEFT JOIN silver.erp_loc_a101 la
    ON ci.cst_key = la.CID;


-- Final query after applying business logic
SELECT 
    ci.cst_id AS customer_id, 
    ci.cst_key AS customer_number, 
    ci.cst_firstname AS first_name, 
    ci.cst_lastname AS last_name,
    ci.cst_marital_status AS marital_status, 
    CASE 
        WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
        WHEN ci.cst_gndr = 'n/a' THEN COALESCE(ca.GEN, 'n/a')   
        ELSE ci.cst_gndr 
    END AS gender,
    ci.cst_create_date AS create_date,
    ca.BDATE AS birth_date,
    la.CNTRY AS country
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
    ON ci.cst_key = ca.CID
LEFT JOIN silver.erp_loc_a101 la
    ON ci.cst_key = la.CID;


-- Reorganized columns for readability
SELECT 
    ci.cst_id AS customer_id, 
    ci.cst_key AS customer_number, 
    ci.cst_firstname AS first_name, 
    ci.cst_lastname AS last_name,
    CASE 
        WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
        WHEN ci.cst_gndr = 'n/a' THEN COALESCE(ca.GEN, 'n/a')   
        ELSE ci.cst_gndr 
    END AS gender,
    ca.BDATE AS birth_date,
    la.CNTRY AS country,
    ci.cst_marital_status AS marital_status, 
    ci.cst_create_date AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
    ON ci.cst_key = ca.CID
LEFT JOIN silver.erp_loc_a101 la
    ON ci.cst_key = la.CID;


-- Create a surrogate key for unique identification
SELECT 
    ROW_NUMBER() OVER (ORDER BY ci.cst_id) AS customer_key,
    ci.cst_id AS customer_id, 
    ci.cst_key AS customer_number, 
    ci.cst_firstname AS first_name, 
    ci.cst_lastname AS last_name,
    CASE 
        WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
        WHEN ci.cst_gndr = 'n/a' THEN COALESCE(ca.GEN, 'n/a')   
        ELSE ci.cst_gndr 
    END AS gender,
    ca.BDATE AS birth_date,
    la.CNTRY AS country,
    ci.cst_marital_status AS marital_status, 
    ci.cst_create_date AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
    ON ci.cst_key = ca.CID
LEFT JOIN silver.erp_loc_a101 la
    ON ci.cst_key = la.CID;
