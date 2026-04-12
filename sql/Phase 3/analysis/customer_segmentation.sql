use brazil;

-- ============================================
-- STEP 1: Customer metrics (base layer)
-- ============================================

WITH order_base AS (

    SELECT
        fo.order_id,
        dc.customer_unique_id
    FROM fact_orders fo
    JOIN dim_customers dc
        ON fo.customer_id = dc.customer_id

),

order_revenue AS (

    SELECT
        foi.order_id,
        SUM(
            COALESCE(foi.price, 0) +
            COALESCE(foi.freight_value, 0)
        ) AS order_revenue
    FROM fact_order_items foi
    GROUP BY foi.order_id

),

customer_metrics AS (

    SELECT
        ob.customer_unique_id,

        COUNT(DISTINCT ob.order_id) AS total_orders,

        SUM(orv.order_revenue) AS total_spend,

        SUM(orv.order_revenue) / COUNT(DISTINCT ob.order_id) AS avg_order_value

    FROM order_base ob
    LEFT JOIN order_revenue orv
        ON ob.order_id = orv.order_id
    GROUP BY ob.customer_unique_id

)

SELECT *
FROM customer_metrics
LIMIT 20;

-- ============================================
-- STEP 2: Add customer order buckets
-- ============================================

WITH order_base AS (

    SELECT
        fo.order_id,
        dc.customer_unique_id
    FROM fact_orders fo
    JOIN dim_customers dc
        ON fo.customer_id = dc.customer_id

),

order_revenue AS (

    SELECT
        foi.order_id,
        SUM(
            COALESCE(foi.price, 0) +
            COALESCE(foi.freight_value, 0)
        ) AS order_revenue
    FROM fact_order_items foi
    GROUP BY foi.order_id

),

customer_metrics AS (

    SELECT
        ob.customer_unique_id,

        COUNT(DISTINCT ob.order_id) AS total_orders,

        SUM(orv.order_revenue) AS total_spend,

        SUM(orv.order_revenue) / COUNT(DISTINCT ob.order_id) AS avg_order_value

    FROM order_base ob
    LEFT JOIN order_revenue orv
        ON ob.order_id = orv.order_id
    GROUP BY ob.customer_unique_id

),
customer_segments AS (

    SELECT
        cm.*,

        CASE
            WHEN total_orders = 1 THEN '1_order'
            WHEN total_orders BETWEEN 2 AND 5 THEN '2_5_orders'
            ELSE '5+_orders'
        END AS order_bucket

    FROM customer_metrics cm

)
-- Building Distribution Table
SELECT
    order_bucket,
    COUNT(*) AS customer_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage,
    AVG(total_spend) AS avg_customer_spend,
    AVG(avg_order_value) AS avg_order_value
FROM customer_segments
GROUP BY order_bucket
ORDER BY customer_count DESC;



