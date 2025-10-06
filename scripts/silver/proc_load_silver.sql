/*
================================================================================
Procedure: silver.load_silver
--------------------------------------------------------------------------------
Purpose:
    Cleans and transforms data from the Bronze layer into the Silver layer.
    Performs a full reload (TRUNCATE + INSERT) of all Silver tables.

Notes:
    - Normalizes values, removes duplicates, and fixes invalid data.
    - Converts integer-formatted dates to DATE.
    - dwh_create_date auto-populates via DEFAULT GETDATE().
    - Destructive operation — all existing Silver data is replaced.

Attribution:
    Developed as part of a learning project inspired by DataWithBaraa’s tutorials.
    For source details, see the project README.
================================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver
AS
BEGIN
    
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;

	BEGIN TRY
        -- ===== Batch start =====
        SET @batch_start_time = GETDATE();
        PRINT '==================================================================';
        PRINT 'Loading Silver Layer';
        PRINT '==================================================================';

        PRINT '------------------------------------------------------------------';
        PRINT 'Loading CRM Tables';
        PRINT '------------------------------------------------------------------';

		--==============================--
        -- CRM: silver.crm_cust_info
        --==============================--
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.crm_cust_info';
        TRUNCATE TABLE silver.crm_cust_info;
        PRINT '>> Inserting Data into: silver.crm_cust_info';
        INSERT INTO silver.crm_cust_info (
            cst_id,
            cst_key,
            cst_firstname,
            cst_lastname,
            cst_marital_status,
            cst_gndr,
            cst_create_date
        )
		SELECT 
            cst_id,
            cst_key,
            TRIM(cst_firstname)       AS cst_firstname,
            TRIM(cst_lastname)        AS cst_lastname,
            CASE
                WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
                WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
                ELSE 'n/a'
            END                       AS cst_marital_status,
            CASE
                WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
                WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
                ELSE 'n/a'
            END                       AS cst_gndr,
            cst_create_date
        FROM (
			SELECT
                *,
                ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
            FROM bronze.crm_cust_info
            WHERE cst_id IS NOT NULL
        ) t
        WHERE flag_last = 1;   -- Most recent record per customer
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20)) + ' seconds';
        PRINT '>> ---------------------------------------------------------------';
		
		--==============================--
        -- CRM: silver.crm_prd_info
        --==============================--
		SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.crm_prd_info';
        TRUNCATE TABLE silver.crm_prd_info;
        PRINT '>> Inserting Data into: silver.crm_prd_info';
        INSERT INTO silver.crm_prd_info (
            prd_id,
            cat_id,
            prd_key,
            prd_nm,
            prd_cost,
            prd_line,
            prd_start_dt,
            prd_end_dt
        )
        SELECT
            prd_id,
            REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,  -- Extract category ID
            SUBSTRING(prd_key, 7, LEN(prd_key))          AS prd_key, -- Extract product key
            prd_nm,
            ISNULL(prd_cost, 0)                           AS prd_cost,
            CASE UPPER(TRIM(prd_line)) 
                WHEN 'M' THEN 'Mountain'
                WHEN 'R' THEN 'Road'
                WHEN 'S' THEN 'Other Sales'
                WHEN 'T' THEN 'Touring'
                ELSE 'n/a'
            END                                           AS prd_line,
            CAST(prd_start_dt AS DATE)                    AS prd_start_dt,
            CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - 1 AS DATE)
                                                         AS prd_end_dt  -- One day before next start
        FROM bronze.crm_prd_info;
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20)) + ' seconds';
        PRINT '>> ---------------------------------------------------------------';
		
		--==============================--
        -- CRM: silver.crm_sales_details
        --==============================--
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.crm_sales_details';
        TRUNCATE TABLE silver.crm_sales_details;
        PRINT '>> Inserting Data into: silver.crm_sales_details';
        INSERT INTO silver.crm_sales_details (
            sls_ord_num, 
            sls_prd_key,      
            sls_cust_id,                  
            sls_order_dt,              
            sls_ship_dt,                
            sls_due_dt,
            sls_sales,                
            sls_quantity,
            sls_price
        )
        SELECT
            sls_ord_num,
            sls_prd_key,
            sls_cust_id,
            CASE 
                WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
                ELSE CAST(CAST(sls_order_dt AS VARCHAR(8)) AS DATE)
            END AS sls_order_dt,
            CASE 
                WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
                ELSE CAST(CAST(sls_ship_dt AS VARCHAR(8)) AS DATE)
            END AS sls_ship_dt,
            CASE 
                WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
                ELSE CAST(CAST(sls_due_dt AS VARCHAR(8)) AS DATE)
            END AS sls_due_dt,
            CASE 
                WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
                    THEN sls_quantity * ABS(sls_price)
                ELSE sls_sales
            END AS sls_sales,   -- Recalculate if missing/incorrect
            sls_quantity,
            CASE 
                WHEN sls_price IS NULL OR sls_price <= 0 
                    THEN sls_sales / NULLIF(sls_quantity, 0)
                ELSE sls_price
            END AS sls_price    -- Derive if invalid
        FROM bronze.crm_sales_details;
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20)) + ' seconds';
        PRINT '>> ---------------------------------------------------------------';

        PRINT '------------------------------------------------------------------';
        PRINT 'Loading ERP Tables';
        PRINT '------------------------------------------------------------------';

		--==============================--
        -- ERP: silver.erp_cust_az12
        --==============================--
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.erp_cust_az12';
        TRUNCATE TABLE silver.erp_cust_az12;
        PRINT '>> Inserting Data into: silver.erp_cust_az12';
        INSERT INTO silver.erp_cust_az12 (
            cid,
            bdate,
            gen
        )
        SELECT
            CASE 
                WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
                ELSE cid
            END AS cid,
            CASE 
                WHEN bdate > CAST(GETDATE() AS DATE) THEN NULL
                ELSE bdate
            END AS bdate,
            CASE
                WHEN gen = 'M' OR gen = 'Male' THEN 'Male'
                WHEN gen = 'F' OR gen = 'Female' THEN 'Female'
                ELSE 'n/a'
            END AS gen
        FROM bronze.erp_cust_az12;
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20)) + ' seconds';
        PRINT '>> ---------------------------------------------------------------';

        --==============================--
        -- ERP: silver.erp_loc_a101
        --==============================--
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.erp_loc_a101';
        TRUNCATE TABLE silver.erp_loc_a101;
        PRINT '>> Inserting Data into: silver.erp_loc_a101';
        INSERT INTO silver.erp_loc_a101 (
            cid,
            cntry
        )
        SELECT
            REPLACE(cid, '-', '') AS cid,
            CASE
                WHEN UPPER(cntry) IN ('US', 'USA') THEN 'United States'
                WHEN UPPER(cntry) = 'DE' THEN 'Germany'
                WHEN NULLIF(TRIM(cntry), '') IS NULL THEN 'n/a'  -- NULL or ''
                ELSE cntry
            END AS cntry
        FROM bronze.erp_loc_a101;
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20)) + ' seconds';
        PRINT '>> ---------------------------------------------------------------';

        --==============================--
        -- ERP: silver.erp_px_cat_g1v2
        --==============================--
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.erp_px_cat_g1v2';
        TRUNCATE TABLE silver.erp_px_cat_g1v2;
        PRINT '>> Inserting Data into: silver.erp_px_cat_g1v2';
        INSERT INTO silver.erp_px_cat_g1v2 (
            id,
            cat,
            subcat,
            maintenance
        )
        SELECT 
            id,
            cat,
            subcat,
            maintenance
        FROM bronze.erp_px_cat_g1v2;
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20)) + ' seconds';
        PRINT '>> ---------------------------------------------------------------';

        -- ===== Batch end/summary =====
        SET @batch_end_time = GETDATE();
        PRINT '==================================================================';
        PRINT 'Loading Silver Layer has completed.';
        PRINT '    - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR(20)) + ' seconds';
        PRINT '==================================================================';

    END TRY
    BEGIN CATCH
        PRINT '==================================================================';
        PRINT 'ERROR OCCURRED DURING LOADING SILVER LAYER';
        PRINT '  Error Message: ' + ERROR_MESSAGE();
        PRINT '  Error Number : ' + CAST(ERROR_NUMBER() AS NVARCHAR(20));
        PRINT '  Error State  : ' + CAST(ERROR_STATE() AS NVARCHAR(20));
        PRINT '==================================================================';
        -- Optional: rethrow
        -- THROW;
    END CATCH
END
