/*
================================================================================
Bronze Layer — Source Staging Tables
================================================================================
Script Purpose:
    Create raw "bronze" staging tables that mirror upstream CRM/ERP sources.
    These are the landing zones for ingested data before any cleaning or transforms.

Notes:
    - Uses DROP TABLE IF EXISTS so the script can be re-run safely.
    - Data types/lengths reflect assumed source structures.
    - No constraints (PK/FK/UNIQUE/CHECK) at this stage; bronze stays raw/unaltered.

Attribution:
    This script was developed as part of a learning project based on
    DataWithBaraa’s tutorials. For source details, refer to the project README.
================================================================================
*/

-- ============================================================================
-- CRM: Customer Information (basic customer master data from the CRM system)
-- ============================================================================
DROP TABLE IF EXISTS bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info (
    cst_id              INT,            
    cst_key             NVARCHAR(50),   
    cst_firstname       NVARCHAR(50),
    cst_lastname        NVARCHAR(50),
    cst_marital_status  NVARCHAR(50),
    cst_gndr            NVARCHAR(50),   
    cst_create_date     DATE           
);
GO

-- ============================================================================
-- CRM: Product Information (product master data from the CRM system)
-- ============================================================================
DROP TABLE IF EXISTS bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info (
    prd_id          INT,               
    prd_key         NVARCHAR(50),      
    prd_nm          NVARCHAR(50),      
    prd_cost        INT,            
    prd_line        NVARCHAR(50),      
    prd_start_dt    DATETIME,          
    prd_end_dt      DATETIME          
);
GO

-- ============================================================================
-- CRM: Sales Details (transaction-level sales records; raw from CRM)
--   Note: Dates arrive as integers from source (e.g., 20210131). Keep raw here.
-- ============================================================================
DROP TABLE IF EXISTS bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details (
    sls_ord_num     NVARCHAR(50),  
    sls_prd_key     NVARCHAR(50), 
    sls_cust_id     INT,           
    sls_order_dt    INT,          
    sls_ship_dt     INT,          
    sls_due_dt      INT,         
    sls_sales       INT,         
    sls_quantity    INT,           
    sls_price       INT          
);
GO

-- ============================================================================
-- ERP: Customer Additional Info (from ERP system "AZ12")
-- ============================================================================
DROP TABLE IF EXISTS bronze.erp_cust_az12;
CREATE TABLE bronze.erp_cust_az12 (
    cid     NVARCHAR(50),  
    bdate   DATE,          
    gen     NVARCHAR(50) 
);
GO

-- ============================================================================
-- ERP: Customer Location (from ERP system "A101")
-- ============================================================================
DROP TABLE IF EXISTS bronze.erp_loc_a101;
CREATE TABLE bronze.erp_loc_a101 (
    cid     NVARCHAR(50),   
    cntry   NVARCHAR(50)    
);
GO

-- ============================================================================
-- ERP: Product Category (from ERP system "G1V2")
-- ============================================================================
DROP TABLE IF EXISTS bronze.erp_px_cat_g1v2;
CREATE TABLE bronze.erp_px_cat_g1v2 (
    id           NVARCHAR(50), 
    cat          NVARCHAR(50), 
    subcat       NVARCHAR(50), 
    maintenance  NVARCHAR(50)   
);
GO

