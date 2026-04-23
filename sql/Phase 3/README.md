## 🔷 Phase 3 — Advanced Analytics & Business Insights

### 🎯 Objective

Phase 3 focused on transforming the validated data model (Phase 2) into **decision-grade business intelligence** by analyzing:

* customer behavior and lifecycle
* retention and cohort dynamics
* revenue trends and concentration
* operational performance (delivery)
* geographic and product-level insights

---

### 🧠 Analytical Approach

This phase combined two analytical layers:

#### 🔹 Revenue & System Layer

* RFM segmentation
* revenue concentration analysis
* monthly growth trends
* delivery performance

#### 🔹 Customer & Behavioral Layer

* cohort analysis (monthly cohorts)
* retention tracking
* customer lifecycle analysis
* geographic and product insights

---

### 📊 Key Findings

#### 👤 Customer Behavior

* ~97% of users are **one-time customers**
* repeat users ≈ **3%**
* average time between orders ≈ **79 days**

> Indicates extremely weak customer lifecycle depth

---

#### 🔁 Retention

* Month 1 retention: **~0.2% – 0.7%**
* Month 3 retention: **~0.7% – 1.4%**

> Retention remains below 1.5% across all cohorts

---

#### 💰 Revenue Structure

* Top 10% customers → **38.27% of revenue**
* Top 20% customers → **53.54% of revenue**

> Revenue is moderately concentrated (not strict Pareto)

---

#### 📈 Growth Trends

* Rapid growth in 2017
* Stabilization in 2018
* Growth driven primarily by **new users**, not retention

---

#### 🚚 Delivery Performance

* Low-value orders: ~7.5 days
* High-value orders: ~10.1 days (**+34.5% slower**)
* Late delivery rate: ~8.1%

> Premium experience is weaker than expected

---

#### 🌍 Geographic Insights

* São Paulo (SP) dominates demand and supply
* Remote regions experience **4–5× slower delivery**
* Significant regional imbalance exists

---

#### 🛍️ Product Insights

* Top 5 categories contribute **~35–40% of revenue**
* Marketplace shows:

  * high-frequency, low-value purchases
  * low-frequency, high-value purchases

---

### 🔗 Cross-System Insight

A key hypothesis derived from combined analysis:

> Slower delivery performance (especially in remote regions) may negatively impact repeat purchase behavior and retention.

---

### ⚠️ Data Limitations

* Customer identity requires mapping (`customer_id` → `customer_unique_id`)
* Geolocation data is aggregated (loss of precision)
* Heavy skew in user behavior (97% one-time users)
* Revenue excludes discounts and refunds

---

### 🧠 Final Business Interpretation

Phase 3 reveals a marketplace that is:

* **acquisition-driven**
* **retention-deficient**
* **operationally uneven**

---

### 🚀 Strategic Implications

To unlock sustainable growth:

* Improve **post-purchase experience**
* Optimize **delivery performance for high-value orders**
* Build **retention and engagement mechanisms**
* Address **regional logistics gaps**

---

### ✅ Outcome

By the end of Phase 3:

* Advanced analytical models (RFM, cohorts, retention) are built
* Customer behavior and revenue dynamics are fully understood
* Key growth bottlenecks are identified
* Dataset is ready for **dashboarding and business decision-making**

---

### 🔜 Next Step

Phase 4 will focus on:

* interactive dashboards (Power BI / Tableau)
* business storytelling
* stakeholder-ready insights

