/*
================================================================================
Bronze Layer — Source Staging Tables
================================================================================
Script Purpose:
	This script creates the raw "bronze" staging tables that mimic the structure 
	of upstream CRM and ERP source systems. These tables act as the landing zone 
	for raw ingested data before any cleaning or transformations.

Notes:
	- DROP TABLE IF EXISTS is used to allow re-running this script safely.
    - All data types and field lengths reflect assumed source-system structures.
    - No constraints (PK/FK) are added at this stage; bronze is kept raw/unaltered.

Attribution:
    This script was developed as part of a learning project based on a tutorial by DataWithBaraa.
    For more details and source reference, see the project README.
================================================================================
*/

-- ============================================================================
-- CRM: Customer Information (basic customer master data from CRM system)
-- ============================================================================
DROP TABLE IF EXISTS bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info (
    cst_id				INT,                        
    cst_key				NVARCHAR(50),              
    cst_firstname		NVARCHAR(50),
    cst_lastname		NVARCHAR(50),
    cst_marital_status	NVARCHAR(50),
    cst_gndr			NVARCHAR(50),            
    cst_create_date		DATE            
); 
GO

-- ============================================================================
-- CRM: Product Information (product master data from CRM system)
-- ============================================================================
DROP TABLE IF EXISTS bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info (
    prd_id			INT,                       
    prd_key			NVARCHAR(50),
    prd_nm			NVARCHAR(50),            
    prd_cost		INT,                 
    prd_line		NVARCHAR(50),         
    prd_start_dt	DATETIME,
    prd_end_dt		DATETIME
);
GO

-- ============================================================================
-- CRM: Sales Details (transaction-level sales records)
-- ===========================================================================
DROP TABLE IF EXISTS bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details (
    sls_ord_num		NVARCHAR(50), 
    sls_prd_key		NVARCHAR(50),      
    sls_cust_id		INT,                  
    sls_order_dt	INT,              
    sls_ship_dt		INT,                
    sls_due_dt		INT,
    sls_sales		INT,                
    sls_quantity	INT,
    sls_price		INT                     
);
GO

-- ============================================================================
-- ERP: Customer Additional Info (from ERP system "AZ12")
-- ============================================================================
DROP TABLE IF EXISTS bronze.erp_cust_az12;
CREATE TABLE bronze.erp_cust_az12 (
    cid		NVARCHAR(50),                  
    bdate	DATE,                       
    gen		NVARCHAR(50)                   
);
GO

-- ============================================================================
-- ERP: Customer Location (from ERP system "A101")
-- ============================================================================
DROP TABLE IF EXISTS bronze.erp_loc_a101;
CREATE TABLE bronze.erp_loc_a101 (
	cid		NVARCHAR(50),
	cntry	NVARCHAR(50)
);
GO

-- ============================================================================
-- ERP: Product Category (from ERP system "G1V2")
-- ============================================================================
DROP TABLE IF EXISTS bronze.erp_px_cat_g1v2;
CREATE TABLE bronze.erp_px_cat_g1v2 (
	id			NVARCHAR(50),
	cat			NVARCHAR(50),
	subcat		NVARCHAR(50),
	maintenance	NVARCHAR(50)
);
GO
