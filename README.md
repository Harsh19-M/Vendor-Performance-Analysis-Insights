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
*(Specific | Measurable | Achievable | Relevant | Time Bound)* &<br>(Business Understanding | Data Understanding | Data Preparation | Analysis / Modeling | Evaluation | Deployment)

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

### **EDA/Research**

### **1. Total Sales by Vendor**

#### **Brief Explanation**
Grouped total sales by vendor to identify which suppliers generate the highest revenue.  
This highlights key revenue drivers and potential concentration risk.

<details> <summary><b> Key EDA: Code & Output Summary  (Click to Expand)</b></summary>
 
#### **Code Used in ```Python```**
```
# Vendor-level statistical summary
df.groupby("VendorName")["Total_Sales_in_Dollars"].sum().describe()

# Top 20 vendors by total sales
top_sales = (df.groupby("VendorName")["Total_Sales_in_Dollars"].sum().nlargest(20))

top_sales.plot(kind="barh", figsize=(10, 6))
plt.gca().invert_yaxis()
plt.title("Vendor Sales Total by VendorName")
plt.xlabel("Sales in $")
plt.ylabel("Vendor Name")
plt.show()
```

#### **Output Summary**
- **Median vendor sales: $160K**
- **75th percentile: $2.53M**
- **Mean vendor sales: $3.52M**
- **Max vendor sales: $68.7M (DIAGEO NORTH AMERICA INC)**

**Top Vendors by Total Sales ($):**
- **DIAGEO NORTH AMERICA INC — $68.7M**  
- **MARTIGNETTI COMPANIES — $41.0M**  
- **PERNOD RICARD USA — $32.3M**  
- **JIM BEAM BRANDS COMPANY — $31.9M**  
- **BACARDI USA INC — $25.0M**  
*(full list in full Plot/Chart)*
</details> 

### **2. Total Gross Profit by Vendor**

#### **Brief Explanation**
Aggregated *Gross Profit* at the **vendor level** to understand which suppliers drive the most profitability.  
This highlights high-margin partners and flags low- or negative-profit vendors for further review.

<details> <summary><b> Key EDA: Code & Output Summary (Click to Expand)</b></summary>

#### **Code Used in `Python`**
```
df.groupby("VendorName")["Gross_Profit"].sum().describe()

top_VENs_byGP = (
    df.groupby("VendorName")["Gross_Profit"].sum().nlargest(20)
)

top_VENs_byGP.plot(kind="barh", figsize=(10, 6))
plt.gca().invert_yaxis()
plt.title("Top Vendors by Total Gross Profit")
plt.xlabel("Gross Profit ($)")
plt.ylabel("Vendor Name")
plt.show()
```

#### **Output Summary (Vendor-Level)**
- **Count of vendors: 128**
- **Median vendor GP: $33,923**
- **75th percentile: $780,128**
- **Max vendor GP: $17.78M**
- **Min vendor GP: –$9,194 (loss-making vendor)**

**Top Vendors by Total Gross Profit ($)**
- **DIAGEO NORTH AMERICA INC — \$17.78M**  
- **MARTIGNETTI COMPANIES — \$13.09M**  
- **CONSTELLATION BRANDS INC — \$8.89M**  
- **PERNOD RICARD USA — \$8.15M**  
- **JIM BEAM BRANDS COMPANY — \$7.69M**  
*(full list in full Plot/Chart)*
</details>


### **3. Profit Margin by Vendor**

#### **Brief Explanation**
Analyzed vendor-level profit margins to identify high-margin suppliers and detect extreme losses or negative margins.
This helps flag both top-performing and underperforming vendors for operational or pricing review.

<details> <summary><b> Key EDA: Code & Output Summary (Click to Expand)</b></summary>

#### **Code Used in `Python`**
```
# Vendor-level profit margin summary
df["Profit_Margin"].describe()

# Top 60 vendor-margin entries
som = df.head(60)
som[["VendorName", "Profit_Margin"]].values

# Scatter plot of top 60 margins
som.plot(kind="scatter", x="Profit_Margin", y="VendorName")

# Bottom 60 vendor-margin entries
lo = df.tail(60)
lo[["VendorName", "Profit_Margin"]].values

# Scatter plot of bottom 60 margins
lo.plot(kind="scatter", x="Profit_Margin", y="VendorName")
```

