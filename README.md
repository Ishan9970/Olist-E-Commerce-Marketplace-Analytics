# Olist Business Intelligence & Customer Intelligence Platform

## Project Overview

This project is a complete end-to-end Business Intelligence and Analytics platform built using the Brazilian E-Commerce Public Dataset by Olist.

The objective of the project was to simulate a production-grade analytics workflow similar to systems used in large-scale marketplace and technology companies.

The project covers the complete analytics lifecycle:

* Data understanding
* Data quality validation
* Warehouse modeling
* KPI engineering
* Advanced analytics
* Customer intelligence
* Executive dashboarding
* Operational monitoring
* Business storytelling

The system was collaboratively designed with responsibilities divided across:

* Executive & Revenue Intelligence
* Customer & Behavioral Intelligence

The final result is a scalable analytics ecosystem capable of supporting strategic business decision-making.

---

# Dataset

Dataset Used:

[Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce?utm_source=chatgpt.com)

Dataset Characteristics:

* ~100k marketplace orders
* Multi-table relational e-commerce dataset
* Covers marketplace activity from 2016–2018

Core Tables:

| Table       | Purpose                              |
| ----------- | ------------------------------------ |
| orders      | Order lifecycle tracking             |
| order_items | Revenue & product-level transactions |
| payments    | Financial transaction records        |
| reviews     | Customer satisfaction signals        |
| customers   | Customer identity layer              |
| sellers     | Seller ecosystem                     |
| products    | Product catalog                      |
| geolocation | Geographic intelligence              |

---

# Tech Stack

| Category        | Tools        |
| --------------- | ------------ |
| Database        | MySQL        |
| Query Language  | SQL          |
| Data Modeling   | Star Schema  |
| Dashboarding    | Power BI     |
| Data Export     | CSV          |
| Documentation   | Markdown     |
| Version Control | Git & GitHub |

---

# Project Architecture

```text
Raw CSV Dataset
       ↓
MySQL Data Cleaning
       ↓
Fact & Dimension Modeling
       ↓
KPI Engineering
       ↓
Advanced SQL Analytics
       ↓
CSV Export Layer
       ↓
Power BI Dashboards
       ↓
Executive & Customer Intelligence Reporting
```

---

# Phase Breakdown

---

# Phase 1 — Data Understanding & Validation

## Objective

Phase 1 focused on understanding the structural behavior of the marketplace dataset and validating data reliability before downstream modeling and analytics.

---

## Key Work Completed

### Order System Analysis

* Validated order lifecycle consistency
* Identified timestamp anomalies
* Investigated cancellation edge cases
* Standardized datetime handling
* Defined lifecycle cleaning rules

### Customer & Product Ecosystem Analysis

* Mapped marketplace relationships
* Analyzed customer and seller geography
* Evaluated product catalog distribution
* Investigated geolocation inconsistencies
* Defined warehouse-ready entity structure

---

## Key Findings

* São Paulo dominates both supply and demand
* Geolocation data required preprocessing
* Lifecycle events are asynchronous
* Customer identity requires careful handling
* Timestamp inconsistencies can impact analytics reliability

---

## Deliverables

* Order system analysis report 
* Customer & product ecosystem analysis report 

---

# Phase 2 — Data Modeling & Warehouse Design

## Objective

Phase 2 focused on transforming raw transactional data into a validated analytics-ready warehouse model.

---

## Key Work Completed

### Fact Table Modeling

Built:

* `fact_orders`
* `fact_order_items`

### Dimension Modeling

Built:

* `dim_customers`
* `dim_products`
* `dim_sellers`
* `dim_geolocation`
* `dim_date`

### Validation & KPI Engineering

* Revenue reconciliation
* Lifecycle cleaning enforcement
* Delivery metric computation
* KPI standardization
* Grain validation

---

## Key Findings

* Revenue must be modeled at item level
* Grain control is critical for metric correctness
* Revenue reconciliation variance remained below 0.02%
* Surrogate key strategy prepared for future scalability

---

## Deliverables

* Fact modeling & validation report 
* Dimension modeling & validation report 

---

# Phase 3 — Advanced Analytics & Customer Intelligence

## Objective

Phase 3 focused on building decision-grade business intelligence on top of validated warehouse tables.

---

## Key Work Completed

### Revenue & Operational Analytics

* RFM segmentation
* Revenue concentration analysis
* Monthly growth analysis
* Delivery performance analysis
* SLA monitoring metrics

### Customer & Behavioral Analytics

* Cohort analysis
* Retention analysis
* Customer lifecycle analysis
* Geographic intelligence
* Product intelligence

