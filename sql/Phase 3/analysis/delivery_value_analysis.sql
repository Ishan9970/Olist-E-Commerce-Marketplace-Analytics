-- =========================================================
-- Delivery time vs order value + % comparison
-- =========================================================
use brazil;
WITH order_revenue AS (

    SELECT
        foi.order_id,
        SUM(
            COALESCE(foi.price, 0) +
            COALESCE(foi.freight_value, 0)
        ) AS order_value
    FROM fact_order_items foi
    GROUP BY foi.order_id

),

order_data AS (

    SELECT
        fo.order_id,
        fo.delivery_time,
        orv.order_value
    FROM fact_orders fo
    JOIN order_revenue orv
        ON fo.order_id = orv.order_id
    WHERE fo.order_status = 'delivered'
      AND fo.delivery_time IS NOT NULL

),

segmented AS (

    SELECT
        CASE
            WHEN order_value < 50 THEN 'low_value'
            WHEN order_value BETWEEN 50 AND 200 THEN 'medium_value'
            ELSE 'high_value'
        END AS value_segment,
        delivery_time
    FROM order_data

),

aggregated AS (

    SELECT
        value_segment,
        AVG(delivery_time) AS avg_delivery_time
    FROM segmented
    GROUP BY value_segment

),

pivoted AS (

    SELECT
        MAX(CASE WHEN value_segment = 'low_value' THEN avg_delivery_time END) AS low_delivery,
        MAX(CASE WHEN value_segment = 'medium_value' THEN avg_delivery_time END) AS medium_delivery,
        MAX(CASE WHEN value_segment = 'high_value' THEN avg_delivery_time END) AS high_delivery
    FROM aggregated

)

SELECT
    'low_value' AS value_segment,
    low_delivery AS avg_delivery_time,
    0 AS comparison_metric
FROM pivoted

UNION ALL

SELECT
    'medium_value',
    medium_delivery,
    ROUND((medium_delivery - low_delivery) * 100.0 / low_delivery, 2)
FROM pivoted

UNION ALL

SELECT
    'high_value',
    high_delivery,
    ROUND((high_delivery - low_delivery) * 100.0 / low_delivery, 2)
FROM pivoted;