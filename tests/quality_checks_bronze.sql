----CHECKING QUALITY OF BRONZE 

--==========CRM================
----1.crm_cust_info

--CHECK FOR NULLS OR DUPLICATES IN PK
--EXPECTATION: NO RESULT

SELECT cst_id,
COUNT(*) 
FROM bronze.crm_cust_info
GROUP BY cst_id 
HAVING COUNT(*) > 1 OR cst_id IS NULL;

--check for unwanted spaces
--EXPECTATION: NO RESULT
SELECT cst_firstname 
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

--DATA STANDERDIZATION AND CONSISTENCY
SELECT DISTINCT cst_gndr 
FROM bronze.crm_cust_info;

SELECT DISTINCT cst_marital_status 
FROM bronze.crm_cust_info;

---2.crm_prd_info
--CHECK FOR NULLS OR DUPLICATES IN PK
--EXPECTATION: NO RESULT

SELECT prd_id,
COUNT(*) 
FROM bronze.crm_prd_info
GROUP BY prd_id 
HAVING COUNT(*) > 1 OR prd_id IS NULL

--check for unwanted spaces
--EXPECTATION: NO RESULT
SELECT prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

--check for NULLs or negative numbers
SELECT prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

--DATA STANDERDIZATION AND CONSISTENCY
SELECT DISTINCT prd_line
FROM bronze.crm_prd_info;

--check for invalid date orders
SELECT *
FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt ;


---3.crm_sales_details
--CHECK FOR NULLS OR DUPLICATES IN PK
--EXPECTATION: NO RESULT

SELECT sls_ord_num,
COUNT(*) 
FROM bronze.crm_sales_details
GROUP BY sls_ord_num  
HAVING COUNT(*) > 1 OR sls_ord_num IS NULL

--check for NULLs or negative numbers
SELECT sls_price 
FROM bronze.crm_sales_details 
WHERE sls_price  < 0 OR sls_price IS NULL

--check for invalid date orders
SELECT NULLIF(sls_order_dt, 0) sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0 
OR LEN(sls_order_dt) !=8
OR sls_order_dt > 20500101
OR sls_order_dt < 19900109;

SELECT 
sls_ship_dt,
NULLIF(sls_ship_dt, 0) sls_ship_dt
FROM bronze.crm_sales_details
WHERE sls_ship_dt <= 0 
OR LEN(sls_ship_dt) !=8
OR sls_ship_dt > 20500101
OR sls_ship_dt < 19900109;

SELECT 
sls_due_dt,
NULLIF(sls_due_dt, 0) sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0 
OR LEN(sls_due_dt) !=8
OR sls_due_dt > 20500101
OR sls_due_dt < 19900109;

SELECT *
FROM bronze.crm_sales_details 
WHERE sls_order_dt > sls_ship_dt AND sls_order_dt > sls_due_dt ; 

--check data consistency btw sales, quantity and price
--SALES = QUANTITY * PRICE
--VALUES MUST NOT BE NULL, NEGATIVE OR ZERO
SELECT DISTINCT
sls_sales, 
sls_quantity, 
sls_price
FROM bronze.crm_sales_details 
WHERE sls_sales != sls_quantity * sls_price 
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price ;

---=============ERP===============

--1.erp_cust_az12

--IDENTIFY OUT OF RANGE DATES 
SELECT DISTINCT bdate 
FROM bronze.erp_cust_az12 
WHERE bdate <'1924-01-01' OR bdate > GETDATE();

--DATA STANDERDIZATION AND CONSISTENCY
SELECT DISTINCT gen
FROM bronze.erp_cust_az12;

---2.erp_loc_a101
--match column with other column
SELECT 
REPLACE(cid,'-','') cid,
cntry 
FROM bronze.erp_loc_a101;

--DATA STANDERDIZATION AND CONSISTENCY
SELECT DISTINCT cntry 
FROM bronze.erp_loc_a101 
ORDER BY cntry 

---3.erp_px_cat_g1v2
--CHECK FOR UNWANTED SPACE
SELECT cat
FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenace != TRIM(maintenace)

--DATA STANDERDIZATION AND CONSISTENCY
SELECT DISTINCT cat 
FROM bronze.erp_px_cat_g1v2 

SELECT DISTINCT subcat 
FROM bronze.erp_px_cat_g1v2 

SELECT DISTINCT maintenace 
FROM bronze.erp_px_cat_g1v2 
