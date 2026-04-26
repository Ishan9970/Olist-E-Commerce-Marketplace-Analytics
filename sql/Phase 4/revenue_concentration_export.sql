use brazil;

WITH customer_revenue AS (
    SELECT
        fo.customer_id,
        SUM(foi.total_item_value) AS revenue
    FROM fact_orders fo
    JOIN fact_order_items foi
        ON fo.order_id = foi.order_id
    GROUP BY fo.customer_id
),

ranked AS (
    SELECT
        revenue,
        NTILE(100) OVER (ORDER BY revenue DESC) AS percentile
    FROM customer_revenue
),

percentile_agg AS (
    SELECT
        percentile,
        SUM(revenue) AS percentile_revenue
    FROM ranked
    GROUP BY percentile
),

final AS (
    SELECT
        percentile,
        percentile_revenue,
        SUM(percentile_revenue) OVER () AS total_revenue,
        SUM(percentile_revenue) OVER (
            ORDER BY percentile
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_revenue
    FROM percentile_agg
)

SELECT
    percentile,
    ROUND(cumulative_revenue / total_revenue, 4) AS cumulative_revenue_pct,
    ROUND(percentile_revenue / total_revenue, 4) AS revenue_share
FROM final
ORDER BY percentile;

