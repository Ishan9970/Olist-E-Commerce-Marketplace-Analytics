USE brazil;

-- STEP 1.1 — Check Base Data
SELECT COUNT(*) AS total_orders FROM orders;

SELECT COUNT(*) AS null_purchase_ts
FROM orders
WHERE order_purchase_timestamp IS NULL;

-- STEP 1.2 — Detect Invalid Lifecycle
SELECT COUNT(*) AS invalid_delivery_sequence
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_delivered_carrier_date IS NOT NULL
  AND order_delivered_customer_date < order_delivered_carrier_date;

-- STEP 1.3 — Build Filtered Base
DROP TABLE IF EXISTS fact_orders_base;

CREATE TABLE fact_orders_base AS
SELECT *
FROM orders
WHERE NOT (
    order_delivered_customer_date IS NOT NULL
    AND order_delivered_carrier_date IS NOT NULL
    AND order_delivered_customer_date < order_delivered_carrier_date
);

-- STEP 1.4 — Final fact_orders Table
DROP TABLE IF EXISTS fact_orders;

CREATE TABLE fact_orders AS
SELECT
    order_id,
    customer_id,
    order_status,

    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date,

    -- FLAGS
    CASE WHEN order_status = 'delivered' THEN 1 ELSE 0 END AS is_delivered,
    CASE WHEN order_status = 'canceled' THEN 1 ELSE 0 END AS is_cancelled,

    CASE 
        WHEN order_status = 'canceled' 
         AND order_delivered_customer_date IS NOT NULL
        THEN 1 ELSE 0 
    END AS is_post_delivery_cancel,

    -- DURATIONS
    CASE 
        WHEN order_purchase_timestamp IS NOT NULL 
         AND order_approved_at IS NOT NULL
        THEN DATEDIFF(order_approved_at, order_purchase_timestamp)
    END AS processing_time,

    CASE 
        WHEN order_approved_at IS NOT NULL 
         AND order_delivered_carrier_date IS NOT NULL
        THEN DATEDIFF(order_delivered_carrier_date, order_approved_at)
    END AS shipping_time,

    CASE 
        WHEN order_delivered_carrier_date IS NOT NULL 
         AND order_delivered_customer_date IS NOT NULL
        THEN DATEDIFF(order_delivered_customer_date, order_delivered_carrier_date)
    END AS delivery_time,

    CASE 
        WHEN order_purchase_timestamp IS NOT NULL 
         AND order_delivered_customer_date IS NOT NULL
        THEN DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)
    END AS total_fulfillment_time,

    -- OUTLIER FLAG
    CASE 
        WHEN order_delivered_carrier_date IS NOT NULL
         AND order_delivered_customer_date IS NOT NULL
         AND DATEDIFF(order_delivered_customer_date, order_delivered_carrier_date) > 60
        THEN 1 ELSE 0 
    END AS is_delivery_outlier

FROM fact_orders_base;

-- Validation
SELECT COUNT(*) FROM fact_orders;

SELECT 
    is_delivery_outlier,
    COUNT(*) 
FROM fact_orders
GROUP BY is_delivery_outlier;
