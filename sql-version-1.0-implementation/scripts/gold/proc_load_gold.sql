--- Customer Dimension Table
CREATE VIEW gold.dim_customers AS
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

--- Product Dimension Table
CREATE VIEW gold.dim_products AS
SELECT 
    row_number() over(order by pi.prd_start_dt, pi.prd_key) as product_key,
    pi.prd_id as product_id, 
    pi.prd_key as product_number, 
    pi.prd_nm as product_name, 
    pi.cat_id as category_id, 
    ep.CAT as category,
    ep.SUBCAT as sub_category,
    ep.MAINTENANCE as maintenance,
    pi.prd_cost as product_cost, 
    pi.prd_line as product_line, 
    pi.prd_start_dt as start_date
from silver.crm_prd_info pi
left join silver.erp_px_cat_g1v2 ep
    on pi.cat_id = ep.ID 
where prd_end_dt is null;

--- Sales Fact Table
CREATE VIEW gold.fact_sales AS
SELECT 
sd.sls_ord_num as order_number, 
pr.product_key as product_key,
c.customer_key as customer_key,
sd.sls_order_dt as order_date,
sd.sls_ship_dt as ship_date,
sd.sls_due_dt as due_date, 
sd.sls_sales as sales_amount, 
sd.sls_quantity as quantity,
sd.sls_price as price
from silver.crm_sales_details sd
left join gold.dim_products pr
on sd.sls_prd_key = pr.product_number
left join gold.dim_customers c
on sd.sls_cust_id = c.customer_id