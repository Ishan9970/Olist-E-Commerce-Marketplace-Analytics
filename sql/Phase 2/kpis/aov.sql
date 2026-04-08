SELECT 
    SUM(total_item_value) / COUNT(DISTINCT order_id) AS AOV
FROM fact_order_items;
