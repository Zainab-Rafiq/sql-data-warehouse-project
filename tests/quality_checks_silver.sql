----CHECKING QUALITY OF SILVER 


--================CRM===================
---1.crm_cust_info
--CHECK FOR NULLS OR DUPLICATES IN PK
--EXPECTATION: NO RESULT

SELECT cst_id,
COUNT(*) 
FROM silver.crm_cust_info
GROUP BY cst_id 
HAVING COUNT(*) > 1 OR cst_id IS NULL

--check for unwanted spaces
--EXPECTATION: NO RESULT
SELECT cst_firstname 
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

--DATA STANDERDIZATION AND CONSISTENCY
SELECT DISTINCT cst_gndr 
FROM silver.crm_cust_info;

---2.crm_prd_info
--CHECK FOR NULLS OR DUPLICATES IN PK
--EXPECTATION: NO RESULT

SELECT prd_id,
COUNT(*) 
FROM silver.crm_prd_info
GROUP BY prd_id 
HAVING COUNT(*) > 1 OR prd_id IS NULL;

--check for unwanted spaces
--EXPECTATION: NO RESULT
SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

--check for NULLs or negative numbers
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

--DATA STANDERDIZATION AND CONSISTENCY
SELECT DISTINCT prd_line
FROM silver.crm_prd_info;

--check for invalid date orders
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt 


---3.crm_sales_details

--check for NULLs or negative numbers
SELECT sls_price 
FROM silver.crm_sales_details 
WHERE sls_price  < 0 OR sls_price IS NULL;

--check for invalid date orders
SELECT *
FROM silver.crm_sales_details 
WHERE sls_order_dt > sls_ship_dt AND sls_order_dt > sls_due_dt ; 

--check data consistency btw sales, quantity and price
--SALES = QUANTITY * PRICE
--VALUES MUST NOT BE NULL, NEGATIVE OR ZERO
SELECT DISTINCT
sls_sales, 
sls_quantity, 
sls_price
FROM silver.crm_sales_details 
WHERE sls_sales != sls_quantity * sls_price 
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price ;

--=================ERP===========================

---erp_cust_az12
--IDENTIFY OUT OF RANGE DATES 
SELECT DISTINCT bdate 
FROM silver.erp_cust_az12 
WHERE bdate <'1924-01-01' OR bdate > GETDATE();

--DATA STANDERDIZATION AND CONSISTENCY
SELECT DISTINCT gen
FROM silver.erp_cust_az12

--erp_loc_a101

--DATA STANDERDIZATION AND CONSISTENCY
SELECT DISTINCT cntry 
FROM silver.erp_loc_a101 
ORDER BY cntry

--erp_px_cat_g1v2

--DATA STANDERDIZATION AND CONSISTENCY
SELECT DISTINCT maintenace 
FROM silver.erp_px_cat_g1v2 

