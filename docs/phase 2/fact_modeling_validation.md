## Phase 2 — Data Modeling & Validation

### Objective

Phase 2 focused on transforming raw transactional and entity-level data into a clean, validated, and analytics-ready data warehouse.

This phase established a strong analytical foundation by:

* Designing a star schema
* Separating lifecycle, revenue, and entity data
* Applying strict data cleaning and validation rules
* Ensuring consistency between operational and financial systems

---

### Data Model Architecture

The system was structured into two logical layers:

#### Fact Layer (Transactional Events)

* `fact_orders` → captures order lifecycle (timestamps, status, fulfillment stages)
* `fact_order_items` → captures revenue at the item level

Revenue is modeled at the item level to ensure accuracy across multi-item orders and prevent aggregation errors.

---

#### Dimension Layer (Contextual Attributes)

* `dim_customers` → customer identity resolved using `customer_unique_id`
* `dim_products` → product attributes and category mapping
* `dim_sellers` → seller metadata and location
* `dim_geolocation` → cleaned and aggregated geographic mapping
* `dim_date` → standardized time dimension for temporal analysis

---

### Star Schema Design

The data warehouse follows a star schema structure:

* Dimension tables provide descriptive context
* Fact tables store measurable events

All analytical queries are anchored on `fact_order_items` (revenue) and `fact_orders` (lifecycle), with dimensions providing enrichment.

---

### Data Cleaning and Transformation

The following transformations were applied to ensure data quality and analytical correctness:

* Converted timestamp fields from TEXT to DATETIME
* Removed logically invalid lifecycle records (e.g., delivery before shipment)
* Preserved asynchronous events to reflect real-world system behavior
* Standardized NULL handling and missing values
* Deduplicated customers using `customer_unique_id`
* Aggregated geolocation data using mode (city) and average coordinates

These rules ensured that corrupted records were removed while legitimate business behavior was retained.

---

### Revenue Validation

Revenue consistency was validated across two independent systems:

* Item-level revenue (`fact_order_items`)
* Payment-level revenue (`order_payments`)

Observed variance:

* Difference less than 0.02%

This confirms:

* correctness of joins
* accuracy of filters
* integrity of aggregation logic

---

### KPI Foundation

Core business metrics were computed on the validated model:

* Total Revenue
* Total Orders
* Average Order Value (AOV)
* Delivery Time
* Completion Rate
* Cancellation Rate

All KPIs are based on:

* correct grain definition
* validated joins
* filtered and consistent datasets

---

### Data Reliability

* High reliability: revenue, AOV, total orders
* Medium reliability: delivery metrics (affected by outliers and asynchronous events)
* Contextual reliability: cancellation metrics (due to post-delivery cancellations)

---

### Key Learnings

* Revenue must be calculated at the item level, not the order level
* Customer identity requires mapping between transactional and unique identifiers
* Real-world systems are event-driven rather than strictly sequential
* Data cleaning must remove invalid records without discarding valid behavior
* Financial and operational systems must be explicitly reconciled

---

### Outcome

By the end of Phase 2:

* A complete star schema was implemented
* Fact and dimension tables were fully defined
* Data quality issues were resolved
* Revenue consistency was validated
* The dataset became suitable for advanced analytics

---

### Next Step

Phase 3 will focus on:

* Customer segmentation (RFM)
* Cohort and retention analysis
* Delivery performance impact
* Advanced business insights

---

This phase establishes a production-grade analytical layer that ensures all downstream insights are accurate, consistent, and reliable.