---

## Key Findings

### Customer Behavior

* ~97% of customers are one-time purchasers
* Repeat purchasing behavior is extremely weak
* Average time between repeat purchases is high

### Retention

* Month 1 retention remains below 1%
* Month 3 retention remains below 1.5%

### Revenue Intelligence

* Top 20% customers contribute ~53% of revenue
* Marketplace exhibits moderate revenue concentration

### Operations

* High-value orders experience slower delivery
* Remote regions face significantly weaker fulfillment performance

---

## Core Business Insight

> Marketplace growth is acquisition-driven rather than retention-driven, with operational inconsistency likely contributing to weak repeat purchasing behavior.

---

## Deliverables

* Advanced analytics & insights report 
* Customer behavior, cohort & retention report 

---

# Phase 4 — Executive Dashboard & BI Reporting System

## Objective

Phase 4 focused on operationalizing analytical outputs into stakeholder-ready dashboard systems and executive reporting layers.

---

## Key Work Completed

### Executive & Revenue Dashboard System

* KPI dashboard architecture
* Revenue monitoring dashboards
* Customer value dashboards
* Operational monitoring framework
* Dashboard interaction logic
* Executive reporting structure

### Customer Intelligence Dashboard System

* Cohort dashboards
* Retention monitoring dashboards
* Customer behavior dashboards
* Geographic intelligence dashboards
* Product intelligence dashboards
* Monitoring & alert framework

### Dashboard Export Layer

Prepared dashboard-ready SQL exports for:

* KPI reporting
* Revenue trends
* Cohort analysis
* Retention tracking
* Geographic analysis
* Product intelligence

---

## Dashboard Layers

### Executive & Revenue Intelligence

* Revenue trends
* KPI monitoring
* RFM analysis
* Revenue concentration
* Delivery diagnostics

### Customer Intelligence

* Cohort analysis
* Retention tracking
* Customer behavior
* Geographic intelligence
* Product intelligence

---

## Key Findings

* Marketplace is operationally scalable
* Growth depends heavily on acquisition
* Customer retention is structurally weak
* Geographic logistics imbalance impacts customer experience
* Premium customers receive slower fulfillment

---

## Deliverables

* Executive dashboard & KPI reporting report 
* Customer intelligence & behavioral dashboard report 
* Power BI dashboard architecture
* Dashboard export datasets

---

# Key Business Insights

## Customer Lifecycle

* ~97% of users are one-time purchasers
* Repeat behavior is extremely limited
* Lifecycle engagement is shallow

---

## Revenue Structure

* Revenue concentration is moderate
* Marketplace is not strict 80/20 Pareto
* Premium customers contribute disproportionately to revenue

---

## Operations & Logistics

* Delivery performance varies significantly by region
* Remote states experience substantially slower fulfillment
* High-value orders receive slower delivery than low-value orders

---

## Retention

* Retention remains critically low across all cohorts
* Marketplace growth relies more on acquisition than customer loyalty

---

# Dashboard Ecosystem

The final dashboard ecosystem includes:

## Executive Dashboard

* KPI monitoring
* Revenue trend analysis
* Revenue concentration analysis
* Operational diagnostics

## Customer Intelligence Dashboard

* Cohort heatmaps
* Retention tracking
* Customer behavior analysis
* Geographic intelligence
* Product intelligence

---

# Repository Structure

```text
project_root/
│
├── data/
├── sql/
├── dashboard/
├── docs/
├── presentation/
├── assets/
└── future_scope/
```

Detailed structures are organized phase-wise inside each directory.

---

# Future Scope

Potential production-grade extensions include:

* Automated ETL orchestration
* Real-time dashboard refresh pipelines
* Cloud warehouse migration
* dbt-based transformations
* Customer churn prediction
* Customer Lifetime Value modeling
* Streaming analytics architecture

---

# Final Outcome

This project evolved from raw transactional marketplace data into a complete Business Intelligence and Customer Intelligence platform capable of supporting:

* executive reporting
* operational monitoring
* retention analysis
* customer intelligence
* revenue analytics
* logistics diagnostics
* strategic decision-making

The project demonstrates a complete analytics workflow:

> Raw Data → Validation → Modeling → Analytics → Dashboarding → Executive Intelligence

---

# Contributors

## Executive & Revenue Intelligence

Ishan

## Customer & Behavioral Intelligence

Ishita

---

# Project Status

Completed

Includes:

* Warehouse modeling
* KPI framework
* Advanced analytics
* Dashboard architecture
* Executive reporting
* Customer intelligence system
