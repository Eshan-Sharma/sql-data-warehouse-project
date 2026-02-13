## Data Catalog for Gold Layer

### Overview

The Gold Layer is the business-facing data mart, optimized for analytics, dashboards, and reporting. It integrates cleansed and enriched attributes from Silver into **dimension tables** and **fact tables**, with enforced **foreign key relationships** to maintain referential integrity.

#### 1. `gold.dim_customers`

**Purpose:** Contains enriched customer infomation combining demographic and geographic attributes.

**Columns:**

| Column Name       | Data Type   | Description                                                                                           |
| ----------------- | ----------- | ----------------------------------------------------------------------------------------------------- |
| `customer_key`    | INT         | Surrogate key generated with `ROW_NUMBER()` to uniquely identify each customer record.                |
| `customer_id`     | INT         | Source CRM identifier for the customer.                                                               |
| `customer_number` | VARCHAR(50) | Business reference key for the customer (alphanumeric).                                               |
| `first_name`      | VARCHAR(50) | Customer’s given name.                                                                                |
| `last_name`       | VARCHAR(50) | Customer’s family or last name.                                                                       |
| `gender`          | VARCHAR(50) | Gender of the customer. Defaults to CRM; enriched from ERP if missing. (e.g., 'Male', 'Female','n/a') |
| `birth_date`      | DATE        | Customer’s date of birth.                                                                             |
| `country`         | VARCHAR(50) | Country of residence, enriched from ERP location system.                                              |
| `marital_status`  | VARCHAR(50) | Marital status (e.g., ‘Married’, ‘Single’).                                                           |
| `create_date`     | DATE        | Record creation date in CRM.                                                                          |

#### 2. `gold.dim_products`

**Purpose:** Provides detailed product master data including categorization, cost, and lifecycle.

**Columns:**

| Column Name      | Data Type   | Description                                                                                            |
| ---------------- | ----------- | ------------------------------------------------------------------------------------------------------ |
| `product_key`    | INT         | Surrogate key uniquely identifying each product record (`ROW_NUMBER()` by product start date and key). |
| `product_id`     | INT         | Internal system identifier for the product.                                                            |
| `product_number` | VARCHAR(50) | SKU/product number used in transactions.                                                               |
| `product_name`   | VARCHAR(50) | Full descriptive name of the product.                                                                  |
| `category_id`    | VARCHAR(50) | Identifier linking product to a category hierarchy.                                                    |
| `category`       | VARCHAR(50) | High-level product classification (e.g., Bikes, Components).                                           |
| `sub_category`   | VARCHAR(50) | More granular classification within a category.                                                        |
| `maintenance`    | VARCHAR(50) | Indicates whether product requires maintenance (‘Yes’, ‘No’).                                          |
| `product_cost`   | INT         | Standard cost of the product.                                                                          |
| `product_line`   | VARCHAR(50) | Product line or series (e.g., Road, Mountain).                                                         |
| `start_date`     | DATE        | Date product became available (from `prd_start_dt`).                                                   |

#### 3. `gold.fact_sales`

**Purpose:** Stores transactional sales data, capturing sales order details and linking them to products and customers.

**Columns:**

| Column Name    | Data Type   | Description                                                      |
| -------------- | ----------- | ---------------------------------------------------------------- |
| `order_number` | VARCHAR(50) | Unique alphanumeric sales order identifier (e.g., SO12345).      |
| `product_key`  | INT         | Foreign key reference to `gold.dim_products`.product_key.        |
| `customer_key` | INT         | Foreign key reference to `gold.dim_customers`.customer_key.      |
| `order_date`   | DATE        | Date the order was placed.                                       |
| `ship_date`    | DATE        | Date the order was shipped.                                      |
| `due_date`     | DATE        | Date payment for the order was due.                              |
| `sales_amount` | INT         | Total sales value for the line item. (Sales = Quantity \* Price) |
| `quantity`     | INT         | Number of units purchased.                                       |
| `price`        | INT         | Price per unit at time of transaction.                           |

#### Foreign Key Relationships

| Fact Table        | Foreign Key    | Dimension Reference                 |
| ----------------- | -------------- | ----------------------------------- |
| `gold.fact_sales` | `product_key`  | → `gold.dim_products.product_key`   |
| `gold.fact_sales` | `customer_key` | → `gold.dim_customers.customer_key` |
