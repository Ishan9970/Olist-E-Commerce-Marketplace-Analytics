# Metric Definitions — Phase 2 Foundation

## Delivery Time

Definition
The elapsed time between order shipment and final delivery to the customer.

Formula
delivery_date - carrier_date

Inclusion Criteria

* Orders with status = delivered
* Non-null shipment and delivery timestamps

Exclusion Criteria

* Records where delivery_date < carrier_date
* Missing or invalid timestamps

Reliability
Medium — dependent on logistics data accuracy and timestamp completeness

## Processing Time

Definition
The time taken to process an order from placement to payment approval.

Formula
approval_date - purchase_date

Inclusion Criteria

* Orders with valid approval timestamps

Exclusion Criteria

* Records where approval_date < purchase_date
* Missing timestamps

Reliability
High — typically system-generated and consistent

## Order Completion Rate

Definition
The proportion of total orders that are successfully delivered.

Formula
delivered_orders / total_orders

Inclusion Criteria

* All valid orders with clear status classification

Exclusion Criteria

* Orders with ambiguous or undefined statuses

Reliability
Medium — depends on accurate status labeling

## Cancellation Rate

Definition
The percentage of orders that are canceled relative to total orders.

Categories

* Pre-delivery cancellations (before shipment)
* Post-delivery cancellations (returns or refunds)

Important Consideration

* Delivered and canceled orders must be treated as mutually exclusive states in analysis

Reliability
Low — cancellation logic may vary across systems and edge cases

## Late Delivery Rate

Definition
The proportion of orders delivered after the estimated delivery date.

Formula
delivery_date > estimated_delivery_date

Inclusion Criteria

* Delivered orders with valid estimated and actual delivery timestamps

Exclusion Criteria

* Missing or inconsistent timestamps

Reliability
Medium — sensitive to estimation accuracy and data quality

## Average Order Value (AOV)

Definition
The average revenue generated per order.

Formula
SUM(order_items.price + freight_value) / total_orders

Data Source

* order_items table

Important Note

* Revenue must be aggregated at the order level before computing the average to avoid duplication bias

Reliability
High — provided joins and aggregations are correctly handled

## General Data Quality Guidelines

* All metrics must be computed on cleaned and validated datasets
* Invalid lifecycle records (e.g., reversed timestamps, missing fields) must be excluded
* Metrics should not assume strict chronological ordering across all events
* Financial metrics should be validated through reconciliation checks
