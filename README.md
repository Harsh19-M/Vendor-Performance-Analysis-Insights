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
**SQL(PostgreSQL)** | **Python(Cleaning, EDA, Research & Testing/Visulizations)** | **Power BI - Dashboard Tools & DAX** | **Data Modeling** | **ETL** | **Hypothesis Testing** | **Business Analysis** 
 


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

### **EDA/Research & Analytical Testing**
### **1. Total Sales by Vendor**

#### **Brief Explanation**
We grouped total sales by vendor to identify which suppliers generate the highest revenue.  
This highlights key revenue drivers and potential concentration risk.

#### **Code Used**
```python```
df["Total_Sales_in_Dollars"].describe()

top_sales = (
    df.groupby("VendorName")["Total_Sales_in_Dollars"].sum().nlargest(20)
)
top_sales.plot(kind="barh", figsize=(10, 6))
plt.gca().invert_yaxis()
plt.title("Vendor Sales Total by VendorName")
plt.xlabel("Sales in $")
plt.ylabel("Vendor Name")
plt.show()

#### **Output Summary**

- **Median vendor-brand sales:** \$5,298  
- **75th percentile:** \$28,396  
- **Max single entry:** \$5.1M  

**Top Vendors by Total Sales ($):**
- **DIAGEO NORTH AMERICA INC — \$68.7M**  
- **MARTIGNETTI COMPANIES — \$41.0M**  
- **PERNOD RICARD USA — \$32.3M**  
- **JIM BEAM BRANDS COMPANY — \$31.9M**  
- **BACARDI USA INC — \$25.0M**  
*(full list in bar chart)*

---

#### **Quick Insight**
A small group of vendors accounts for the majority of total sales, showing strong revenue concentration.

---

---


## Key Insights

### **EDA Findings: Key Insights & Recommendations**

1. **Total Sales Distribution Across Vendors**

**Insights**
- A few vendors contribute a disproportionately large share of total sales, indicating strong revenue concentration.  
- Sales distribution is highly uneven, with long-tail vendors contributing minimal volume.  
- The business is exposed to concentration risk if major vendors face supply or operational disruptions.

**Recommendations**
- Strengthen negotiation leverage and strategic relationships with high-volume vendors.  
- Assess mid-tier vendors for growth potential to diversify revenue sources.  
- Explore promotional strategies to expand share for underrepresented vendors.


2. **Gross Profit Contribution by Vendor**

**Insights**
- Gross profit is concentrated among top vendors that also lead in total sales volume.  
- High-performing vendors demonstrate consistent profitability across multiple brands.  
- Lower-tier vendors show minimal profitability due to low volume or suboptimal pricing.

**Recommendations**
- Prioritize high-GP vendors for joint planning, improved terms, and long-term business agreements.  
- Reevaluate low-performing vendors and reassess assortment relevance or pricing structure.  
- Promote historically strong GP brands to maximize margin contribution.


3. **Profit Margin Distribution**

**Insights**
- Most vendors operate within a healthy positive margin range (0–40%).  
- High-margin vendors likely benefit from strong pricing, brand strength, or efficient supply structures.  
- Extreme negative margins were identified but attributed to returns or adjustments rather than systemic issues.

**Recommendations**
- Expand support and visibility for high-margin vendors to grow profit contribution.  
- Work with mid-margin vendors on negotiation, freight optimization, and pricing refinement.  
- Flag extreme negative margin cases for Finance/Operations validation and upstream correction.

**Data Quality Note**
During Profit Margin analysis, a small set of extreme negative outliers (e.g., < –20,000%) were identified. These entries likely reflect returns, manual adjustments, or upstream data entry anomalies. They were retained for transparency because they represent a very small portion of the dataset and do not materially impact vendor rankings or strategic insights. In a real operational environment, these anomalies would be flagged for Finance/Operations review.


4. **Stock Turnover by Vendor**

**Insights**
- Most vendors have a stock turnover between 0.8–2.0, indicating normal inventory movement.
- A few vendors show extremely high turnover (e.g., FLAVOR ESSENCE INC ~59), likely due to fast-moving products or low starting inventory.
- Some vendors have zero or near-zero turnover, which may indicate slow-moving stock or inactive SKUs.

**Recommendations**
- Monitor vendors with very high turnover to ensure supply meets demand and avoid stockouts.
- Investigate vendors with low or zero turnover to optimize inventory or phase out inactive products.
- Adjust purchase planning and warehouse allocation based on turnover trends.


5. **Unit Cost vs. Purchase Quantity**

**Insights**
- Unit costs vary widely, with some very high-cost purchases and many lower-cost bulk purchases.
- Extremely high or low unit costs may indicate small sample purchases, special SKUs, or pricing anomalies.

**Recommendations**
- Review outlier unit costs to confirm data accuracy and check for unusual pricing.
- Negotiate pricing or bundle options for high-cost low-volume purchases.
- Use unit cost insights to inform inventory and vendor negotiations.


6. **Sales-to-Purchase Ratio**

**Insights**
- Most vendors sell 1–3 times their purchase quantity, indicating typical resale rates.
- Some vendors have very high ratios (e.g., FLAVOR ESSENCE INC ~86), showing high efficiency or rapid turnover.
- A few vendors have ratios near zero, indicating stock may not be selling or purchases were not converted into sales.

**Recommendations**
- Support high-performing vendors to scale up successful SKUs.
- Review low-performing vendors to identify underperforming products or adjust purchasing strategy.
- Track sales-to-purchase trends for vendor performance benchmarking.


7. **Gross Profit Variability – Top 15 Vendors**

**Insights**
- Top vendors generate the majority of total sales, but gross profit varies significantly across brands/products.
- Some vendors occasionally have very high or very low profits, reflecting inconsistent performance.
- Consistently high-GP vendors provide reliable contribution to overall profitability.

**Recommendations**
- Focus on stabilizing supply, pricing, and promotions for vendors with high variability.
- Prioritize long-term partnerships with consistently high-GP vendors.
- Investigate occasional extreme losses for certain brands/products to prevent repeated impact on gross profit.


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
