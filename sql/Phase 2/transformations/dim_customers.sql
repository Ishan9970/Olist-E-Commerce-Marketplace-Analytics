CREATE DATABASE olist;
USE olist;

-- Load customers
TRUNCATE TABLE customers;

SET GLOBAL local_infile = 1;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_customers_dataset.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Check duplicates
SELECT customer_unique_id, COUNT(*) 
FROM customers
GROUP BY customer_unique_id
ORDER BY COUNT(*) DESC;

-- Build dim_customers
CREATE TABLE dim_customers AS
SELECT
    ROW_NUMBER() OVER () AS customer_key,
    customer_unique_id,
    customer_zip_code_prefix AS zip_code,
    LOWER(TRIM(customer_city)) AS city,
    UPPER(TRIM(customer_state)) AS state
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY customer_unique_id
               ORDER BY customer_id DESC
           ) AS rn
    FROM customers
) t
WHERE rn = 1;

-- Validation
SELECT COUNT(*) FROM dim_customers;

SELECT COUNT(DISTINCT customer_unique_id) FROM customers;

SELECT customer_unique_id, COUNT(*)
FROM dim_customers
GROUP BY customer_unique_id
HAVING COUNT(*) > 1;