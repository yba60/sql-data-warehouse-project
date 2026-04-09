/*
============================================================
Script: init_database.sql

============================================================
*/

Use master;
GO

/*
------------------------------------------------------------
Step 1: Drop database if it already exists 
------------------------------------------------------------
*/
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    PRINT 'Database exists. Dropping DataWarehouse...';

    -- Force disconnect all users and rollback active transactions
    ALTER DATABASE DataWarehouse
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

    DROP DATABASE DataWarehouse;

    PRINT 'Database dropped successfully.';
END
GO

/*
------------------------------------------------------------
Step 2: Create a fresh database
------------------------------------------------------------
*/
PRINT 'Creating DataWarehouse database...';
CREATE DATABASE DataWarehouse;
GO

/*
------------------------------------------------------------
Step 3: Switch context to the new database
------------------------------------------------------------
*/
USE DataWarehouse;
GO

/*
------------------------------------------------------------
Step 4: Create schemas (Medallion Architecture)
------------------------------------------------------------
bronze  = raw data (ingestion layer)
silver  = cleaned & transformed data
gold    = business-ready / analytics layer
------------------------------------------------------------
*/

PRINT 'Creating schemas...';
GO

CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO

PRINT 'Schemas created successfully.';
GO

/*
============================================================
End of Script
============================================================
*/