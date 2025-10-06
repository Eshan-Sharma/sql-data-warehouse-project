-- Foreign Key Integrity (Dimensions to Fact)
select 
    * 
from gold.fact_sales fs
left join gold.dim_customers dc
    on fs.customer_key = dc.customer_key
left join gold.dim_products dp
    on fs.product_key = dp.product_key 
where dc.customer_key is null 
   or dp.product_key is null;