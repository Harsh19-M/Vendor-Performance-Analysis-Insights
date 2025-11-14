# Vendor Performance Analysis & Insights
End-to-end **Vendor Performance Analysis** project using **SQL** (data exploration, joins, and aggregation), **Python** (EDA, data cleaning, and research analysis), and **Power BI** (interactive dashboards and reporting) to identify top-performing vendors, optimize inventory efficiency, and uncover actionable business insights.  


## Key Highlights
- Built a complete **end-to-end data analytics pipeline**: connected and queried PostgreSQL tables – cleaned, aggregated, and analyzed data in Python – visualized and modeled insights in Power BI for actionable business decisions.
- Aggregated massive datasets **(millions of rows)** from `vendor_invoice`, `purchases`, and `sales` table **(12.8+ million rows)** into a single **`vendor_sales_summary`** table of **10,692 rows** using **CTEs (Common Table Expressions)** to pre-aggregate freight, purchase, and sales metrics per vendor-brand, enabling faster, actionable analysis.
- Applied structured **project planning frameworks**: **SMART** goals for objectives and **CRISP-DM** methodology for step-by-step data analysis, from business understanding → data preparation → modeling → evaluation → deployment.  
- Designed an **interactive Vendor Performance Dashboard** to track cost, margin, sales, and operational efficiency.  
- Identified **underperforming vendors & brands** and uncovered **profitability gaps** across suppliers, enabling targeted interventions.  
- Delivered **data-backed recommendations** for pricing optimization, vendor negotiations, and inventory management.  


## Tools & Skills
**SQL(PostgreSQL)** | **Python(EDA, Cleaning, Visualization)** | **Power BI** - **DAX** | **Data Modeling** | **ETL** | **Hypothesis Testing** | **Business Analysis** 
 


