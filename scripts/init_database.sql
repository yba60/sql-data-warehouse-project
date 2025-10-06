/*
================================================================================
Create Database and Schemas: DataWarehouse
================================================================================
Script Purpose:
    - Creates a new database named 'DataWarehouse' after verifying if it already exists.
    - If the database exists, it is dropped and recreated.
    - Sets up three schemas within the database:
        1. bronze — stores raw, unprocessed data
        2. silver — stores cleaned and transformed data
        3. gold   — stores curated, analytics-ready data

WARNING:
	Running this script will DROP the existing 'DataWarehouse' database (if present).
       All data in it will be permanently deleted.
       Ensure proper backups exist before running this script.

Attribution:
    This script was developed as part of a learning project based on
    DataWithBaraa’s tutorials. For source details, refer to the project README.
================================================================================
*/

-- Switch to the 'master' database 
USE master; 
GO

-- Drop and recreate the 'DataWarehouse' database 
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse') 
BEGIN 
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE; 
	DROP DATABASE DataWarehouse; 
END; 
GO

-- Create a new database named 'DataWarehouse'
CREATE DATABASE DataWarehouse;
GO

-- Switch to the new 'DataWarehouse' database
USE DataWarehouse;
GO

-- Create schema 'bronze' for raw data
CREATE SCHEMA bronze;
GO

-- Create schema 'silver' for cleaned and transformed data
CREATE SCHEMA silver;
GO

-- Create schema 'gold' for curated, business-ready data 
CREATE SCHEMA gold;
GO
