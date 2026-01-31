-- Customer Information
INSERT OVERWRITE datawarehouse.bronze.crm_cust_info
SELECT 
    cst_id, 
    cst_key, 
    cst_firstname, 
    cst_lastname, 
    cst_marital_status, 
    cst_gndr, 
    cst_create_date
FROM datawarehouse.google_drive.cust_info;


-- Product Information
INSERT OVERWRITE datawarehouse.bronze.crm_prd_info
SELECT 
    prd_id, 
    prd_key, 
    prd_nm, 
    prd_cost, 
    prd_line, 
    prd_start_dt, 
    prd_end_dt
FROM datawarehouse.google_drive.prd_info;


-- Sales Details
INSERT OVERWRITE datawarehouse.bronze.crm_sales_details
SELECT 
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
FROM datawarehouse.google_drive.sales_details;


-- ERP Customer AZ12
INSERT OVERWRITE datawarehouse.bronze.erp_cust_az12
SELECT 
    CID, 
    BDATE, 
    GEN
FROM datawarehouse.google_drive.cust_az_12;


-- ERP Location A101
INSERT OVERWRITE datawarehouse.bronze.erp_loc_a101
SELECT 
    CID, 
    CNTRY
FROM datawarehouse.google_drive.loc_a_101;


-- ERP Product Category G1V2
INSERT OVERWRITE datawarehouse.bronze.erp_px_cat_g1v2
SELECT 
    ID, 
    CAT, 
    SUBCAT, 
    MAINTENANCE
FROM datawarehouse.google_drive.px_cat_g_1_v_2;