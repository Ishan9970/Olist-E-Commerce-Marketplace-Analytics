-- Fix empty strings
UPDATE orders
SET order_delivered_carrier_date = NULL
WHERE order_delivered_carrier_date = '';

UPDATE orders
SET order_delivered_customer_date = NULL
WHERE order_delivered_customer_date = '';

UPDATE orders
SET order_approved_at = NULL
WHERE order_approved_at = '';

-- Convert data types
ALTER TABLE orders
MODIFY order_purchase_timestamp DATETIME,
MODIFY order_approved_at DATETIME,
MODIFY order_delivered_carrier_date DATETIME,
MODIFY order_delivered_customer_date DATETIME,
MODIFY order_estimated_delivery_date DATETIME;

-- Validate after cleaning
SELECT *
FROM orders
WHERE order_delivered_customer_date < order_delivered_carrier_date
LIMIT 10;
