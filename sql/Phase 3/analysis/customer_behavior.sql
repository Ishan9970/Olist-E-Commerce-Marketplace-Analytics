-- =========================================================
-- PHASE 3 - FILE 5: customer_behavior.sql
-- =========================================================

USE olist;

-- =========================================================
-- STEP 1: CUSTOMER ORDERS BASE
-- =========================================================

WITH customer_orders AS (
    SELECT
        dc.customer_unique_id,
        fo.order_id,
        fo.order_purchase_timestamp
    FROM fact_orders fo

    JOIN customers c
        ON fo.customer_id = c.customer_id

    JOIN dim_customers dc
        ON c.customer_unique_id = dc.customer_unique_id

    WHERE fo.order_purchase_timestamp IS NOT NULL
),

-- =========================================================
-- STEP 2: ORDER SEQUENCING (FOR TIME BETWEEN ORDERS)
-- =========================================================

ordered_events AS (
    SELECT
        customer_unique_id,
        order_id,
        order_purchase_timestamp,

        LAG(order_purchase_timestamp) OVER (
            PARTITION BY customer_unique_id
            ORDER BY order_purchase_timestamp
        ) AS prev_order_date
    FROM customer_orders
),

-- =========================================================
-- STEP 3: TIME BETWEEN ORDERS
-- =========================================================

time_diff AS (
    SELECT
        customer_unique_id,
        DATEDIFF(order_purchase_timestamp, prev_order_date) AS days_between_orders
    FROM ordered_events
    WHERE prev_order_date IS NOT NULL
),

-- =========================================================
-- STEP 4: ORDER COUNT PER CUSTOMER
-- =========================================================

order_counts AS (
    SELECT
        customer_unique_id,
        COUNT(DISTINCT order_id) AS total_orders
    FROM customer_orders
    GROUP BY customer_unique_id
)

-- =========================================================
-- 1. REPEAT VS ONE-TIME USERS
-- =========================================================

SELECT
    CASE
        WHEN total_orders = 1 THEN 'one_time'
        ELSE 'repeat'
    END AS customer_type,
    COUNT(*) AS customer_count
FROM order_counts
GROUP BY customer_type;



-- =========================================================
-- 2. AVERAGE TIME BETWEEN ORDERS
-- =========================================================

WITH customer_orders AS (
    SELECT
        dc.customer_unique_id,
        fo.order_id,
        fo.order_purchase_timestamp
    FROM fact_orders fo
    JOIN customers c
        ON fo.customer_id = c.customer_id
    JOIN dim_customers dc
        ON c.customer_unique_id = dc.customer_unique_id
    WHERE fo.order_purchase_timestamp IS NOT NULL
),

ordered_events AS (
    SELECT
        customer_unique_id,
        order_purchase_timestamp,
        LAG(order_purchase_timestamp) OVER (
            PARTITION BY customer_unique_id
            ORDER BY order_purchase_timestamp
        ) AS prev_order_date
    FROM customer_orders
),

time_diff AS (
    SELECT
        DATEDIFF(order_purchase_timestamp, prev_order_date) AS days_between_orders
    FROM ordered_events
    WHERE prev_order_date IS NOT NULL
)

SELECT
    ROUND(AVG(days_between_orders), 2) AS avg_days_between_orders
FROM time_diff;



-- =========================================================
-- 3. PURCHASE FREQUENCY DISTRIBUTION
-- =========================================================

WITH customer_orders AS (
    SELECT
        dc.customer_unique_id,
        fo.order_id
    FROM fact_orders fo
    JOIN customers c
        ON fo.customer_id = c.customer_id
    JOIN dim_customers dc
        ON c.customer_unique_id = dc.customer_unique_id
),

order_counts AS (
    SELECT
        customer_unique_id,
        COUNT(DISTINCT order_id) AS total_orders
    FROM customer_orders
    GROUP BY customer_unique_id
)

SELECT
    CASE
        WHEN total_orders = 1 THEN '1_order'
        WHEN total_orders BETWEEN 2 AND 5 THEN '2_to_5_orders'
        ELSE '5_plus_orders'
    END AS order_bucket,
    COUNT(*) AS customer_count
FROM order_counts
GROUP BY order_bucket
ORDER BY customer_count DESC;