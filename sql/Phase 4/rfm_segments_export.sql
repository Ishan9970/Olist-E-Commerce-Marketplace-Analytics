use brazil;

WITH base AS (
    SELECT
        fo.customer_id,
        MAX(fo.order_purchase_timestamp) AS last_purchase_date,
        COUNT(DISTINCT fo.order_id) AS frequency,
        SUM(foi.total_item_value) AS monetary
    FROM fact_orders fo
    JOIN fact_order_items foi
        ON fo.order_id = foi.order_id
    WHERE fo.order_status = 'delivered'
      AND fo.order_purchase_timestamp IS NOT NULL
    GROUP BY fo.customer_id
),

reference AS (
    SELECT MAX(order_purchase_timestamp) AS reference_date
    FROM fact_orders
),

rfm AS (
    SELECT
        b.customer_id,
        DATEDIFF(r.reference_date, b.last_purchase_date) AS recency,
        b.frequency,
        b.monetary
    FROM base b
    CROSS JOIN reference r
),

scored AS (
    SELECT
        customer_id,

        NTILE(5) OVER (ORDER BY recency ASC) AS recency_score,

        CASE
            WHEN frequency = 1 THEN 1
            WHEN frequency = 2 THEN 3
            ELSE 5
        END AS frequency_score,

        NTILE(5) OVER (ORDER BY monetary DESC) AS monetary_score
    FROM rfm
)

SELECT
    customer_id,
    recency_score,
    frequency_score,
    monetary_score,
    CASE
        WHEN recency_score >= 4 AND frequency_score >= 4 AND monetary_score >= 4 THEN 'Champions'
        WHEN recency_score >= 3 AND frequency_score >= 3 THEN 'Loyal Customers'
        WHEN recency_score <= 2 AND frequency_score >= 3 THEN 'At Risk'
        WHEN recency_score = 1 THEN 'Lost Customers'
        ELSE 'Others'
    END AS segment
FROM scored;

WITH rfm_final AS (

    WITH base AS (
        SELECT
            fo.customer_id,
            MAX(fo.order_purchase_timestamp) AS last_purchase_date,
            COUNT(DISTINCT fo.order_id) AS frequency,
            SUM(foi.total_item_value) AS monetary
        FROM fact_orders fo
        JOIN fact_order_items foi
            ON fo.order_id = foi.order_id
        WHERE fo.order_status = 'delivered'
          AND fo.order_purchase_timestamp IS NOT NULL
        GROUP BY fo.customer_id
    ),

    reference AS (
        SELECT MAX(order_purchase_timestamp) AS reference_date
        FROM fact_orders
    ),

    rfm AS (
        SELECT
            b.customer_id,
            DATEDIFF(r.reference_date, b.last_purchase_date) AS recency,
            b.frequency,
            b.monetary
        FROM base b
        CROSS JOIN reference r
    ),

    scored AS (
        SELECT
            customer_id,

            NTILE(5) OVER (ORDER BY recency ASC) AS recency_score,

            CASE
                WHEN frequency = 1 THEN 1
                WHEN frequency = 2 THEN 3
                ELSE 5
            END AS frequency_score,

            NTILE(5) OVER (ORDER BY monetary DESC) AS monetary_score
        FROM rfm
    )

    SELECT
        customer_id,
        recency_score,
        frequency_score,
        monetary_score,
   CASE
    WHEN recency_score >= 4 AND monetary_score >= 4 THEN 'Champions'
    WHEN recency_score >= 3 AND monetary_score >= 3 THEN 'Loyal Customers'
    WHEN recency_score <= 2 AND monetary_score >= 3 THEN 'At Risk'
    WHEN recency_score = 1 THEN 'Lost Customers'
    ELSE 'Others'
END
    FROM scored
)

SELECT
    segment,
    COUNT(*) AS customer_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM rfm_final
GROUP BY segment
ORDER BY customer_count DESC;