#### **Output Summary (Entry-Level)**
- **Count of entries: 10,692** 
- **Mean profit margin: –15.62%** 
- **25th percentile: 13.32%** 
- **75th percentile: 39.96%** 
- **Min: –23,730% (extreme negative outlier)**
- **Max: 99.72%**

**Data Quality Note**
During Profit Margin analysis, a small set of extreme negative outliers (e.g., < –20,000%) were identified. These entries likely reflect returns, manual adjustments, or upstream data entry anomalies. They were retained for transparency because they represent a very small portion of the dataset and do not materially impact vendor rankings or strategic insights. In a real operational environment, these anomalies would be flagged for Finance/Operations review.

**Top Profit Margins (sample of top 5 entries):**
- **PALM BAY INTERNATIONAL INC — 92.64%**  
- **JIM BEAM BRANDS COMPANY — 94.40%**  
- **M S WALKER INC — 83.85%**  
- **LATITUDE BEVERAGE COMPANY — 87.95%**  
- **SOUTHERN WINE & SPIRITS NE — 81.72%**  
*(full list in full Plot/Chart)*

**Bottom Profit Margins (sample of bottom 5 entries / losses):**
- **MARTIGNETTI COMPANIES — -1555.32%**  
- **PHILLIPS PRODUCTS CO. — -1659.91%**  
- **STATE WINE & SPIRITS — -1,500.47%**  
- **DIAGEO CHATEAU ESTATE WINES — -906.60%**  
- **M S WALKER INC — -143.24%**  
*(full list in full Plot/Chart)*
</details>

### **4. Stock Turnover by Vendor**

#### **Brief Explanation**
Calculated the average stock turnover per vendor to identify which suppliers move inventory fastest.
Highlights potential supply chain bottlenecks or overstock risks

<details> <summary><b> Key EDA: Code & Output Summary (Click to Expand)</b></summary>

#### **Code Used in `Python`**
```
# Vendor-level stock turnover summary
df.groupby("VendorName")["Stock_Turnover"].mean().describe()

# Top 25 vendors by stock turnover
STH = df.groupby("VendorName")["Stock_Turnover"].mean().nlargest(25)

STH.plot(kind="bar", figsize=(10, 6))
plt.title("Top 25 Vendors by Stock Turnover")
plt.xlabel("Vendor Name")
plt.ylabel("Average Stock Turnover")
plt.show()

# Bottom 25 vendors by stock turnover
STL = df.groupby("VendorName")["Stock_Turnover"].mean().nsmallest(25)

STL.plot(kind="bar", figsize=(10, 6))
plt.title("Bottom 25 Vendors by Stock Turnover")
plt.xlabel("Vendor Name")
plt.ylabel("Average Stock Turnover")
plt.show()
```

#### **Output Summary**
- **Count of vendors: 128**
- **Mean vendor stock turnover: 1.91**
- **Median vendor stock turnover: 1.07** 
- **25th percentile: 0.86** 
- **75th percentile: 1.64** 
- **Max vendor stock turnover: 59.0 (FLAVOR ESSENCE INC)**
- **Min vendor stock turnover: 0.0 (AAPER ALCOHOL & CHEMICAL CO, LAUREATE IMPORTS CO)** 

**Top Vendors by Average Stock Turnover (sample of top 5):**
- **FLAVOR ESSENCE INC — 59.0**  
- **DISARONNO INTERNATIONAL LLC — 16.89**  
- **MHW LTD — 4.94**  
- **ALISA CARR BEVERAGES — 4.70**
- **MARSALLE COMPANY — 3.64**  
*(full list in full Plot/Chart)*

**Bottom Vendors by Average Stock Turnover (sample of bottom 5):**
- **AAPER ALCOHOL & CHEMICAL CO — 0.0**  
- **LAUREATE IMPORTS CO — 0.0**  
- **TRUETT HURST — 0.042**  
- **VINEYARD BRANDS LLC — 0.26**  
- **HIGHLAND WINE MERCHANTS LLC — 0.30**  
*(full list in full Plot/Chart)*
</details>


### **5. Unit Cost vs Purchase Quantity**

