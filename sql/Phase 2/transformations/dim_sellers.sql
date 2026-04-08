USE olist;

TRUNCATE TABLE sellers;

SET GLOBAL local_infile = 1;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_sellers_dataset.csv'
INTO TABLE sellers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Validate uniqueness
SELECT seller_id, COUNT(*) 
FROM sellers
GROUP BY seller_id
HAVING COUNT(*) > 1;

-- Build dim_sellers
CREATE TABLE dim_sellers AS
SELECT
    ROW_NUMBER() OVER () AS seller_key,
    seller_id,
    seller_zip_code_prefix AS zip_code,
    LOWER(TRIM(seller_city)) AS city,
    UPPER(TRIM(seller_state)) AS state
FROM sellers
WHERE seller_id IS NOT NULL;

-- Validation
SELECT COUNT(*) FROM dim_sellers;

SELECT seller_id, COUNT(*) 
FROM dim_sellers
GROUP BY seller_id
HAVING COUNT(*) > 1;