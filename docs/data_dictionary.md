# 📊 Data Dictionary — Olist E-Commerce Dataset

---

## 🧾 Orders Table

| Column                        | Description                                              | Notes                       |
| ----------------------------- | -------------------------------------------------------- | --------------------------- |
| order_id                      | Unique identifier for each order                         | Primary Key                 |
| customer_id                   | Identifier for customer placing the order                | Foreign Key                 |
| order_status                  | Current order state (delivered, shipped, canceled, etc.) | Not always reliable         |
| order_purchase_timestamp      | Timestamp when order was placed                          | High reliability            |
| order_approved_at             | Payment approval timestamp                               | May be NULL                 |
| order_delivered_carrier_date  | Shipment handoff timestamp                               | May contain inconsistencies |
| order_delivered_customer_date | Final delivery timestamp                                 | Used for delivery metrics   |
| order_estimated_delivery_date | Promised delivery date                                   | Used for SLA comparison     |

---

## 📦 Order Items Table

| Column              | Description                 | Notes                        |
| ------------------- | --------------------------- | ---------------------------- |
| order_id            | Order identifier            | Foreign Key                  |
| order_item_id       | Item sequence within order  | Defines item-level grain     |
| product_id          | Product identifier          | Links to products            |
| seller_id           | Seller fulfilling the order | Links to sellers             |
| shipping_limit_date | Seller shipping deadline    | Operational metric           |
| price               | Item price                  | Revenue component            |
| freight_value       | Shipping cost               | Additional revenue component |

---

## 💳 Order Payments Table

| Column               | Description                                | Notes                           |
| -------------------- | ------------------------------------------ | ------------------------------- |
| order_id             | Order identifier                           | Foreign Key                     |
| payment_sequential   | Payment attempt sequence                   | Multiple payments possible      |
| payment_type         | Payment method (credit_card, boleto, etc.) | Behavioral signal               |
| payment_installments | Number of installments                     | Important for credit analysis   |
| payment_value        | Payment amount                             | Must reconcile with order_items |

---

## ⭐ Order Reviews Table

| Column                  | Description              | Notes                        |
| ----------------------- | ------------------------ | ---------------------------- |
| review_id               | Unique review identifier | Primary Key                  |
| order_id                | Associated order         | Foreign Key                  |
| review_score            | Rating (1–5)             | Customer satisfaction metric |
| review_comment_title    | Short review title       | Optional                     |
| review_comment_message  | Detailed feedback        | Optional                     |
| review_creation_date    | Review submission date   |                              |
| review_answer_timestamp | Response time            |                              |

---

## 👤 Customers Table

| Column                   | Description                   | Notes                |
| ------------------------ | ----------------------------- | -------------------- |
| customer_id              | Unique order-level identifier | Not unique per user  |
| customer_unique_id       | Unique customer across orders | True user ID         |
| customer_zip_code_prefix | Zip code prefix               | Links to geolocation |
| customer_city            | Customer city                 |                      |
| customer_state           | Customer state                |                      |

---

## 🏪 Sellers Table

| Column                 | Description              | Notes       |
| ---------------------- | ------------------------ | ----------- |
| seller_id              | Unique seller identifier | Primary Key |
| seller_zip_code_prefix | Seller zip prefix        |             |
| seller_city            | Seller city              |             |
| seller_state           | Seller state             |             |

---

## 📦 Products Table

| Column                     | Description               | Notes               |
| -------------------------- | ------------------------- | ------------------- |
| product_id                 | Unique product identifier | Primary Key         |
| product_category_name      | Product category          | Some missing values |
| product_name_length        | Length of product name    |                     |
| product_description_length | Description size          |                     |
| product_photos_qty         | Number of images          |                     |
| product_weight_g           | Weight in grams           |                     |
| product_length_cm          | Length                    |                     |
| product_height_cm          | Height                    |                     |
| product_width_cm           | Width                     |                     |

---

## 🌍 Geolocation Table

| Column                      | Description | Notes        |
| --------------------------- | ----------- | ------------ |
| geolocation_zip_code_prefix | Zip prefix  | Not unique   |
| geolocation_lat             | Latitude    | Noisy        |
| geolocation_lng             | Longitude   | Noisy        |
| geolocation_city            | City        | Inconsistent |
| geolocation_state           | State       |              |

---

## ⚠️ Key Notes

* Revenue is derived from **order_items**, not orders
* Customer identity should be based on **customer_unique_id**
* Geolocation data must be **aggregated before use**
* Timestamp inconsistencies must be handled before analysis

---
