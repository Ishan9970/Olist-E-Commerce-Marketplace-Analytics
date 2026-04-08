USE brazil;

-- Total payments (raw)
SELECT SUM(payment_value) AS total_payments
FROM order_payments;

-- Aligned comparison
SELECT 
    (SELECT SUM(total_item_value) FROM fact_order_items) AS items_revenue,
    (SELECT SUM(payment_value)
     FROM order_payments
     WHERE order_id IN (
         SELECT DISTINCT order_id FROM fact_order_items
     )) AS payments_revenue;

-- Difference
SELECT 
    (SELECT SUM(payment_value)
     FROM order_payments
     WHERE order_id IN (
         SELECT DISTINCT order_id FROM fact_order_items
     ))
    -
    (SELECT SUM(total_item_value) FROM fact_order_items)
    AS revenue_difference;
