use brazil;
WITH revenue AS (
    SELECT
        SUM(total_item_value) AS total_revenue
    FROM fact_order_items
),

orders AS (
    SELECT
        COUNT(*) AS total_orders,
        SUM(is_delivered) AS delivered_orders,
        SUM(is_cancelled) AS cancelled_orders
    FROM fact_orders
)

SELECT
    ROUND(r.total_revenue, 2) AS total_revenue,
    o.total_orders,
    ROUND(r.total_revenue / o.total_orders, 2) AS AOV,
    ROUND(o.delivered_orders / o.total_orders, 4) AS completion_rate,
    ROUND(o.cancelled_orders / o.total_orders, 4) AS cancellation_rate
FROM revenue r
CROSS JOIN orders o;


