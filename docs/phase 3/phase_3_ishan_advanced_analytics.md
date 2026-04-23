# Phase 3 — Advanced Analytics & Insights Report

---

# 1. Objective

Phase 3 focuses on transforming a **validated data model (Phase 2)** into **actionable business intelligence**.

### Goals:

* Build **analytical layers on top of fact tables**
* Derive **customer behaviour insights**
* Analyse **revenue trends and operational performance**
* Enable **decision-ready outputs**

### Progression from Phase 2:

* Phase 2 ensured:

  * clean joins
  * correct revenue calculation
  * well-defined fact tables

* Phase 3 extends this by:

  * introducing **customer-level behavioural modelling**
  * quantifying **growth, retention, and concentration dynamics**

---

# 2. Analytical Framework

### Why `fact_order_items` for Revenue

* Revenue exists at **item level**
* Formula used:

```text
price + freight_value
```

👉 Ensures:

* complete revenue capture
* no duplication

---

### Why `fact_orders` for Lifecycle Metrics

Used for:

* timestamps
* delivery metrics
* order lifecycle

---

### Role of `dim_date`

* Standardised time aggregation
* Enables consistent monthly analysis

---

# 3. RFM Segmentation (CRITICAL — UPGRADED)

## Mathematical Definition

### Reference Date

```text
reference_date = MAX(order_purchase_timestamp)
```

---

### Exact Formulas

```text
recency_days = DATEDIFF(reference_date, last_purchase_date)
frequency = COUNT(DISTINCT order_id)
monetary_value = SUM(price + freight_value)
```

---

### Dataset Constraints

* Only valid orders:

```sql
order_status = 'delivered'
order_purchase_timestamp IS NOT NULL
```

---

## Scoring Logic

* Recency → NTILE(5) (lower = better)
* Monetary → NTILE(5) (higher = better)

### Frequency Fix (Critical)

Due to extreme skew (~97% single-order users):

| Orders | Score |
| ------ | ----- |
| 1      | 1     |
| 2      | 3     |
| 3+     | 5     |

---

## Segment Distribution (Quantified)

| Segment         | % Customers |
| --------------- | ----------- |
| Others          | 31.59%      |
| At Risk         | 23.47%      |
| Loyal Customers | 20.04%      |
| Champions       | 16.49%      |
| Lost Customers  | 8.41%       |

---

# 4. Customer Value Analysis

### Key Findings

* **96.88% customers = single-order users**
* Repeat customers ≈ **3.1%**
* High-frequency users ≈ negligible

---

### Spend Behaviour

| Segment    | Avg Spend |
| ---------- | --------- |
| 1_order    | ~160      |
| 2–5_orders | ~306      |
| 5+_orders  | ~809      |

---

## Insight

> Customer value increases with frequency, but **high-value purchases can still occur in one-time transactions**

---

# 5. Revenue Trend Analysis (UPGRADED)

## Monthly Growth (MoM)

* Highest meaningful growth:

  * **Nov 2017 → +53.55%**

* Largest decline:

  * **Dec 2017 → -26.90%**

---

## Growth Interpretation

* Early extreme spikes excluded (low base effect)
* 2017 → expansion phase
* 2018 → stabilisation phase

### Stable Growth Range:

```text
-10% to +16%
```

---

## Insight

> Marketplace transitioned from **hyper-growth → maturity**

---

# 6. Delivery Performance Analysis (UPGRADED)

## Delivery vs Order Value (Quantified)

| Segment | Avg Delivery | % vs Low |
| ------- | ------------ | -------- |
| Low     | 7.55 days    | —        |
| Medium  | 9.48 days    | +25.49%  |
| High    | 10.16 days   | +34.49%  |

---

## Late Delivery Rate

* **8.11%**

👉 Interpretation:

* SLA adherence is strong
* speed optimisation is weak

---

## Insight

> High-value orders experience **~34.5% slower delivery**, indicating a structural mismatch in service prioritisation

---

# 7. Key Insights (FULLY QUANTIFIED)

## 1. Revenue Concentration

| Segment           | Contribution |
| ----------------- | ------------ |
| Top 10%           | 38.27%       |
| Next 10%          | 15.27%       |
| Top 20% (derived) | **53.54%**   |
| Remaining 80%     | 46.45%       |

---

### Transparency Note

> Top 20% is derived by combining Top 10% and Next 10% to avoid overlapping percentile bias.

---

## Interpretation

> Revenue is **moderately concentrated**, not strictly Pareto (80/20)

---

## 2. Retention (CRITICAL)

### Month 1:

```text
~0.2% – 0.7%
```

### Month 3:

```text
~0.7% – 1.4%
```

---

## Interpretation

> Extremely low retention confirms **near-zero repeat behaviour**

---

## 3. Acquisition vs Retention

* Growth driven by:

  * new users
* Not driven by:

  * lifecycle retention

---

## 4. Delivery Impact on Value

* High-value orders:

  * **+34.49% slower delivery**

---

## Combined Insight

> Poor delivery experience for high-value orders likely contributes to extremely low retention

---

## 5. System Behaviour Summary

| Dimension             | Observation                   |
| --------------------- | ----------------------------- |
| Growth                | Strong but acquisition-driven |
| Retention             | Extremely low                 |
| Revenue concentration | Moderate                      |
| Delivery              | Uneven                        |
| Premium experience    | Weak                          |

---

# 7A. Retention Layer (NEW)

## Cohort Definition

```text
cohort_month = first purchase month
```

---

## Measurement

* Month 1 → next-month return
* Month 3 → return within 3 months

---

## Key Finding

> Retention remains **below 1.5% even after 3 months**

---

## Interpretation

* Lack of:

  * engagement loops
  * repeat purchase incentives

---

# 8. Data Limitations

* `customer_id` vs `customer_unique_id` distinction critical
* Heavy skew limits standard RFM interpretation
* Delivery influenced by geography
* Revenue excludes:

  * discounts
  * refunds

---

# 9. Readiness for Dashboard / Business Use

## Applications

### Customer Layer

* RFM segmentation
* retention tracking

### Revenue Layer

* MoM growth
* AOV stability

### Operations Layer

* delivery performance
* SLA monitoring

---

## Decisions Enabled

| Area      | Action                       |
| --------- | ---------------------------- |
| Marketing | retention campaigns          |
| Logistics | optimise high-value delivery |
| Sellers   | enforce SLA consistency      |
| Product   | improve premium CX           |

---

# FINAL SUMMARY

Phase 3 reveals a marketplace that is:

* **acquisition-driven**
* **retention-deficient**
* **operationally uneven**

---

## Most Critical Insight

> The biggest opportunity is not growth — it is **retention and post-purchase experience**, especially for high-value customers.

---

## Strategic Direction

To unlock next-stage growth:

* improve delivery for high-value orders
* convert one-time buyers into repeat users
* build lifecycle engagement mechanisms

---

This elevates Phase 3 from:

> descriptive analytics

to:

> **decision-grade, production-level business intelligence**
