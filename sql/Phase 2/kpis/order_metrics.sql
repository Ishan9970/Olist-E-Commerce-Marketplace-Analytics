-- Total Orders
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM fact_orders;

-- Completion Rate
SELECT SUM(is_delivered) / COUNT(*) AS completion_rate
FROM fact_orders;

-- Cancellation Rate
SELECT SUM(is_cancelled) / COUNT(*) AS cancellation_rate
FROM fact_orders;
