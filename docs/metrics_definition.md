# 📏 Metric Definitions — Phase 2 Foundation

---

## 🚚 Delivery Time

**Definition:**
Time taken from shipment to customer delivery

**Formula:**
delivery_date - carrier_date

**Include:**

* Delivered orders only
* Valid timestamps

**Exclude:**

* delivery < shipment
* NULL timestamps

**Reliability:** Medium

---

## ⏱️ Processing Time

**Definition:**
Time taken from order placement to payment approval

**Formula:**
approval_date - purchase_date

**Include:**

* Orders with approval timestamps

**Exclude:**

* approval < purchase

**Reliability:** High

---

## ✅ Order Completion Rate

**Definition:**
Percentage of orders successfully delivered

**Formula:**
delivered_orders / total_orders

**Include:**

* All valid orders

**Exclude:**

* ambiguous status records

**Reliability:** Medium

---

## ❌ Cancellation Rate

**Definition:**
Percentage of canceled orders

**Types:**

* Pre-delivery cancellations
* Post-delivery cancellations

**Note:**
Delivered + canceled must be treated separately

**Reliability:** Low

---

## ⏰ Late Delivery Rate

**Definition:**
Orders delivered after estimated date

**Formula:**
delivery_date > estimated_delivery_date

**Include:**

* Delivered orders

**Exclude:**

* invalid timestamps

**Reliability:** Medium

---

## 💰 Average Order Value (AOV)

**Definition:**
Average revenue per order

**Formula:**
SUM(order_items.price + freight) / total_orders

**Source:**
order_items

**Note:**
Must aggregate at order level first

**Reliability:** High

---

## ⚠️ Important Notes

* All metrics require cleaned data
* Invalid lifecycle records must be filtered
* Metrics should not assume strict event ordering

---
