-- Create a gold table for product information with category details
select 
    pi.prd_id, 
    pi.cat_id, 
    pi.prd_key, 
    pi.prd_nm, 
    pi.prd_cost, 
    pi.prd_line, 
    pi.prd_start_dt, 
    pi.prd_end_dt,
    ep.CAT,
    ep.SUBCAT,
    ep.MAINTENANCE
from silver.crm_prd_info pi
left join silver.erp_px_cat_g1v2 ep
    on pi.cat_id = ep.ID;


-- Check for duplicates
select 
    prd_id, 
    count(*)
from (
    select 
        pi.prd_id, 
        pi.cat_id, 
        pi.prd_key, 
        pi.prd_nm, 
        pi.prd_cost, 
        pi.prd_line, 
        pi.prd_start_dt, 
        pi.prd_end_dt,
        ep.CAT,
        ep.SUBCAT,
        ep.MAINTENANCE
    from silver.crm_prd_info pi
    left join silver.erp_px_cat_g1v2 ep
        on pi.cat_id = ep.ID
) t
group by prd_id 
having count(*) > 1;


-- Filtering out old historical data
select 
    pi.prd_id, 
    pi.cat_id, 
    pi.prd_key, 
    pi.prd_nm, 
    pi.prd_cost, 
    pi.prd_line, 
    pi.prd_start_dt, 
    ep.CAT,
    ep.SUBCAT,
    ep.MAINTENANCE
from silver.crm_prd_info pi
left join silver.erp_px_cat_g1v2 ep
    on pi.cat_id = ep.ID 
where prd_end_dt is null;


-- Reorganize columns logically and rename for clarity
select 
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


-- Create a surrogate key for unique identification
select 
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
