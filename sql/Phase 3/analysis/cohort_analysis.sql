-- =========================================================
-- PHASE 3 - FILE 1: cohort_analysis.sql (FINAL CORRECTED)
-- =========================================================

WITH customer_orders AS (
    SELECT
        dc.customer_unique_id,
        fo.order_id,
        fo.order_purchase_timestamp
    FROM fact_orders fo

    -- Map order → customer_id → customer_unique_id
    JOIN customers c
        ON fo.customer_id = c.customer_id

    JOIN dim_customers dc
        ON c.customer_unique_id = dc.customer_unique_id

    WHERE fo.order_purchase_timestamp IS NOT NULL
),

first_purchase AS (
    SELECT
        customer_unique_id,
        MIN(order_purchase_timestamp) AS first_purchase_date
    FROM customer_orders
    GROUP BY customer_unique_id
),

cohort_mapping AS (
    SELECT
        customer_unique_id,
        DATE(DATE_FORMAT(first_purchase_date, '%Y-%m-01')) AS cohort_month
    FROM first_purchase
),

customer_activity AS (
    SELECT
        co.customer_unique_id,
        cm.cohort_month,
        DATE(DATE_FORMAT(co.order_purchase_timestamp, '%Y-%m-01')) AS activity_month
    FROM customer_orders co
    JOIN cohort_mapping cm
        ON co.customer_unique_id = cm.customer_unique_id
),

cohort_data AS (
    SELECT
        cohort_month,
        activity_month,
        TIMESTAMPDIFF(MONTH, cohort_month, activity_month) AS months_since_signup,
        customer_unique_id
    FROM customer_activity
)

SELECT
    cohort_month,
    months_since_signup,
    COUNT(DISTINCT customer_unique_id) AS active_users
FROM cohort_data
GROUP BY
    cohort_month,
    months_since_signup
ORDER BY
    cohort_month,
    months_since_signup;