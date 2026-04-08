# Phase 2 — Dimension Modeling & Validation Report

---

## 1. Objective

The objective of Phase 2 was to design, clean, and validate all **dimension tables** required for a scalable analytical data warehouse.

This phase focused on:

* Transforming raw datasets into structured dimension tables
* Resolving data quality issues (duplicates, inconsistencies, nulls)
* Defining clear relationships between dimensions and future fact tables
* Ensuring all dimensions are **analytics-ready and join-compatible**

This phase complements fact table modeling by:

* Providing clean lookup tables
* Enabling accurate aggregations and slicing
* Supporting star schema design

---

## 2. Dimension Layer Overview

In a star schema, dimension tables provide **descriptive context** to fact tables.

### Role of Dimensions:

* Enable filtering, grouping, and segmentation
* Store cleaned and standardized attributes
* Reduce redundancy in fact tables

### Connection to Fact Tables:

Future fact tables (`fact_orders`, `fact_order_items`) will connect as follows:

* `fact_orders.customer_id → dim_customers.customer_id`
* `fact_order_items.product_id → dim_products.product_id`
* `fact_order_items.seller_id → dim_sellers.seller_id`
* `fact tables.zip_code → dim_geolocation.zip_code`
* `orders.order_purchase_timestamp → dim_date.date`

---

## 3. Dimension Tables Design

---

### dim_customers

**Grain:**
One row per unique customer (`customer_unique_id`)

**Columns:**

* customer_key (surrogate key)
* customer_id (latest order-level identifier)
* customer_unique_id (true customer identifier)
* zip_code
* city
* state

**Handling customer_id vs customer_unique_id:**

* `customer_id` is an order-level identifier used in fact tables
* `customer_unique_id` represents the actual user across orders
* One user can have multiple `customer_id` values

**Deduplication Logic:**

* Applied `ROW_NUMBER()` partitioned by `customer_unique_id`
* Selected latest `customer_id` per user
* Ensured one row per customer

**Validation:**

* Row count = 96,096
* Matches distinct `customer_unique_id` in source
* No duplicate customers

---

### dim_products

**Grain:**
One row per product (`product_id`)

**Columns:**

* product_key (surrogate key)
* product_id
* product_category
* product_weight_g
* product_length_cm
* product_height_cm
* product_width_cm
* product_volume_cm3

**Handling Missing Values:**

* Empty strings converted to NULL
* Missing categories replaced with `'unknown'`

**Attribute Selection:**

* Included physical attributes for logistics analysis
* Derived volume for advanced analytics

---

### dim_sellers

**Grain:**
One row per seller (`seller_id`)

**Columns:**

* seller_key (surrogate key)
* seller_id
* zip_code
* city
* state

**Location Structure:**

* Standardized city and state formatting
* Prepared for integration with geolocation dimension

---

### dim_geolocation

**Original Data Issues:**

* No primary key
* Duplicate zip codes
* Same zip mapped to multiple cities
* Inconsistent latitude/longitude

**Aggregation Logic:**

* Grouped by `zip_code`, `city`, `state`
* Calculated frequency of each city per zip
* Selected **most frequent city (mode)** using `ROW_NUMBER()`
* Averaged latitude and longitude

**Final Schema:**

* geolocation_key (surrogate key)
* zip_code
* latitude
* longitude
* city
* state

**Outcome:**

* One row per zip code
* Deterministic and consistent mapping

---

### dim_date

**Purpose:**

Enables time-based analysis such as trends, seasonality, and performance tracking.

**Generation Logic:**

* Created using recursive date series
* Range derived from:

  * MIN(order_purchase_timestamp)
  * MAX(order_purchase_timestamp)

**Columns:**

* date_key (surrogate key)
* date
* year
* month
* month_name
* day
* day_of_week
* quarter

**Join Definition:**

Primary join:

* `orders.order_purchase_timestamp → dim_date.date`

**Additional Considerations:**

Other timestamps (approval, delivery) can be mapped in future for advanced analysis.

---

## 4. Data Cleaning & Transformation

### dim_customers

* Removed duplicates caused by multiple orders per user
* Standardized city/state formatting
* Preserved both identity levels

### dim_products

* Converted empty strings to NULL
* Replaced missing categories with `'unknown'`
* Created derived feature (volume)

### dim_sellers

* Verified uniqueness
* Standardized geographic fields

### dim_geolocation

* Resolved duplicate zip mappings
* Selected most frequent city (mode)
* Averaged coordinates

### dim_date

* Generated continuous date range
* Extracted temporal attributes

---

## 5. Join Readiness & Integration

### Join Keys Used:

* `customer_id → dim_customers.customer_id`
* `product_id → dim_products.product_id`
* `seller_id → dim_sellers.seller_id`
* `zip_code → dim_geolocation.zip_code`
* `order_purchase_timestamp → dim_date.date`

### Geolocation Join Clarity:

* `dim_customers.zip_code → dim_geolocation.zip_code`
* `dim_sellers.zip_code → dim_geolocation.zip_code`

### Assumptions:

* Zip code is sufficient for geographic mapping
* Latest customer_id represents user

---

## 6. Data Quality & Reliability

| Dimension       | Reliability | Reason                                      |
| --------------- | ----------- | ------------------------------------------- |
| dim_customers   | High        | Proper deduplication and identity handling  |
| dim_products    | High        | Clean attributes and handled missing values |
| dim_sellers     | High        | Unique and clean dataset                    |
| dim_geolocation | Medium      | Aggregated from inconsistent raw data       |
| dim_date        | High        | System-generated and complete               |

---

## 7. Design Decisions & Trade-offs

### Customer Identity

* Chose `customer_unique_id` as grain
* Retained `customer_id` for fact joins

### Geolocation Handling

* Selected most frequent city instead of arbitrary value
* Trade-off: may still lose minority mappings

### Column Selection

* Avoided unnecessary columns
* Focused on analytical usability

---

## 8. Key Learnings

* Real-world datasets contain structural inconsistencies
* Identity resolution is critical for accurate analytics
* Geolocation data requires careful aggregation
* Dimension design directly impacts analytical correctness

---

## 9. Readiness for Analytics

The dimension layer enables:

### Customer Segmentation

* Unique users identified correctly
* Geographic segmentation possible

### Product Analysis

* Category-based insights
* Logistics and size analysis

### Seller Performance

* Regional seller distribution
* Supply concentration analysis

### Geographic Analysis

* Unified location mapping
* Customer vs seller imbalance analysis

---

## 10. Surrogate Key Strategy

Surrogate keys (`customer_key`, `product_key`, `seller_key`, `geolocation_key`, `date_key`) were generated for each dimension.

However:

* Current joins are based on **natural keys** (`customer_id`, `product_id`, etc.)
* Fact tables are not yet implemented

**Future Usage:**

Surrogate keys will be used in fact tables to:

* Improve join performance
* Enable slowly changing dimensions
* Ensure stable relationships

---

# ✅ FINAL STATUS

Phase 2 is complete with:

* Clean dimension tables
* Validated data quality
* Clear join logic
* Analytics-ready structure

This dimension layer is now ready for **Phase 3 — Fact Table Modeling**.
