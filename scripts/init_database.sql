/*
=============================================================
Create Database and Schemas
=============================================================
    This script creates a new database named 'DataWarehouse' after checking if it already exists. 
	
WARNING:
    Running this script will drop the entire 'DataWarehouse' database if it exists. 
    All data in the database will be permanently deleted.
*/

USE master;
GO
-- Drop and recreate the 'DataWarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;

-- Create the 'DataWarehouse' database
CREATE DATABASE DataWarehouse;
GO
  
USE DataWarehouse;
GO
-- Create Schemas
CREATE SCHEMA bronze;
GO 
  
CREATE SCHEMA silver;
GO
  
CREATE SCHEMA gold;
GO
