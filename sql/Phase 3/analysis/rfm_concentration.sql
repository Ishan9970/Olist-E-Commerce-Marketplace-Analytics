-- =========================================================
--  Revenue concentration across customer percentiles
-- =========================================================

WITH order_base AS (

    SELECT
        fo.order_id,
        dc.customer_unique_id
    FROM fact_orders fo
    JOIN dim_customers dc
        ON fo.customer_id = dc.customer_id
    WHERE fo.order_status = 'delivered'

),

order_revenue AS (

    SELECT
        foi.order_id,
        SUM(
            COALESCE(foi.price, 0) +
            COALESCE(foi.freight_value, 0)
        ) AS order_value
    FROM fact_order_items foi
    GROUP BY foi.order_id

),

customer_revenue AS (

    SELECT
        ob.customer_unique_id,
        SUM(orv.order_value) AS total_revenue
    FROM order_base ob
    JOIN order_revenue orv
        ON ob.order_id = orv.order_id
    GROUP BY ob.customer_unique_id

),

ranked_customers AS (

    SELECT
        cr.*,
        NTILE(100) OVER (ORDER BY cr.total_revenue DESC) AS percentile_rank
    FROM customer_revenue cr

),

grouped AS (

    SELECT
        CASE
            WHEN percentile_rank <= 10 THEN 'Top 10%'
            WHEN percentile_rank > 10 AND percentile_rank <= 20 THEN 'Next 10%'
            ELSE 'Remaining 80%'
        END AS percentile_group,
        total_revenue
    FROM ranked_customers

)

SELECT
    percentile_group,
    COUNT(*) AS total_customers,
    SUM(total_revenue) AS total_revenue,
    ROUND(
        SUM(total_revenue) * 100.0 /
        SUM(SUM(total_revenue)) OVER (),
        2
    ) AS revenue_percentage
FROM grouped
GROUP BY percentile_group
ORDER BY
    CASE
        WHEN percentile_group = 'Top 10%' THEN 1
        WHEN percentile_group = 'Next 10%' THEN 2
        ELSE 3
    END;