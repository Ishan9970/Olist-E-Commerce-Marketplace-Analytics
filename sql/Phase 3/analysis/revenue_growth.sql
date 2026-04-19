-- =========================================================
-- Monthly revenue and MoM growth
-- =========================================================
use brazil;
WITH monthly_revenue AS (

    SELECT
        DATE_FORMAT(fo.order_purchase_timestamp, '%Y-%m') AS month,

        SUM(
            COALESCE(foi.price, 0) +
            COALESCE(foi.freight_value, 0)
        ) AS revenue

    FROM fact_orders fo
    JOIN fact_order_items foi
        ON fo.order_id = foi.order_id

    WHERE fo.order_status = 'delivered'
      AND fo.order_purchase_timestamp IS NOT NULL

    GROUP BY DATE_FORMAT(fo.order_purchase_timestamp, '%Y-%m')

),

growth_calc AS (

    SELECT
        month,
        revenue,

        LAG(revenue) OVER (ORDER BY month) AS prev_revenue

    FROM monthly_revenue

)

SELECT
    month,
    revenue,

    ROUND(
        (revenue - prev_revenue) * 100.0 / prev_revenue,
        2
    ) AS growth_percentage

FROM growth_calc
ORDER BY month;