#### **Brief Explanation**
Calculated unit cost per item to analyze pricing trends relative to purchase quantity.
Helps identify bulk-purchase efficiencies or anomalies in unit pricing.

<details> <summary><b> Key EDA: Code & Output Summary (Click to Expand)</b></summary>

#### **Code Used in `Python`**
```
# Calculate unit cost
df["Unit_Cost"] = df["Total_Purchase_in_Dollars"] / df["Total_Purchase_Quantity"]

# Scatter plot of purchase quantity vs unit cost
df.plot(kind="scatter", x="Total_Purchase_Quantity", y="Unit_Cost", figsize=(10, 6))
plt.title("Unit Cost vs Total Purchase Quantity")
plt.xlabel("Total Purchase Quantity")
plt.ylabel("Unit Cost ($)")
plt.show()

# Descriptive stats
df["Total_Purchase_Quantity"].describe()
df["Unit_Cost"].describe()
```

#### **Output Summary**
**Total Purchase Quantity:**
- **Count: 10,692**
- **Mean: 3,141 units**
- **Median: 262 units** 
- **25th percentile: 36 units** 
- **75th percentile: 1,976 units** 
- **Max: 337,660 units**
- **Min: 1 unit** 

**Unit Cost ($):**
- **Count: 10,692**  
- **Mean: $24.39**  
- **Median: $10.46**
- **25th percentile: $6.84**
- **75th percentile: $19.48**
- **Min: $0.36**
- **Max: $5,681.81**

**Observations:**
- Most purchases are moderate quantity (<2,000 units) with unit costs clustered under $20.
- Outliers exist with extremely high unit cost or very large purchase quantities.
- Scatter plot highlights bulk-purchase efficiency and potential anomalies.
</details>


### **6. Sales-to-Purchase Ratio by Vendor**

#### **Brief Explanation**
Calculated the average sales-to-purchase ratio per vendor to evaluate efficiency in converting purchases into sales.
This identifies top-performing vendors and potential underperformers

<details> <summary><b> Key EDA: Code & Output Summary (Click to Expand)</b></summary>

#### **Code Used in `Python`**
```
# Vendor-level statistical summary
df.groupby("VendorName")["Sales_to_Purchase_Ratio"].mean().describe()

# Top 25 vendors by average Sales-to-Purchase Ratio
SRVT = df.groupby("VendorName")["Sales_to_Purchase_Ratio"].mean().nlargest(25)
SRVT.plot(kind="barh", figsize=(10,6))
plt.gca().invert_yaxis()
plt.title("Top Vendors by Sales-to-Purchase Ratio")
plt.xlabel("Sales-to-Purchase Ratio")
plt.ylabel("Vendor Name")
plt.show()

# Bottom 25 vendors by average Sales-to-Purchase Ratio
SRVS = df.groupby("VendorName")["Sales_to_Purchase_Ratio"].mean().nsmallest(25)
SRVS.plot(kind="barh", figsize=(10,6))
plt.gca().invert_yaxis()
plt.title("Lowest Vendors by Sales-to-Purchase Ratio")
plt.xlabel("Sales-to-Purchase Ratio")
plt.ylabel("Vendor Name")
plt.show()
```

#### **Output Summary (Vendor-Level)**
- **Count of vendors: 128**
- **Median ratio: 1.57**
- **75th percentile: 2.33** 
- **Mean ratio: 2.73** 
- **Max ratio: 86.73 (FLAVOR ESSENCE INC)** 
- **Min ratio: 0.00 (AAPER ALCOHOL & CHEMICAL CO, LAUREATE IMPORTS CO)**

**Top 5 Vendors by Sales-to-Purchase Ratio:**
- **FLAVOR ESSENCE INC — 86.73**
- **DISARONNO INTERNATIONAL LLC — 22.26**
- **ALISA CARR BEVERAGES — 7.15**
- **MHW LTD — 6.45**  
- **MARSALLE COMPANY — 4.88**
*(full list in full Plot/Chart)*

**Lowest 5 Vendors by Sales-to-Purchase Ratio:**
- **AAPER ALCOHOL & CHEMICAL CO — 0.00**  
- **LAUREATE IMPORTS CO — 0.00**  
- **TRUETT HURST — 0.06**  
- **VINEYARD BRANDS LLC — 0.38**  
- **BLACK COVE BEVERAGES — 0.43**  
*(full list in full Plot/Chart)*
</details>


