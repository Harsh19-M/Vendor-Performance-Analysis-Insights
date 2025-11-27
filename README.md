# Vendor Performance Analysis & Insights
End-to-end **Vendor Performance Analysis** project using **SQL** (data exploration, joins, and aggregation), **Python** (EDA, data cleaning, and research analysis), and **Power BI** (interactive dashboards and reporting) to identify top-performing vendors, optimize inventory efficiency, and uncover actionable business insights.  


## Key Highlights
- Built a complete **end-to-end data analytics pipeline**: connected and queried PostgreSQL tables, aggregating millions of rows into a 10,692-row summary table using CTEs; performed initial exploration, data cleaning, 7-step EDA, and 4 targeted business tests in Python based on the problem statement and key challenges; and visualized and modeled insights in Power BI, creating 3 dashboard pages, each addressing a specific key challenge to enable actionable business decisions.
- Aggregated massive datasets **(millions of rows)** from `vendor_invoice`, `purchases`, and `sales` table **(12.8+ million rows)** into a single **`vendor_sales_summary`** table of **10,692 rows** using **CTEs (Common Table Expressions)** to pre-aggregate freight, purchase, and sales metrics per vendor-brand, enabling faster, actionable analysis.
- Performed EDA & Analytical Testing → Bulk Buying ≠ Guaranteed Savings(weak Correlation), high-sales vendors = generate high profit, identified underperforming brands for action, and segmented SKUs(Stock keeping unit) to reveal star vs slow-moving products for strategic inventory decisions.
- Applied structured **project planning frameworks**: **SMART** goals for objectives and **CRISP-DM** methodology for step-by-step data analysis, from business understanding → data preparation → modeling → evaluation → deployment.
- Built an **interactive Vendor Performance Dashboard** that pinpointed **underperforming vendors/brands**, exposed **profitability gaps**.
- Delivered **Data-driven recommendations** for pricing optimization, vendor negotiations, and inventory management.

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

### **Test #1: Does Bulk Purchasing Reduce Unit Cost?**

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


### **Test #2: Correlation Between Vendor Sales & Profit**

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


### Test #3: Underperforming Brands (Low Sales / Low Profit SKUs)

**Goal:**
Find brands that are dragging overall performance so the business can take action — adjust prices, run promotions, or consider delisting.

**Method:**

* Calculated **Z-scores** for `total_sales_dollars` and `total_G_P` per brand.
* Flagged brands that are **more than 1 standard deviation below the mean** in either sales or profit.

**Findings:**

Only 2 brands in the dataset met the underperforming criteria.
Both had profit significantly below average (Z < –1).
Sales for these brands were slightly below average but not extreme (Z ~ –0.13).

* Brands with **Profit_Z < -1** or **Sales_Z < -1** are considered underperforming.
* From the dataset:
  * Brand 2277 - Kilbeggan Irish Whiskey (Brand 2277) → low profit (Profit_Z = -1.39), sales not too low (Sales_Z = -0.131460)
  * Brand 4785 - Remy Martin XO Excellence (Brand 4785) → low profit (Profit_Z = -1.09), sales not too low (Sales_Z = -0.125717)

**Business Implication:**

* These brands may require **promotions, price adjustments, or vendor renegotiations**.
* Acting on this helps improve overall profitability and reduces wasted investment in low-performing SKUs.

**Verdict:**
Successfully identified all underperforming brands based on sales and profit.


### **Test #4: SKU Performance Segmentation**

**Objective:**
Segment SKUs by **turnover and profit** to identify which products are driving revenue and which may be underperforming, helping inform **inventory and vendor strategies**.

**Approach:**

* Classified each SKU into **three performance segments** based on sales and gross profit:

  1. **High Turnover / High Profit** – top-performing SKUs.
  2. **Low Turnover / High Profit** – profitable but slower-selling SKUs.
  3. **Low Turnover / Low Profit** – underperforming SKUs.
* Summed the number of SKUs in each segment across all vendors.
* Calculated each segment as a **percentage of total SKUs**.

**Findings:**

