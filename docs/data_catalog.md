# Data Catalog for Gold Layer

## Overview

The Gold Layer is the business-ready representation designed for analytics and reporting. It contains **dimension tables** and **fact tables** that model business entities and metrics.

---

### 1. gold.dim_customer
- **Purpose:** Stores customer attributes enriched with demographic and geographic data for analysis. One row per customer.
- **Columns:**

| Column Name     | Data Type     | Description                                                                                           |
|-----------------|---------------|-------------------------------------------------------------------------------------------------------|
| customer_key    | INT           | Surrogate key uniquely identifying each customer record in this dimension (primary key).              |
| customer_id     | INT           | Source system customer ID.                                                                            |
| customer_number | NVARCHAR(50)  | Business/customer number used for tracking and referencing (from source).                             |
| first_name      | NVARCHAR(50)  | Customer’s first name.                                                                                |
| last_name       | NVARCHAR(50)  | Customer’s last name.                                                                                 |
| country         | NVARCHAR(50)  | Customer’s country (standardized; e.g., “Canada”, “United States”; “n/a” if unknown).                 |
| marital_status  | NVARCHAR(50)  | Marital status (e.g., “Married”, “Single”, “n/a”).                                                    |
| gender          | NVARCHAR(50)  | Gender (e.g., “Male”, “Female”, “n/a”).                                                               |
| birthdate       | DATE          | Date of birth.                                                                                        |
| create_date     | DATE          | Date the customer record was created in the source system.                                            |

---

### 2. gold.dim_products
- **Purpose:** Stores product attributes for analysis. One row per product.
- **Columns:**

| Column Name          | Data Type     | Description                                                                 |
|----------------------|---------------|-----------------------------------------------------------------------------|
| product_key          | INT           | Surrogate key uniquely identifying each product record (primary key).       |
| product_id           | INT           | Source system product ID.                                                   |
| product_number       | NVARCHAR(50)  | Business/product code used for tracking and inventory.                      |
| product_name         | NVARCHAR(50)  | Product name as provided by the source.                                     |
| category_id          | NVARCHAR(50)  | Identifier for the product’s category from the source mapping.              |
| category             | NVARCHAR(50)  | Top-level category (e.g., “Bikes”, “Components”).                           |
| subcategory          | NVARCHAR(50)  | Detailed classification within the category (e.g., “Helmets”, “Tires”).     |
| maintenance_required | NVARCHAR(50)  | Indicates whether the product requires maintenance (e.g., “Yes”, “No”).     |
| cost                 | INT           | Unit cost in whole currency units.                                          |
| product_line         | NVARCHAR(50)  | Product line or series (e.g., “Road”, “Mountain”).                          |
| start_date           | DATE          | Date the product became available.                                          |

---

### 3. gold.fact_sales
- **Purpose:** Stores transactional sales facts for analysis. One row per order line.
- **Columns:**

| Column Name   | Data Type     | Description                                                              |
|---------------|---------------|--------------------------------------------------------------------------|
| order_number  | NVARCHAR(50)  | Sales order identifier (e.g., “SO54496”).                                |
| product_key   | INT           | Foreign key referencing `gold.dim_products(product_key)`.                |
| customer_key  | INT           | Foreign key referencing `gold.dim_customer(customer_key)`.               |
| order_date    | DATE          | Date the order was placed.                                               |
| shipping_date | DATE          | Date the order was shipped.                                              |
| due_date      | DATE          | Date payment was due.                                                    |
| sales_amount  | INT           | Total amount for the line item, in whole currency units.                 |
| quantity      | INT           | Number of units ordered for the line item.                               |
| price         | INT           | Unit price for the product on the line item, in whole currency units.    |
