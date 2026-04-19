-- =========================================================
-- Customer retention (Month 1 & Month 3)
-- =========================================================

WITH order_data AS (

    SELECT
        dc.customer_unique_id,
        DATE_FORMAT(fo.order_purchase_timestamp, '%Y-%m-01') AS order_month_date
    FROM fact_orders fo
    JOIN dim_customers dc
        ON fo.customer_id = dc.customer_id
    WHERE fo.order_status = 'delivered'
      AND fo.order_purchase_timestamp IS NOT NULL

),

first_purchase AS (

    SELECT
        customer_unique_id,
        MIN(order_month_date) AS cohort_month
    FROM order_data
    GROUP BY customer_unique_id

),

customer_activity AS (

    SELECT
        fp.customer_unique_id,
        fp.cohort_month,
        od.order_month_date,

        TIMESTAMPDIFF(
            MONTH,
            STR_TO_DATE(fp.cohort_month, '%Y-%m-%d'),
            STR_TO_DATE(od.order_month_date, '%Y-%m-%d')
        ) AS month_number

    FROM first_purchase fp
    JOIN order_data od
        ON fp.customer_unique_id = od.customer_unique_id

),

cohort_size AS (

    SELECT
        cohort_month,
        COUNT(DISTINCT customer_unique_id) AS total_users
    FROM first_purchase
    GROUP BY cohort_month

),

retention AS (

    SELECT
        cohort_month,

        COUNT(DISTINCT CASE
            WHEN month_number = 1 THEN customer_unique_id
        END) AS retained_month_1,

        COUNT(DISTINCT CASE
            WHEN month_number BETWEEN 1 AND 3 THEN customer_unique_id
        END) AS retained_month_3

    FROM customer_activity
    GROUP BY cohort_month

)

SELECT
    cs.cohort_month,
    cs.total_users,

    ROUND(
        COALESCE(r.retained_month_1, 0) * 100.0 / cs.total_users,
        2
    ) AS retention_month_1,

    ROUND(
        COALESCE(r.retained_month_3, 0) * 100.0 / cs.total_users,
        2
    ) AS retention_month_3

FROM cohort_size cs
LEFT JOIN retention r
    ON cs.cohort_month = r.cohort_month
ORDER BY cs.cohort_month;