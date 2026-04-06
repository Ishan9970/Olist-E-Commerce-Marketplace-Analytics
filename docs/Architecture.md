# 🏗️ System Architecture

Raw CSV Data
     ↓
Data Cleaning (Python)
     ↓
Data Transformation
     ↓
Star Schema (Warehouse)
     ↓
SQL + Analytics Layer
     ↓
Dashboard (Power BI / Tableau)
     ↓
Business Insights


---

## Key Design Principles

* Single source of truth → warehouse tables
* Separation of concerns → ingestion, transformation, analysis
* Reproducibility → pipeline-driven workflow

---
