--- Sales Exploration Table
select 
    sd.sls_ord_num, 
    sd.sls_prd_key, 
    sd.sls_cust_id,
    sd.sls_order_dt,
    sd.sls_ship_dt,
    sd.sls_due_dt, 
    sd.sls_sales, 
    sd.sls_quantity,
    sd.sls_price 
from silver.crm_sales_details sd;

-- Building a fact table: Use the dimension's surrogate keys instead of IDs 
-- to easily connect facts with dimensions
select 
    sd.sls_ord_num, 
    pr.product_key,    -- Dimension table surrogate key
    c.customer_key,    -- Dimension table surrogate key
    sd.sls_order_dt,
    sd.sls_ship_dt,
    sd.sls_due_dt, 
    sd.sls_sales, 
    sd.sls_quantity,
    sd.sls_price 
from silver.crm_sales_details sd
left join gold.dim_products pr
    on sd.sls_prd_key = pr.product_number
left join gold.dim_customers c
    on sd.sls_cust_id = c.customer_id;

-- Rename columns to friendly, meaningful names
-- Columns are grouped into logical groups of dimension keys, dates and measures to improve readability
select 
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
    on sd.sls_cust_id = c.customer_id;