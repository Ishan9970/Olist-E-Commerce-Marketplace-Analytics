## Customer & Product Ecosystem Analysis — Phase 1

**Dataset:** Brazilian E-Commerce Public Dataset (Olist)

---

## 1. Objective

The objective of this phase is to develop a structured understanding of the marketplace by analyzing its core entities:

* Customers (demand side)
* Sellers (supply side)
* Products (catalog layer)
* Geolocation (regional mapping layer)

The focus is on data structure, relationships, quality, and business interpretation, without applying advanced modeling.

---

## 2. Dataset Summary

| Table       | Rows      | Columns | Description                           |
| ----------- | --------- | ------- | ------------------------------------- |
| customers   | 99,441    | 5       | Customer-level transactional identity |
| sellers     | 3,095     | 4       | Seller information                    |
| products    | 32,951    | 9       | Product catalog                       |
| geolocation | 1,000,163 | 5       | Raw geographic mapping data           |

---

## 3. Grain Definition

| Table       | Grain Description                               |
| ----------- | ----------------------------------------------- |
| customers   | One row per customer order instance             |
| sellers     | One row per seller                              |
| products    | One row per product                             |
| geolocation | One row per zip prefix observation (non-unique) |

---

## 4. Keys and Structural Integrity

| Table       | Primary Key | Notes                            |
| ----------- | ----------- | -------------------------------- |
| customers   | customer_id | customer_unique_id is not unique |
| sellers     | seller_id   | Unique and consistent            |
| products    | product_id  | Unique and consistent            |
| geolocation | None        | Zip prefix contains duplicates   |

### Key Observation

The geolocation dataset is non-normalized and requires preprocessing before it can be reliably used in joins.

---

## 5. Relationship Structure

The marketplace follows a transaction-driven architecture:

```
customers → orders → order_items → products → sellers
```

### Interpretation

* Customers, products, and sellers are not directly related
* Orders and order_items serve as bridge tables
* The system reflects a typical marketplace transaction flow

---

## 6. Join Relationships

### Core Joins

```
customers.customer_id = orders.customer_id  
orders.order_id = order_items.order_id  
order_items.product_id = products.product_id  
order_items.seller_id = sellers.seller_id  
```

### Geographic Joins

```
customers.customer_zip_code_prefix = geolocation.geolocation_zip_code_prefix  
sellers.seller_zip_code_prefix = geolocation.geolocation_zip_code_prefix  
```

### Constraint

Geolocation must be aggregated prior to joining due to duplicate zip prefixes.

---

## 7. Data Modeling Perspective

### Dimension Tables

* customers → Customer dimension
* sellers → Seller dimension
* products → Product dimension
* geolocation (processed) → Location dimension

### Fact Tables (Phase 2)

* orders → lifecycle fact table
* order_items → revenue fact table

---

## 8. Geographic Distribution

### Customer Distribution (Top States)

* SP: 41,746
* RJ: 12,852
* MG: 11,635
* RS: 5,466
* PR: 5,045

### Seller Distribution (Top States)

* SP: 1,849
* PR: 349
* MG: 244
* SC: 190
* RJ: 171

### Observations

* São Paulo (SP) is the primary hub for both demand and supply
* Rio de Janeiro (RJ) shows high demand but relatively lower seller presence
* Sellers are more geographically concentrated than customers
* Seller clustering in SP likely improves logistics efficiency

---

## 9. Data Quality Assessment

### Product Data

* Missing category values: ~1.8%
* Missing dimensional attributes: negligible

**Assessment:**
Category gaps may affect segmentation, while dimensional data is largely usable.

### Geolocation Data

**Identified issues:**

* Duplicate zip prefixes
* Multiple cities per zip code
* Inconsistent coordinates

**Assessment:**
Geolocation data requires normalization before analytical use.

---

## 10. Geolocation Processing Strategy

To standardize geolocation:

* Aggregate data at the zip prefix level
* Compute average latitude and longitude
* Resolve inconsistencies using majority or standardized values
* Create a structured lookup table

```
zip_prefix | latitude | longitude | city | state
```

---

## 11. Product Analysis

### Leading Categories

* cama_mesa_banho
* esporte_lazer
* moveis_decoracao
* beleza_saude
* utilidades_domesticas

### Observations

* Product demand is concentrated in home and lifestyle categories
* The catalog follows a long-tail distribution
* The marketplace maintains a diversified product mix

---

## 12. Seller Analysis

### Observations

* Sellers are heavily concentrated in São Paulo
* Regional imbalance exists in supply distribution
* Seller performance requires transaction-level data for evaluation

---

## 13. Data Quality Impact

| Issue                     | Impact                       | Risk                       |
| ------------------------- | ---------------------------- | -------------------------- |
| Missing product category  | Incomplete segmentation      | Distorted product insights |
| Missing dimensions        | Minor logistics inaccuracies | Low impact                 |
| Geolocation inconsistency | Incorrect regional analysis  | Poor operational decisions |

---

## 14. Business Interpretation

The marketplace can be characterized as:

* A two-sided platform with regional supply concentration
* A widely distributed customer base
* A diversified, long-tail product catalog
* A system dependent on preprocessing for geographic accuracy

---

## 15. Key Takeaways

* Demand is broadly distributed, while supply is concentrated
* Regional supply-demand gaps are present
* Product diversity is high with no single dominant category
* Data quality is strong overall, with geolocation as the primary limitation

---

## Phase Status

Phase 1 is complete. The system structure, data quality, and business context are well understood.

---

## Next Steps

* Integrate orders, order_items, and payments
* Validate revenue and order flow
* Develop analytical metrics and reporting models
