-- =========================================================
-- PHASE 3 - FILE 3: geographic_analysis.sql (FINAL CLEAN)
-- =========================================================

USE olist;

WITH order_base AS (
    SELECT
        fo.order_id,
        fo.customer_id,
        fo.delivery_time
    FROM fact_orders fo
),

customer_location AS (
    SELECT
        c.customer_id,
        dc.customer_unique_id,
        TRIM(REPLACE(dc.state, '\r', '')) AS state
    FROM customers c
    JOIN dim_customers dc
        ON c.customer_unique_id = dc.customer_unique_id
),

order_location AS (
    SELECT
        ob.order_id,
        cl.state,
        ob.delivery_time
    FROM order_base ob
    JOIN customer_location cl
        ON ob.customer_id = cl.customer_id
),

order_revenue AS (
    SELECT
        order_id,
        SUM(price + freight_value) AS order_revenue
    FROM order_items
    GROUP BY order_id
),

final_data AS (
    SELECT
        ol.state,
        ol.order_id,
        ol.delivery_time,
        orv.order_revenue
    FROM order_location ol
    LEFT JOIN order_revenue orv
        ON ol.order_id = orv.order_id
)

-- =========================================================
-- FINAL OUTPUT
-- =========================================================

SELECT
    state,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(order_revenue), 2) AS total_revenue,
    ROUND(AVG(delivery_time), 2) AS avg_delivery_time_days
FROM final_data
GROUP BY state
ORDER BY total_revenue DESC;