### **7. Profit Variability for Top Vendors (Top 15 by Sales)**

#### **Brief Explanation**
Selected the top 15 vendors by total sales and analyzed their gross profit distribution.
This highlights variability and risk across major revenue-generating suppliers.

<details> <summary><b> Key EDA: Code & Output Summary (Click to Expand)</b></summary>

#### **Code Used in `Python`**
```
# Top 15 vendors by total sales
top_vendors = df.groupby("VendorName")["Total_Sales_in_Dollars"].sum().nlargest(15).index
df_top = df[df["VendorName"].isin(top_vendors)]

# Vendor-level gross profit stats for top vendors
df_top.groupby("VendorName")["Gross_Profit"].describe()

# Boxplot for profit variability
plt.figure(figsize=(12,6))
df_top.boxplot(column="Gross_Profit", by="VendorName", rot=90)
plt.title("Profit Variability for Top Vendors")
plt.suptitle("")  # removes default pandas "Boxplot grouped by ..."
plt.xlabel("Vendor")
plt.ylabel("Gross Profit ($)")
plt.show()
```

#### **Output Summary (Top 15 Vendors)**

**Top 5 (all 15 in Graph) vendor by total sales:**
- **DIAGEO NORTH AMERICA INC — $68.7M**
- **MARTIGNETTI COMPANIES — $40.96M**
- **PERNOD RICARD USA — $32.28M**
- **JIM BEAM BRANDS COMPANY — $31.89M**
- **BACARDI USA INC — $25.01M**

Gross profit variability: wide range across top vendors (boxplot shows min, max, median, and quartiles for each)
Insight: Some high-sales vendors show large profit variability, highlighting potential volatility or inconsistent margins

(Full boxplot visually shows variability across all top 15 vendors)
</details>


## **Analytical Testing**

### **Test #1 — Does Bulk Purchasing Reduce Unit Cost? (Summary)**

**Objective:**
Check whether buying larger quantities leads to **lower unit cost**, i.e., whether bulk purchasing behavior actually results in cost advantages.

**Approach:**

* Compared `Total_Purchase_Quantity` vs `Unit_Cost`.
* Calculated both **Pearson** (linear relationship) and **Spearman** (monotonic relationship) correlations.
* Evaluated whether higher purchase quantities consistently correspond to lower unit costs.

**Key Findings:**

* **Pearson = –0.038** → *Almost no linear relationship.*
* **Spearman = –0.274** → *Weak downward trend.*

Both metrics agree: the effect exists **slightly**, but it's **not strong**.

**Interpretation:**

* Bulk purchases **sometimes** result in lower unit costs, but **not reliably**.
* Discounts, vendor pricing rules, and product categories vary too much for a consistent pattern.
* The trend is visible but **weak**, and not strong enough to form a general rule across the dataset.

**Implication:**

* Bulk-buying **might** save money, but only for specific vendors/products.
* To get real insights, you need **vendor-level and category-level breakdowns** to identify where volume-based pricing actually applies.

**Conclusion:**
Bulk purchasing offers **possible**, but not guaranteed, cost benefits. The dataset shows a **weak** correlation, suggesting that buying more doesn’t always lead to better unit pricing.


### **Test #2 — Correlation Between Vendor Sales & Profit (Summary)**

**Objective:**
Evaluate whether vendors who generate higher **total sales** also contribute higher **gross profit**, helping identify if revenue and profitability move together across the Vendor portfolio.

**Approach:**

* Calculated **Total Sales** and **Total Gross Profit** per vendor.
* Built a correlation matrix using these aggregated fields.
* Reviewed the strength and direction of the relationship.

**Key Finding:**

* The correlation between **Total Sales** and **Total Gross Profit** is extremely strong:
  **r = 0.9907**
* This indicates an almost perfectly **positive linear relationship** — vendors who sell more nearly always generate more gross profit.

**Implication:**

* High-revenue vendors are consistently your high-profit vendors.
* This means future vendor evaluation models can safely treat revenue as a strong proxy for profitability — helpful for rankings, forecasting, or prioritizing strategic vendor relationships.

