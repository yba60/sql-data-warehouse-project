/*
===============================================================================
Script Name      : init_database.sql
Object Type      : Setup Script
Layer            : N/A (Environment Setup)
Schema           : N/A
Purpose          : Initialize and reset the DataWarehouse database environment.
Description      : Drops the existing DataWarehouse database if it exists,
                   recreates it from scratch, and sets up the Medallion
                   architecture schemas (bronze, silver, gold).
Source Systems   : N/A
Dependencies     : None
Notes            : 
    - This script will permanently delete the existing DataWarehouse database.
    - Intended for development and testing only (NOT for production use).
    - Safely handles active connections using SINGLE_USER mode.
Author           : Ryan Bai
===============================================================================
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