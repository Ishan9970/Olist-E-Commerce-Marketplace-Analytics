-- ============================================
-- STEP 1: Monthly revenue base validation
-- ============================================

WITH order_base AS (

    SELECT
        fo.order_id,
        fo.order_purchase_timestamp
    FROM fact_orders fo
    WHERE fo.order_status = 'delivered'
      AND fo.order_purchase_timestamp IS NOT NULL

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

)

SELECT
    DATE_FORMAT(ob.order_purchase_timestamp, '%Y-%m') AS order_month,
    COUNT(DISTINCT ob.order_id) AS total_orders,
    SUM(orv.order_revenue) AS total_revenue
FROM order_base ob
LEFT JOIN order_revenue orv
    ON ob.order_id = orv.order_id
GROUP BY order_month
ORDER BY order_month;

-- ============================================
-- STEP 2: Monthly revenue + AOV
-- ============================================

WITH order_base AS (

    SELECT
        fo.order_id,
        fo.order_purchase_timestamp
    FROM fact_orders fo
    WHERE fo.order_status = 'delivered'
      AND fo.order_purchase_timestamp IS NOT NULL

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

)

SELECT
    DATE_FORMAT(ob.order_purchase_timestamp, '%Y-%m') AS order_month,

    COUNT(DISTINCT ob.order_id) AS total_orders,

    SUM(orv.order_revenue) AS total_revenue,

    SUM(orv.order_revenue) / COUNT(DISTINCT ob.order_id) AS avg_order_value

FROM order_base ob
LEFT JOIN order_revenue orv
    ON ob.order_id = orv.order_id
GROUP BY order_month
ORDER BY order_month;