**Conclusion:**
Test #2 confirms that **Sales ↔ Profit** in this dataset move together very tightly. Vendor performance decisions can rely on this pattern with high confidence.

---

## Key Insights

### **Key Insights & Findings:**

<details> <summary><b> EDA Findings: Key Insights & Recommendations (Click to Expand)</b></summary>

### **1. Total Sales Distribution Across Vendors**

**Insights**
- A few vendors contribute a disproportionately large share of total sales, indicating strong revenue concentration.  
- Sales distribution is highly uneven, with long-tail vendors contributing minimal volume.  
- The business is exposed to concentration risk if major vendors face supply or operational disruptions.

**Recommendations**
- Strengthen negotiation leverage and strategic relationships with high-volume vendors.  
- Assess mid-tier vendors for growth potential to diversify revenue sources.  
- Explore promotional strategies to expand share for underrepresented vendors.


### **2. Gross Profit Contribution by Vendor**

**Insights**
- Gross profit is concentrated among top vendors that also lead in total sales volume.  
- High-performing vendors demonstrate consistent profitability across multiple brands.  
- Lower-tier vendors show minimal profitability due to low volume or suboptimal pricing.

**Recommendations**
- Prioritize high-GP vendors for joint planning, improved terms, and long-term business agreements.  
- Reevaluate low-performing vendors and reassess assortment relevance or pricing structure.  
- Promote historically strong GP brands to maximize margin contribution.


### **3. Profit Margin Distribution**

**Insights**
- Most vendors operate within a healthy positive margin range (0–40%).  
- High-margin vendors likely benefit from strong pricing, brand strength, or efficient supply structures.  
- Extreme negative margins were identified but attributed to returns or adjustments rather than systemic issues.

**Recommendations**
- Expand support and visibility for high-margin vendors to grow profit contribution.  
- Work with mid-margin vendors on negotiation, freight optimization, and pricing refinement.  
- Flag extreme negative margin cases for Finance/Operations validation and upstream correction.

### **4. Stock Turnover by Vendor**

**Insights**
- Most vendors have a stock turnover between 0.8–2.0, indicating normal inventory movement.
- A few vendors show extremely high turnover (e.g., FLAVOR ESSENCE INC ~59), likely due to fast-moving products or low starting inventory.
- Some vendors have zero or near-zero turnover, which may indicate slow-moving stock or inactive SKUs.

**Recommendations**
- Monitor vendors with very high turnover to ensure supply meets demand and avoid stockouts.
- Investigate vendors with low or zero turnover to optimize inventory or phase out inactive products.
- Adjust purchase planning and warehouse allocation based on turnover trends.


### **5. Unit Cost vs. Purchase Quantity**

**Insights**
- Unit costs vary widely, with some very high-cost purchases and many lower-cost bulk purchases.
- Extremely high or low unit costs may indicate small sample purchases, special SKUs, or pricing anomalies.

**Recommendations**
- Review outlier unit costs to confirm data accuracy and check for unusual pricing.
- Negotiate pricing or bundle options for high-cost low-volume purchases.
- Use unit cost insights to inform inventory and vendor negotiations.


### **6. Sales-to-Purchase Ratio**

**Insights**
- Most vendors sell 1–3 times their purchase quantity, indicating typical resale rates.
- Some vendors have very high ratios (e.g., FLAVOR ESSENCE INC ~86), showing high efficiency or rapid turnover.
- A few vendors have ratios near zero, indicating stock may not be selling or purchases were not converted into sales.

**Recommendations**
- Support high-performing vendors to scale up successful SKUs.
- Review low-performing vendors to identify underperforming products or adjust purchasing strategy.
- Track sales-to-purchase trends for vendor performance benchmarking.


### **7. Gross Profit Variability – Top 15 Vendors**

**Insights**
- Top vendors generate the majority of total sales, but gross profit varies significantly across brands/products.
- Some vendors occasionally have very high or very low profits, reflecting inconsistent performance.
- Consistently high-GP vendors provide reliable contribution to overall profitability.

**Recommendations**
- Focus on stabilizing supply, pricing, and promotions for vendors with high variability.
- Prioritize long-term partnerships with consistently high-GP vendors.
- Investigate occasional extreme losses for certain brands/products to prevent repeated impact on gross profit.

</details>

---

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
