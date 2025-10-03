/*
================================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
================================================================================
Purpose: 
	Truncate-and-load the Bronze (staging) tables from CSV files.

Notes:
  - Bronze layer mirrors source data with minimal/no business rules.
  - This is a FULL reload: TRUNCATE each table, then BULK INSERT from CSV.
  - Re-runnable/destructive: TRUNCATE removes all rows quickly and resets
    identity values (if any) and requires no referencing FKs on these tables.
================================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS 
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;

	BEGIN TRY
		-- ===== Batch start =====
		SET @batch_start_time = GETDATE();
		PRINT '==================================================================';
		PRINT 'Loading Bronze Layer';
		PRINT '==================================================================';

		PRINT '------------------------------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '------------------------------------------------------------------';

        --==============================--
        -- CRM: bronze.crm_cust_info
        --==============================--
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_cust_info'
		TRUNCATE TABLE bronze.crm_cust_info;

		PRINT '>> Inserting Data into: bronze.crm_cust_info'
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE()
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> ---------------------------------------------------------------';

		--==============================--
        -- CRM: bronze.crm_prd_info
        --==============================--
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_prd_info'
		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT '>> Inserting Data into: bronze.crm_prd_info'
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE()
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> ---------------------------------------------------------------';

        --==============================--
        -- CRM: bronze.crm_sales_details
        --==============================--
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_sales_details'
		TRUNCATE TABLE bronze.crm_sales_details; 

		PRINT '>> Inserting Data into: bronze.crm_sales_details'
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE()
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> ---------------------------------------------------------------';

		PRINT '------------------------------------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '------------------------------------------------------------------';

        --==============================--
        -- ERP: bronze.erp_cust_az12
        --==============================--
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_cust_az12'
		TRUNCATE TABLE bronze.erp_cust_az12; 

		PRINT '>> Inserting Data into: bronze.erp_cust_az12'
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE()
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> ---------------------------------------------------------------';

        --==============================--
        -- ERP: bronze.erp_loc_a101
        --==============================--
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_loc_a101'
		TRUNCATE TABLE bronze.erp_loc_a101; 

		PRINT '>> Inserting Data into: bronze.erp_loc_a101'
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE()
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> ---------------------------------------------------------------';

        --==============================--
        -- ERP: bronze.erp_px_cat_g1v2
        --==============================--
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2'
		TRUNCATE TABLE bronze.erp_px_cat_g1v2; 

		PRINT '>> Inserting Data into: bronze.erp_px_cat_g1v2'
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE()
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> ---------------------------------------------------------------';

		-- ===== Batch end/summary =====
		SET @batch_end_time = GETDATE()
		PRINT '==================================================================';
		PRINT 'Loading Bronze Layer is Completed';
		PRINT '		- Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '==================================================================';

	END TRY
	BEGIN CATCH
		PRINT '==================================================================';
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message'  + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message'  + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '==================================================================';
	END CATCH
END 