**Live Dashboard:** [View Power BI Report](your-link-here)  
**Executive Deck:** [View Google Slides](https://docs.google.com/presentation/d/1h2wTZSiAYNN2xwqsaU1r2wTdwOEzAcLZYS8ufUnIp0g/present?slide=id.g3a024b19907_2_96)  
**Full Case Study Below ↓**



# Vendor Performance Analysis (Approach & Findings)
**A Comprehensive Data Analytics Project analyzing vendor performance, inventory efficiency, and cost drivers using PostgreSQL, Python, and Power BI, uncovering actionable insights to optimize procurement, pricing, and operational decisions.**

---

## Business Context
A retail/wholesale company aims to **enhance profitability and operational efficiency** through better vendor and inventory management.  
By leveraging historical **purchase, sales, and pricing** data, the company seeks to uncover cost inefficiencies and vendor performance gaps impacting profitability.

---

## Business Problem
The company struggles to identify **underperforming vendors**, optimize **inventory turnover**, and make **data-driven purchasing decisions**.  
This project aims to:  
- Detect vendors or brands with declining sales or profit margins  
- Understand the effect of **bulk purchasing** on cost efficiency  
- Improve vendor negotiations and inventory control strategies  

---

## Key Challenges
1. **Vendor Performance Gaps** – Lack of visibility into vendor-level profitability and contribution; hard to see which vendors are actually making good profit.  
2. **Fragmented Data Sources** – Purchase, sales, and pricing data are spread across multiple tables, requiring cleaning and joining.  
3. **Cost Variability** – Unclear if bulk purchasing actually reduces unit costs, making cost efficiency hard to assess.

---

## Approach Overview
### **Project-Planning (Framework Used):** SMART & CRISP-DM  
*(Specific | Measurable | Achievable | Relevant | Time Bound)* & (Business Understanding | Data Understanding | Data Preparation | Analysis / Modeling | Evaluation | Deployment)

### **Initial Approach – Joining `purchase_prices`, `sales`, `vendor_invoice`**
- Selected **`purchase_prices`** as the base table to capture all key pricing and volume fields (`Price`, `Volume`, `PurchasePrice`) for each vendor-brand.  
- Attempted to join all three tables directly, but **millions of rows** (especially from `sales` with 12.8+ million rows) caused severe performance issues.

### **Aggregated Table Creation – `vendor_sales_summary`**
- Created **`FreightSummary`**, **`PurchaseSummary`**, and **`SalesSummary`** using **CTEs (Common Table Expressions)** to pre-aggregate data, drastically reducing row count.  
- Built **`vendor_sales_summary`** by joining the CTEs on `VendorNumber` and `Brand`, combining freight, purchase, and sales metrics per vendor-brand.  
- Pulled **`vendor_sales_summary`** into **Python via SQLAlchemy + Pandas** for downstream cleaning, EDA, and visualization in VSCode.

### **Data Cleaning & Loading – PostgreSQL → Python → PostgreSQL**

- Connected to the `vendor_sales_summary` table using **SQLAlchemy + Pandas** for cleaning.  
- **Initial data inspection**: checked column types (`df.dtypes`), null values (`df.isnull().sum()`), and unique string values (e.g., `VendorName`) to detect inconsistencies.  
- **Handled missing/null values**: filled sales-related nulls with 0 (`df.fillna(0, inplace=True)`) for clean numeric calculations.  
- **Data type corrections**: converted `Volume` to `float64` and stripped whitespace from `VendorName`.  
- **Created calculated columns**:
  - `Gross_Profit = Total_Sales_in_Dollars – Total_Purchase_in_Dollars`  
  - `Profit_Margin = Gross_Profit / Total_Sales_in_Dollars` (handled division by 0)  
  - `Stock_Turnover = Total_Sales_Quantity / Total_Purchase_Quantity`  
  - `Sales_to_Purchase_Ratio = Total_Sales_in_Dollars / Total_Purchase_in_Dollars`  
- **Verified data quality**: ensured no duplicates, checked for negative values, and reviewed descriptive statistics (`df.describe().T`).  
- **Loaded cleaned table back to PostgreSQL**: created `vendor_sales_summary_clean_addedcols` and stored using `df.to_sql(..., if_exists='replace', index=False)` for downstream EDA, visualization, and dashboarding.

### **Data Cleaning & Loading – PostgreSQL → Python → PostgreSQL**

**Workflow:**  
`PostgreSQL → Python (Clean & Feature Engineering) → PostgreSQL (Cleaned Table) → Power BI`

- Connected to the `vendor_sales_summary` table using **SQLAlchemy + Pandas** for cleaning and feature engineering.  
- **Initial data inspection**: checked column types (`df.dtypes`), null values (`df.isnull().sum()`), and unique string values (e.g., `VendorName`) to detect inconsistencies.  
- **Handled missing/null values**: filled sales-related nulls with 0 (`df.fillna(0, inplace=True)`) for clean numeric calculations.  
- **Data type corrections**: converted `Volume` to `float64` and stripped whitespace from `VendorName`.  
- **Created calculated columns**:
  - `Gross_Profit = Total_Sales_in_Dollars – Total_Purchase_in_Dollars`  
  - `Profit_Margin = Gross_Profit / Total_Sales_in_Dollars` (handled division by 0)  
  - `Stock_Turnover = Total_Sales_Quantity / Total_Purchase_Quantity`  
  - `Sales_to_Purchase_Ratio = Total_Sales_in_Dollars / Total_Purchase_in_Dollars`  
- **Verified data quality**: ensured no duplicates, checked for negative values, and reviewed descriptive statistics (`df.describe().T`).  
- **Loaded cleaned table back to PostgreSQL**: created `vendor_sales_summary_clean_addedcols` and stored using `df.to_sql(..., if_exists='replace', index=False)` for downstream EDA, visualization, and dashboarding.

---

## Key Insights
## Business Impact
| **Metric** | **Before** | **After** |
|-------------|-------------|------------|
| Data Quality | Inconsistent & duplicated | Cleaned & standardized dataset |
| Reporting Process | Manual Excel (4–6 hrs/week) | Automated Power BI Dashboard |
| Sales Visibility | Regional only | Company-wide performance overview |
| Decision-Making | Reactive | Proactive & data-driven |

---

## Tools & Techniques
| **Category** | **Used For** |
|---------------|--------------|
| AIMS Grid | Defining Project Purpose, Stakeholders, End Result, Success Critera|
| MySQL | Data exploration & validation |
| Power BI | Data cleaning, modeling & visualization |
| Power Query + DAX | Data transformation & KPI calculations |
| Excel | Initial data view / file imports |
| Data Analysis | Business storytelling & trend diagnosis |

---

## Key Outcomes
---

## Deliverables
- **Executive Deck:** [View Slides](your-slides-link-here)  
- **GitHub README:** [Detailed Project Story](your-readme-link-here)  
- **Interactive Dashboard:** [View Dashboard](your-powerbi-link-here)

---

## Future Enhancements
---

*Developed by Harsh Mishra*  
*Open for Data Analyst / BI opportunities*  
