-- =========================================================
-- PHASE 3 - FILE 4: product_performance.sql (FINAL)
-- =========================================================

USE olist;

-- =========================================================
-- 1. TOP CATEGORIES BY REVENUE
-- =========================================================

WITH base_data AS (
    SELECT
        oi.order_id,
        oi.product_id,
        (oi.price + oi.freight_value) AS revenue,
        fo.order_purchase_timestamp,
        DATE(DATE_FORMAT(fo.order_purchase_timestamp, '%Y-%m-01')) AS order_month
    FROM order_items oi
    JOIN fact_orders fo
        ON oi.order_id = fo.order_id
),

product_category AS (
    SELECT
        p.product_id,
        COALESCE(p.product_category_name, 'unknown') AS category
    FROM products p
),

final_data AS (
    SELECT
        bd.order_id,
        bd.revenue,
        bd.order_month,
        pc.category
    FROM base_data bd
    JOIN product_category pc
        ON bd.product_id = pc.product_id
)

SELECT
    category,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM final_data
GROUP BY category
ORDER BY total_revenue DESC;



-- =========================================================
-- 2. CATEGORY GROWTH (MONTHLY)
-- =========================================================

WITH base_data AS (
    SELECT
        oi.order_id,
        oi.product_id,
        (oi.price + oi.freight_value) AS revenue,
        fo.order_purchase_timestamp,
        DATE(DATE_FORMAT(fo.order_purchase_timestamp, '%Y-%m-01')) AS order_month
    FROM order_items oi
    JOIN fact_orders fo
        ON oi.order_id = fo.order_id
),

product_category AS (
    SELECT
        p.product_id,
        COALESCE(p.product_category_name, 'unknown') AS category
    FROM products p
),

final_data AS (
    SELECT
        bd.order_id,
        bd.revenue,
        bd.order_month,
        pc.category
    FROM base_data bd
    JOIN product_category pc
        ON bd.product_id = pc.product_id
)

SELECT
    category,
    order_month,
    ROUND(SUM(revenue), 2) AS monthly_revenue
FROM final_data
GROUP BY category, order_month
ORDER BY category, order_month;



-- =========================================================
-- 3. AVERAGE ORDER VALUE (AOV) BY CATEGORY
-- =========================================================

WITH base_data AS (
    SELECT
        oi.order_id,
        oi.product_id,
        (oi.price + oi.freight_value) AS revenue,
        fo.order_purchase_timestamp,
        DATE(DATE_FORMAT(fo.order_purchase_timestamp, '%Y-%m-01')) AS order_month
    FROM order_items oi
    JOIN fact_orders fo
        ON oi.order_id = fo.order_id
),

product_category AS (
    SELECT
        p.product_id,
        COALESCE(p.product_category_name, 'unknown') AS category
    FROM products p
),

final_data AS (
    SELECT
        bd.order_id,
        bd.revenue,
        bd.order_month,
        pc.category
    FROM base_data bd
    JOIN product_category pc
        ON bd.product_id = pc.product_id
)

SELECT
    category,
    ROUND(SUM(revenue) / COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM final_data
GROUP BY category
ORDER BY avg_order_value DESC;