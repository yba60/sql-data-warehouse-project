/*
================================================
Create Database and Schema
================================================
Script Purpose:
	This script creates a new database named 'DataWarehouse' after checking if it already exists.
	If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas
	within the database: 'bronze', 'silver', and 'gold'.

WARNING:
	Running this script will drop the entire 'DataWarehouse' database if it exists.
	All data in the database will be permanently deleted. Proceed with caution and ensure you have
	proper backups before running this script. 

Attribution:
    This script was developed as part of a learning project based on a tutorial by DataWithBaraa.
    For more details and source reference, see the project README.
*/

-- Switch to the 'master' database
USE master;

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
