use brazil;


WITH monthly_metrics AS (
    SELECT
        DATE_FORMAT(fo.order_purchase_timestamp, '%Y-%m-01') AS month,
        SUM(foi.total_item_value) AS total_revenue,
        COUNT(DISTINCT fo.order_id) AS total_orders
    FROM fact_orders fo
    INNER JOIN fact_order_items foi
        ON fo.order_id = foi.order_id
    WHERE fo.order_purchase_timestamp IS NOT NULL
    GROUP BY DATE_FORMAT(fo.order_purchase_timestamp, '%Y-%m-01')
)

SELECT
    month,
    ROUND(total_revenue, 2) AS total_revenue,
    total_orders,
    ROUND(total_revenue / NULLIF(total_orders, 0), 2) AS AOV
FROM monthly_metrics
ORDER BY month;