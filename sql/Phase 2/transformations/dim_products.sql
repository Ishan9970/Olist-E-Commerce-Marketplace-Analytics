USE olist;

TRUNCATE TABLE products;

SET GLOBAL local_infile = 1;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_products_dataset.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    product_id,
    product_category_name,
    @product_name_lenght,
    @product_description_lenght,
    @product_photos_qty,
    @product_weight_g,
    @product_length_cm,
    @product_height_cm,
    @product_width_cm
)
SET
    product_name_lenght = NULLIF(@product_name_lenght, ''),
    product_description_lenght = NULLIF(@product_description_lenght, ''),
    product_photos_qty = NULLIF(@product_photos_qty, ''),
    product_weight_g = NULLIF(@product_weight_g, ''),
    product_length_cm = NULLIF(@product_length_cm, ''),
    product_height_cm = NULLIF(@product_height_cm, ''),
    product_width_cm = NULLIF(@product_width_cm, '');

-- Fix empty categories
SET SQL_SAFE_UPDATES = 0;

UPDATE products
SET product_category_name = NULL
WHERE product_category_name = '';

-- Build dim_products
CREATE TABLE dim_products AS
SELECT
    ROW_NUMBER() OVER () AS product_key,
    product_id,

    LOWER(
        COALESCE(NULLIF(TRIM(product_category_name), ''), 'unknown')
    ) AS product_category,

    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm,

    (product_length_cm * product_height_cm * product_width_cm) AS product_volume_cm3

FROM products
WHERE product_id IS NOT NULL;

-- Validation
SELECT COUNT(*) FROM dim_products;

SELECT product_id, COUNT(*) 
FROM dim_products
GROUP BY product_id
HAVING COUNT(*) > 1;

SELECT COUNT(*) 
FROM dim_products
WHERE product_category = 'unknown';