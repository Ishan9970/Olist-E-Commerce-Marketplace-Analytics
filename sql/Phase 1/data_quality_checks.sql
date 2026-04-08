-- Duplicate orders
SELECT order_id, COUNT(*)
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

-- Invalid lifecycle checks
SELECT *
FROM orders
WHERE order_approved_at < order_purchase_timestamp
   OR order_delivered_carrier_date < order_approved_at
   OR order_delivered_customer_date < order_delivered_carrier_date;

-- Count inconsistencies
SELECT 
    SUM(order_approved_at < order_purchase_timestamp),
    SUM(order_delivered_carrier_date < order_approved_at),
    SUM(order_delivered_customer_date < order_delivered_carrier_date)
FROM orders;
