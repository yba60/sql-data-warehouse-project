/*
============================================================
Procedure Name	: proc_load_bronze.sql
Layer			: Bronze
Purpose			: Load raw data from CRM and ERP source file into bronze tables
============================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze 
AS 
BEGIN
	DECLARE 
		@start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();

		PRINT REPLICATE('=', 60);
		PRINT 'Loading Bronze Layer';
		PRINT REPLICATE('=', 60);

		------------------------------------------------------------
		-- CRM TABLES
		------------------------------------------------------------
		PRINT REPLICATE('-', 60);
		PRINT 'Loading CRM Tables';
		PRINT REPLICATE('-', 60);

		-- =========================
		-- crm_cust_info
		-- =========================
		SET @start_time = GETDATE();

		PRINT '>> Truncating: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;

		PRINT '>> Loading: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\workspace\sql-data-warehouse-project\dataset\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE();
		PRINT '>> Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' sec';
		PRINT REPLICATE('-', 40);

		-- =========================
		-- crm_prd_info
		-- =========================
		SET @start_time = GETDATE();

		PRINT '>> Truncating: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT '>> Loading: bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\workspace\sql-data-warehouse-project\dataset\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE();
		PRINT '>> Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' sec';
		PRINT REPLICATE('-', 40);

		-- =========================
		-- crm_sales_details
		-- =========================
		SET @start_time = GETDATE();

		PRINT '>> Truncating: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;

		PRINT '>> Loading: bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\workspace\sql-data-warehouse-project\dataset\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE();
		PRINT '>> Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' sec';
		PRINT REPLICATE('-', 40);

		------------------------------------------------------------
		-- ERP TABLES
		------------------------------------------------------------
		PRINT REPLICATE('-', 60);
		PRINT 'Loading ERP Tables';
		PRINT REPLICATE('-', 60);

		-- =========================
		-- erp_cust_az12
		-- =========================
		SET @start_time = GETDATE();

		PRINT '>> Truncating: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;

		PRINT '>> Loading: bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\workspace\sql-data-warehouse-project\dataset\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE();
		PRINT '>> Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' sec';
		PRINT REPLICATE('-', 40);

		-- =========================
		-- erp_loc_a101
		-- =========================
		SET @start_time = GETDATE();

		PRINT '>> Truncating: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;

		PRINT '>> Loading: bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\workspace\sql-data-warehouse-project\dataset\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE();
		PRINT '>> Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' sec';
		PRINT REPLICATE('-', 40);

		-- =========================
		-- erp_px_cat_g1v2
		-- =========================
		SET @start_time = GETDATE();

		PRINT '>> Truncating: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		PRINT '>> Loading: bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\workspace\sql-data-warehouse-project\dataset\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_time = GETDATE();
		PRINT '>> Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' sec';
		PRINT REPLICATE('-', 40);
		
		------------------------------------------------------------
		-- Final SUMMARY
		------------------------------------------------------------
		SET @batch_end_time = GETDATE();

		PRINT REPLICATE('=', 60);
		PRINT 'Bronze Layer Load Completed';
		PRINT 'Total Duration: '
			+ CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR)
			+ ' sec';
		PRINT REPLICATE('=', 60)
	END TRY
	
	BEGIN CATCH
		PRINT REPLICATE('=', 60);
		PRINT 'ERROR DURING BRONZE LOAD';
		PRINT 'Message	: ' + ERROR_MESSAGE();
		PRINT 'Number	: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'State	: ' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT REPLICATE('=', 60);
	END CATCH
	
END;


