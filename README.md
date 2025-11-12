# Vendor Performance Analysis
End-to-end **Vendor Performance Analysis** project using **SQL** (data exploration, joins, and aggregation), **Python** (EDA, data cleaning, and research analysis), and **Power BI** (interactive dashboards and reporting) to identify top-performing vendors, optimize inventory efficiency, and uncover actionable business insights.  

---

## Key Highlights
- Built a complete **end-to-end data analytics pipeline**: connected and queried PostgreSQL tables → cleaned, aggregated, and analyzed data in Python → visualized and modeled insights in Power BI for actionable business decisions.  
- Designed an **interactive Vendor Performance Dashboard** to track cost, margin, sales, and operational efficiency.  
- Identified **underperforming vendors & brands** and uncovered **profitability gaps** across suppliers, enabling targeted interventions.  
- Delivered **data-backed recommendations** for pricing optimization, vendor negotiations, and inventory management.  
- Applied structured **project planning frameworks**: **SMART** goals for objectives and **CRISP-DM** methodology for step-by-step data analysis, from business understanding → data preparation → modeling → evaluation → deployment.  

---

## Tools & Skills
| **SQL(PostgreSQL)** | **Python(EDA, Cleaning, Visualization)** | **Power BI** - **DAX** | **Data Modeling** | **ETL** | **Hypothesis Testing** | **Business Analysis** |

---

📊 **Live Dashboard:** [View Power BI Report](your-link-here)  
🎯 **Executive Deck:** [View Google Slides](your-link-here)  
📘 **Full Case Study Below ↓**

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

## ⚙️ Key Challenges
1. **Vendor Performance Gaps** – Lack of visibility into vendor-level profitability and contribution; hard to see which vendors are actually making good profit.  
2. **Fragmented Data Sources** – Purchase, sales, and pricing data are spread across multiple tables, requiring cleaning and joining.  
3. **Cost Variability** – Unclear if bulk purchasing actually reduces unit costs, making cost efficiency hard to assess.

---

## Approach Overview
**Framework Used:** SMART & CRISP DM 
*(Specific | Measurable | Achievable | Relevant | Time Bound)* & (Business Understanding | Data Understanding | Data Preparation | Analysis / Modeling | Evaluation | Deployment)

### **Base Table Selection – `purchase_prices` vs `purchases`**

* Both tables had vendor details (`VendorNumber`, `Brand`, `PurchasePrice`), but `purchase_prices` also included key fields like `Price` and `Volume`.
* Since all brands in `purchase_prices` appeared in `purchases`, we used `purchase_prices` as the **base table** to capture complete pricing details before joining with other tables for analysis.

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
