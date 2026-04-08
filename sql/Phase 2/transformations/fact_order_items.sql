USE brazil;

-- STEP 2.1 — Grain Check
SELECT 
    COUNT(DISTINCT order_id) AS unique_orders,
    COUNT(*) AS total_items
FROM order_items;

-- STEP 2.2 — Build fact_order_items
DROP TABLE IF EXISTS fact_order_items;

CREATE TABLE fact_order_items AS
SELECT
    oi.order_id,
    oi.order_item_id,
    oi.product_id,
    oi.seller_id,
    fo.customer_id,
    oi.shipping_limit_date,

    oi.price,
    oi.freight_value,
    (oi.price + oi.freight_value) AS total_item_value,

    fo.order_purchase_timestamp,
    fo.order_delivered_customer_date,
    fo.order_status,

    fo.is_delivered,
    fo.is_cancelled,
    fo.is_post_delivery_cancel,

    fo.delivery_time,
    fo.total_fulfillment_time

FROM order_items oi
INNER JOIN fact_orders fo
    ON oi.order_id = fo.order_id;

-- Validation
SELECT COUNT(*) FROM fact_order_items;

SELECT 
    SUM(price) AS total_price,
    SUM(freight_value) AS total_freight,
    SUM(total_item_value) AS total_revenue
FROM fact_order_items;
