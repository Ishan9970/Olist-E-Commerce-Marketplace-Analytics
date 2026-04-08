USE olist;

-- Recreate orders table with correct datatypes
DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    order_id VARCHAR(50),
    customer_id VARCHAR(50),
    order_status VARCHAR(20),

    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME
);

SET GLOBAL local_infile = 1;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_orders_dataset.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    order_id,
    customer_id,
    order_status,
    @order_purchase_timestamp,
    @order_approved_at,
    @order_delivered_carrier_date,
    @order_delivered_customer_date,
    @order_estimated_delivery_date
)
SET
    order_purchase_timestamp = NULLIF(@order_purchase_timestamp, ''),
    order_approved_at = NULLIF(@order_approved_at, ''),
    order_delivered_carrier_date = NULLIF(@order_delivered_carrier_date, ''),
    order_delivered_customer_date = NULLIF(@order_delivered_customer_date, ''),
    order_estimated_delivery_date = NULLIF(@order_estimated_delivery_date, '');

-- Create dim_date
CREATE TABLE dim_date AS
WITH RECURSIVE date_series AS (
    SELECT DATE(
        (SELECT MIN(order_purchase_timestamp) FROM orders)
    ) AS dt

    UNION ALL

    SELECT DATE_ADD(dt, INTERVAL 1 DAY)
    FROM date_series
    WHERE dt < (
        SELECT DATE(MAX(order_purchase_timestamp)) FROM orders
    )
)

SELECT
    ROW_NUMBER() OVER () AS date_key,
    dt AS date,
    YEAR(dt) AS year,
    MONTH(dt) AS month,
    MONTHNAME(dt) AS month_name,
    DAY(dt) AS day,
    DAYNAME(dt) AS day_of_week,
    QUARTER(dt) AS quarter
FROM date_series;

-- Validation
SELECT COUNT(*) FROM dim_date;

SELECT date, COUNT(*)
FROM dim_date
GROUP BY date
HAVING COUNT(*) > 1;