-- Use the target catalog
USE CATALOG datawarehouse;

-- CRM: customer information
DROP TABLE IF EXISTS bronze.crm_cust_info;
create table bronze.crm_cust_info(
  cst_id              INT,
  cst_key             VARCHAR(50),
  cst_firstname       VARCHAR(50),
  cst_lastname        VARCHAR(50),
  cst_marital_status  VARCHAR(50),
  cst_gndr            VARCHAR(50),
  cst_create_date     DATE
);
-- CRM: product information
DROP TABLE IF EXISTS bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info(
  prd_id       INT,          -- product ID
  prd_key      VARCHAR(50),  -- product key
  prd_nm       VARCHAR(50),  -- product name
  prd_cost     INTEGER,      -- cost
  prd_line     VARCHAR(50),  -- product line
  prd_start_dt DATE,
  prd_end_dt   DATE
);

-- CRM: sales transactions
DROP TABLE IF EXISTS bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details(
  sls_ord_num  VARCHAR(50),  -- order number
  sls_prd_key  VARCHAR(50),  -- product key
  sls_cust_id  INT,          -- customer ID
  sls_order_dt INT,          -- order date
  sls_ship_dt  INT,          -- ship date
  sls_due_dt   INT,          -- due date
  sls_sales    INT,          -- sales amount
  sls_quantity INT,          -- quantity
  sls_price    INT           -- price
);

-- ERP: product category/subcategory reference
DROP TABLE IF EXISTS bronze.erp_PX_CAT_G1V2;
CREATE TABLE bronze.erp_PX_CAT_G1V2(
  ID           VARCHAR(50),   -- category ID
  CAT          VARCHAR(50),   -- category name
  SUBCAT       VARCHAR(50),   -- subcategory
  MAINTENANCE  VARCHAR(50)    -- maintenance info
);

-- ERP: country/location reference
DROP TABLE IF EXISTS bronze.erp_LOC_A101;
CREATE TABLE bronze.erp_LOC_A101(
  CID   VARCHAR(50),   -- location ID
  CNTRY VARCHAR(50)    -- country name
);

-- ERP: basic customer attributes
DROP TABLE IF EXISTS bronze.erp_CUST_AZ12;
CREATE TABLE bronze.erp_CUST_AZ12(
  CID   VARCHAR(50),   -- customer ID
  BDATE DATE,          -- birth date
  GEN   VARCHAR(50)    -- gender
);