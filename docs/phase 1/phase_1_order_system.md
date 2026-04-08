# Order System Analysis — Phase 1 (Olist Dataset)

---

## 1. Objective
The objective of Phase 1 is to systematically understand, validate, and model the order-side data system, ensuring:
- Structural correctness  
- Lifecycle clarity  
- Readiness for downstream analytics and data warehouse design  

---

## 2. Dataset Scope

### Primary Dataset
- **orders** (fully analyzed)

### Contextual Datasets (Phase 2)
- order_items  
- order_payments  
- order_reviews  

---

## 3. System Overview

### Core Tables and Roles

| Table            | Role                          | Grain               |
|------------------|-------------------------------|---------------------|
| orders           | Order lifecycle tracking       | 1 row per order     |
| order_items      | Revenue and product data       | 1 row per item      |
| order_payments   | Payment transactions           | 1 row per payment   |
| order_reviews    | Customer feedback              | ~1 row per order    |

### Join Relationships
- orders → order_items (**1 : MANY**)  
- orders → order_payments (**1 : MANY**)  
- orders → order_reviews (**1 : ~1**)  

### Observation
The system is order-centric, but revenue and behavioral attributes are distributed across multiple tables.

---

## 4. Granularity and Data Modeling

### Grain Comparison

| Table            | Granularity  | Description                          |
|------------------|-------------|--------------------------------------|
| orders           | Order-level | Lifecycle, status, timestamps        |
| order_items      | Item-level  | Revenue, product, seller             |
| order_payments   | Payment-level | Transaction behavior               |

### Fact Table Design
- **Primary fact table:** order_items  
- **Secondary fact table:** orders  

### Key Insight
Revenue must be derived at the item level, not from the orders table.

---

## 5. Order Lifecycle

### Expected Flow
Purchase → Approval → Shipment → Delivery  

### Observed Behavior
Lifecycle events are not strictly sequential. Variations indicate:
- Asynchronous processing  
- System-level logging delays  

---

## 6. Data Quality Validation

### Key Integrity
- No duplicate `order_id` values identified  

### Null Handling
- Core identifiers and purchase timestamps are complete  
- Null values in later stages align with incomplete or canceled orders  

### Data Type Issues

**Observed Issues:**
- Timestamp columns stored as TEXT  
- Empty strings used instead of NULL  

**Resolution:**
- Standardized empty strings to NULL  
- Converted columns to DATETIME  

---

## 7. Data Issues and Impact

### 7.1 Delivery Before Shipment (~1.2%)

**Issue:**
- Delivery timestamp occurs before shipment timestamp  

**Impact:**
- Invalidates delivery time calculations  
- Must be excluded from analysis  

---

### 7.2 Shipment Before Approval (~3%)

**Issue:**
- Shipment recorded before payment approval  

**Impact:**
- Affects processing time metrics  
- Reflects asynchronous system behavior  

---

### 7.3 Delivered but Canceled (~0.63%)

**Issue:**
- Orders marked as both delivered and canceled  

**Interpretation:**
- Likely post-delivery refunds or chargebacks  

**Impact:**
- Distorts cancellation rate  
- Affects revenue interpretation  

---

### 7.4 Approval Before Purchase (~0.16%)

**Issue:**
- Approval timestamp precedes purchase timestamp  

**Impact:**
- Minor; likely due to timezone or system inconsistencies  

---

## 8. Data Reliability Assessment

### High Reliability
- Order creation events  
- Purchase timestamps  
- Processing time  

### Moderate Reliability
- Delivery time  
- Completion rate  
- Late delivery metrics  

### Low Reliability
- Cancellation interpretation  
- Lifecycle sequencing  

---

## 9. Data Cleaning Rules

The following steps are required before analysis:

1. Convert timestamp fields to DATETIME  
2. Replace empty strings with NULL  
3. Remove invalid lifecycle records:  
   - `order_delivered_customer_date < order_delivered_carrier_date`  
4. Separate pre- and post-delivery cancellations  
5. Avoid strict lifecycle ordering assumptions  

---

## 10. Metric Definitions (Phase 2)

### Delivery Time
delivery_date - carrier_date


### Order Completion Rate
delivered_orders / total_orders


### Cancellation Rate
- Pre-delivery cancellations  
- Post-delivery cancellations  

### Late Delivery Rate
delivered_date > estimated_delivery_date


### Average Order Value
average(order_total derived from order_items)


### Note
All metrics must be computed after filtering invalid lifecycle records.

---

## 11. Key Findings

1. Order lifecycle is asynchronous rather than strictly sequential  
2. Cancellation status combines multiple business scenarios  
3. Revenue must be derived from item-level data  
4. Data quality issues are systematic and require explicit handling  

---

## 12. Phase 2 Readiness

### Next Steps
- Validate revenue consistency between order_items and payments  
- Build lifecycle and funnel metrics  
- Analyze delivery performance  
- Design fact tables and analytical models  

---

## Summary
The order system is structurally sound but exhibits:
- Asynchronous lifecycle behavior  
- Ambiguous cancellation semantics  
- Timestamp inconsistencies  

With appropriate data cleaning and metric definitions, it is suitable for reliable analytical modeling.
