-- Delivered + canceled
SELECT *
FROM orders
WHERE order_status = 'canceled'
  AND order_delivered_customer_date IS NOT NULL;

-- Percentage
SELECT 
    order_status,
    COUNT(*) AS total,
    ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM orders), 2) AS percentage
FROM orders
WHERE order_status = 'canceled'
  AND order_delivered_customer_date IS NOT NULL;

-- Delivery stats
SELECT 
    AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)) AS avg_delivery_days,
    MIN(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)) AS min_days,
    MAX(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)) AS max_days
FROM orders
WHERE order_status = 'canceled'
  AND order_delivered_customer_date IS NOT NULL;

-- Payment behavior
SELECT 
    payment_type,
    COUNT(*) AS total_orders,
    AVG(payment_value) AS avg_value
FROM payments
WHERE order_id IN (
    SELECT order_id
    FROM orders
    WHERE order_status = 'canceled'
      AND order_delivered_customer_date IS NOT NULL
)
GROUP BY payment_type;