| Performance Segment         | Total SKUs | % of Total SKUs |
| --------------------------- | ---------- | --------------- |
| High Turnover / High Profit | 1,037      | 13.1%           |
| Low Turnover / High Profit  | 5,564      | 70.4%           |
| Low Turnover / Low Profit   | 1,312      | 16.6%           |
| **Total**                   | 7,913      | 100%            |

**Interpretation:**

* Most SKUs (70%) fall into **Low Turnover / High Profit**, meaning many products generate good profit but move slowly.
* Only a small portion (13%) are both high turnover and high profit, representing **true star products**.
* Around 17% of SKUs are low performing in both dimensions and may need **promotion, price adjustment, or delisting**.

**Business Implication:**

* Inventory and vendor management can **focus on star SKUs** while monitoring slow-moving profitable items.
* Underperforming SKUs require **strategic intervention** to improve overall profitability and optimize stock levels.

**Conclusion:**
Test #4 provides a **clear performance segmentation** of SKUs. It highlights which products are key revenue drivers, which are slow movers, and which may be dragging down performance, enabling **data-driven inventory and vendor decisions**.

---

## Key Insights
- **Bulk Purchasing ≠ Guaranteed Savings:** Weak correlation; volume discounts only for select vendors/products.
- **High Sales → High Profit:** Vendors with high sales consistently generate high gross profit (r = 0.99).
- **Underperforming Brands:** 2 brands flagged for low profit; candidates for promotions or vendor renegotiation.
- **SKU Segmentation:** Most SKUs are low-turnover/high-profit; ~13% are true star products.
- **Stock Turnover:** Most vendors normal; extremes indicate fast-moving products or inactive SKUs.
- **Sales-to-Purchase Ratio:** High-performing vendors efficiently convert purchases to sales; low ratios highlight inefficiencies.
- **Profit Variability in Top Vendors:** Some top vendors show inconsistent gross profits, highlighting areas for optimization.

---

## Business Impact

| **Metric**                | **Before**                                                        | **After**                                                                             |
| ------------------------- | ----------------------------------------------------------------- | ------------------------------------------------------------------------------------- |
| Data Quality              | Fragmented, inconsistent, and unvalidated                         | Cleaned, standardized, and enriched dataset in `vendor_sales_summary_clean_addedcols` |
| Reporting Process         | Manual table joins, Excel summaries                               | Automated PostgreSQL → Python → Power BI workflow with dashboards                     |
| Sales & Profit Visibility | Hard to identify top-performing or underperforming vendors/brands | Clear, interactive company-wide vendor & SKU performance view                         |
| Decision-Making           | Reactive; intuition-driven                                        | Proactive, data-backed decisions on vendor negotiations, inventory, and pricing       |
| Inventory Optimization    | Blind spots in turnover & SKU performance                         | Identified star SKUs, slow movers, and underperforming brands for strategic action    |
| Cost Efficiency           | Bulk purchase impact unclear                                      | Verified bulk purchase effect, unit cost trends, and profitability gaps               |

---

## Tools & Techniques 
| **Category**                              | **Used For**                                                                   |
| ----------------------------------------- | ------------------------------------------------------------------------------ |
| SQL (PostgreSQL)                          | Data aggregation, joins, and pre-aggregation of millions of rows               |
| Python (Pandas, NumPy, Matplotlib)        | Data cleaning, EDA, hypothesis testing, calculated metrics                     |
| Power BI                                  | Interactive dashboards, KPI tracking, and business reporting                   |
| Data Modeling & ETL                       | Built `vendor_sales_summary` table; cleaned & enriched data                    |
| Hypothesis Testing & Correlation Analysis | Bulk purchasing effect, sales-profit correlation, SKU/brand analysis           |
| Business Frameworks (SMART & CRISP-DM)    | Structured project planning, analysis workflow, and actionable recommendations |


---

## Key Outcomes
- Created a single source of truth for vendor & SKU performance across sales, profit, turnover, and purchase data.
- Built a Power BI dashboard enabling real-time visibility of vendor profitability, inventory efficiency, and sales-to-purchase ratios.
- Identified high-performing vendors and star SKUs to prioritize strategic partnerships and promotions.
- Flagged underperforming vendors and brands for pricing review, promotions, or potential delisting.
- Delivered data-backed recommendations to improve inventory planning, vendor negotiations, and cost efficiency.
  
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
