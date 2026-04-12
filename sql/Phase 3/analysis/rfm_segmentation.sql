-- ============================================
-- STEP 1: Validate joins & revenue aggregation
-- ============================================
use brazil;
SELECT
    fo.customer_id,
    COUNT(DISTINCT fo.order_id) AS total_orders,
    SUM(
        COALESCE(foi.price, 0) +
        COALESCE(foi.freight_value, 0)
    ) AS total_revenue
FROM fact_orders fo
LEFT JOIN fact_order_items foi
    ON fo.order_id = foi.order_id
WHERE fo.order_status = 'delivered'
GROUP BY fo.customer_id
LIMIT 20;


-- ============================================
-- STEP 2: Build base RFM metrics (no scoring)
-- ============================================

WITH order_base AS (

    SELECT
        fo.order_id,
        dc.customer_unique_id,
        fo.order_purchase_timestamp
    FROM fact_orders fo
    JOIN dim_customers dc
        ON fo.customer_id = dc.customer_id
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

),

customer_rfm_base AS (

    SELECT
        ob.customer_unique_id,

        -- Recency
        DATEDIFF(
            (SELECT MAX(order_purchase_timestamp) FROM fact_orders),
            MAX(ob.order_purchase_timestamp)
        ) AS recency_days,

        -- Frequency (NOW FIXED)
        COUNT(DISTINCT ob.order_id) AS frequency,

        -- Monetary (NOW FIXED)
        SUM(orv.order_revenue) AS monetary_value

    FROM order_base ob
    LEFT JOIN order_revenue orv
        ON ob.order_id = orv.order_id
    GROUP BY ob.customer_unique_id

)

SELECT *
FROM customer_rfm_base
LIMIT 20;





-- ============================================
-- STEP 3: Add RFM scoring (NTILE)
-- ============================================

WITH order_base AS (

    SELECT
        fo.order_id,
        dc.customer_unique_id,
        fo.order_purchase_timestamp
    FROM fact_orders fo
    JOIN dim_customers dc
        ON fo.customer_id = dc.customer_id
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

),

customer_metrics AS (

    SELECT
        ob.customer_unique_id,

        DATEDIFF(
            (SELECT MAX(order_purchase_timestamp) FROM fact_orders),
            MAX(ob.order_purchase_timestamp)
        ) AS recency_days,

        COUNT(DISTINCT ob.order_id) AS frequency,

        SUM(orv.order_revenue) AS monetary_value

    FROM order_base ob
    LEFT JOIN order_revenue orv
        ON ob.order_id = orv.order_id
    GROUP BY ob.customer_unique_id

),

rfm_scores AS (

    SELECT
        cm.*,

        NTILE(5) OVER (ORDER BY cm.recency_days DESC) AS r_score,

        -- FIXED FREQUENCY SCORING
        CASE
            WHEN cm.frequency = 1 THEN 1
            WHEN cm.frequency = 2 THEN 3
            ELSE 5
        END AS f_score,

        NTILE(5) OVER (ORDER BY cm.monetary_value ASC) AS m_score

    FROM customer_metrics cm

)

SELECT *
FROM rfm_scores
LIMIT 20;

-- ============================================
-- STEP 4: Final RFM segmentation
-- ============================================

-- =========================================================
-- FINAL FIX 3: RFM segmentation (correct grain + scoring)
-- =========================================================

WITH order_base AS (

    SELECT
        fo.order_id,
        dc.customer_unique_id,
        fo.order_purchase_timestamp
    FROM fact_orders fo
    JOIN dim_customers dc
        ON fo.customer_id = dc.customer_id
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

),

customer_metrics AS (

    SELECT
        ob.customer_unique_id,

        DATEDIFF(
            (SELECT MAX(order_purchase_timestamp) FROM fact_orders),
            MAX(ob.order_purchase_timestamp)
        ) AS recency_days,

        COUNT(DISTINCT ob.order_id) AS frequency,

        SUM(orv.order_revenue) AS monetary_value

    FROM order_base ob
    LEFT JOIN order_revenue orv
        ON ob.order_id = orv.order_id
    GROUP BY ob.customer_unique_id

),

rfm_scores AS (

    SELECT
        cm.*,

        NTILE(5) OVER (ORDER BY cm.recency_days DESC) AS r_score,

        CASE
            WHEN cm.frequency = 1 THEN 1
            WHEN cm.frequency = 2 THEN 3
            ELSE 5
        END AS f_score,

        NTILE(5) OVER (ORDER BY cm.monetary_value ASC) AS m_score

    FROM customer_metrics cm

),

rfm_segments AS (

    SELECT
        rs.*,

        CASE
            WHEN r_score >= 4 AND m_score >= 4
                THEN 'Champions'

            WHEN r_score >= 3 AND m_score >= 3
                THEN 'Loyal Customers'

            WHEN r_score <= 2 AND m_score >= 3
                THEN 'At Risk'

            WHEN r_score = 1 AND m_score <= 2
                THEN 'Lost Customers'

            ELSE 'Others'
        END AS rfm_segment

    FROM rfm_scores rs

)

SELECT
    rfm_segment,
    COUNT(*) AS customer_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM rfm_segments
GROUP BY rfm_segment
ORDER BY customer_count DESC;
