-- ============================================
-- STEP 1: Base delivery metrics validation
-- ============================================
use brazil;
SELECT
    fo.order_id,
    fo.customer_id,
    fo.delivery_time
FROM fact_orders fo
WHERE fo.delivery_time IS NOT NULL
LIMIT 20;

-- ============================================
-- STEP 2: Average delivery time by state
-- ============================================

SELECT
    dc.customer_state,
    COUNT(*) AS total_orders,
    AVG(fo.delivery_time) AS avg_delivery_time
FROM fact_orders fo
JOIN dim_customers dc
    ON fo.customer_id = dc.customer_id
WHERE fo.delivery_time IS NOT NULL
GROUP BY dc.customer_state
ORDER BY avg_delivery_time DESC;

-- ============================================
-- STEP 3: Seller-level delivery performance
-- ============================================

SELECT
    foi.seller_id,
    COUNT(DISTINCT fo.order_id) AS total_orders,
    AVG(fo.delivery_time) AS avg_delivery_time
FROM fact_order_items foi
JOIN fact_orders fo
    ON foi.order_id = fo.order_id
WHERE fo.delivery_time IS NOT NULL
GROUP BY foi.seller_id
HAVING COUNT(DISTINCT fo.order_id) >= 50
ORDER BY avg_delivery_time DESC
LIMIT 20;

-- ============================================
-- STEP 4: Late delivery rate
-- ============================================

SELECT
    COUNT(*) AS total_delivered_orders,

    SUM(
        CASE
            WHEN fo.order_delivered_customer_date > fo.order_estimated_delivery_date
            THEN 1 ELSE 0
        END
    ) AS late_deliveries,

    ROUND(
        SUM(
            CASE
                WHEN fo.order_delivered_customer_date > fo.order_estimated_delivery_date
                THEN 1 ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS late_delivery_rate_percent

FROM fact_orders fo
WHERE fo.order_delivered_customer_date IS NOT NULL
  AND fo.order_estimated_delivery_date IS NOT NULL;
  
