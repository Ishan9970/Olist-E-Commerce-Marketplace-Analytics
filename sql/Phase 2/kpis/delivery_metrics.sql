SELECT 
    AVG(delivery_time) AS avg_delivery_time
FROM fact_orders
WHERE delivery_time IS NOT NULL;
