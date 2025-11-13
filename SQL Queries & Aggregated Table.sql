
/*Initial EDA to explore and Understand the DataSets based on - The Business Problem Statement: 
Find out there is a need to create any Aggregated tables that help with Vendor Selection for Profitability Product Pricing Optimization*/

SELECT *
FROM begin_inventory
LIMIT 5;

SELECT *
FROM end_inventory
LIMIT 5;

SELECT *
FROM purchase_prices
LIMIT 5;

SELECT *
FROM purchases
LIMIT 5;

SELECT *
FROM sales
LIMIT 5;

SELECT *
FROM vendor_invoice
LIMIT 5;

/*Right so running these 6 basic queries above let us know the column headers/titles/names AND SOME quick things we can see/pick up on are:
- That all the 4 tables purchase_prices, purchases, sales, vendor_invoice 
- These 4 tables all have these 2 specific columns--> Vendor Number/No and Vendor Name - in them BUT begin_inventory table AND end_inventory table DO NOT have these 2 columns 
- and the whole project is about Vendor Performance Analysis so we might not keep use these 2 tables in our Analysis.
*/


/*Let's now look at each individual table - Lets just choose one single vendor - and see How the table - information - data has been stored for the VendorNumber/Name 
(Otherwise the quereis would take way too much time to load especially the sales table which has 12.8 Million+ rows)
- This should give us an idea of all other vendors too

Lets choose one single vendor and see how the information has been stored: 
For eg; We pick VendorNumber 4466
- This should give us an idea of all other vendors too
*/

select *
from sales 
where "VendorNo" = 4466;


select * 
from purchases 
where "VendorNumber" = 4466;


select *
from purchase_prices 
where "VendorNumber" = 4466;

/*purchase_prices → reference table (defines valid price per brand) BUT purchases → transactional table (each purchase event)*/

select *
from vendor_invoice
where "VendorNumber" = 4466;




/*Lets get the Sum of Quantity, Sum of Dollars by Brand and PurchasePrice for our chosen Vendor*/

select "Brand", "PurchasePrice", sum("Quantity") as "Total Quantity", sum("Dollars") as "Total Dollars"
from purchases 
where "VendorNumber" = 4466
group by "Brand", "PurchasePrice";



/* Moving forward to the Vendor_invoice table - with our chosen Vendor - 4466 */

select *
from vendor_invoice
where "VendorNumber" = 4466;
/*So there's a column called "PONumber" - Purchase Order Number */

select count(distinct "PONumber") as "Count of Distinct PONumber", count("PONumber") as "Total PONumber"
from vendor_invoice 
where "VendorNumber" = 4466;
/*Result: 55 - So we can confirm */


select table_schema, table_name, column_name
from information_schema.columns
where table_name in ('vendor_invoice', 'purchases', 'purchase_prices')
group by table_schema, table_name, column_name  /* This helped organize it table by table */

/*We can notice that the Purchases Table has a mix of both the vendor_invoice table AND the
purchase_prices table*/



/*Now lets try to group the sales table on brands - ONLY for VendorNo: 4466 */
select "Brand", "VendorNo", sum("SalesDollars") as "Sum of Sales Dollars", 
sum("SalesPrice")as "Sum of Sales Dollars", 
sum("SalesQuantity") as "Sum of Sales Dollars"

from sales
where "VendorNo" = 4466
group by "Brand", "VendorNo"




/* Working with our 4 relevant tables: vendor_invoice, purchases, purchase_prices, sales */


/* Our vendor_invoice Table Lets get the Freight Cost for each Single Vendor*/

select "VendorNumber", sum("Freight") as "Freight Cost"
from vendor_invoice 
group by "VendorNumber"
order by "VendorNumber" asc;

/* For Better looking Rounded off results: */
select "VendorNumber", round(sum("Freight")::numeric, 2) as "Freight Cost"
from vendor_invoice 
group by "VendorNumber"
order by "VendorNumber" asc;



/* We will Join the purchases table and the purchase_prices table joining on Brand */

select P."VendorNumber", P."VendorName", P."Brand", P."PurchasePrice", pp."Volume", 
pp."Price" as "Actual Price", sum(P."Quantity") as "Total_Purchase_Qty", 
sum(P."Dollars") as "Total_Purchase_in_Dollars"

from purchase_prices as pp
join purchases as P on pp."Brand" = P."Brand"
group by P."VendorNumber", P."VendorName", P."Brand", P."PurchasePrice", pp."Volume", pp."Price"
order by "Total_Purchase_in_Dollars" asc;

/*So for some reason there was a value where the Purchase_Price, Actual Price, Total_Purchase_in_Dollars are 0 
like how are all three values = 0 BUT Total_Purchase_Qty is 2015 - How and why are Quantities sold
but price are all 0? So clearly incorrect input or misleading values - so we must filter them out*/

/* NEW Filtered out where Purchase price more than 0 */

select P."VendorNumber", P."VendorName", P."Brand", P."PurchasePrice", pp."Volume", 
pp."Price" as "Actual_Price", sum(P."Quantity") as "Total_Purchase_Qty", 
sum(P."Dollars") as "Total_Purchase_in_Dollars"

from purchase_prices as pp
join purchases as P on pp."Brand" = P."Brand"
where P."PurchasePrice" > 0
group by P."VendorNumber", P."VendorName", P."Brand", P."PurchasePrice", pp."Volume", pp."Price"
order by "Total_Purchase_in_Dollars" asc;



/*Finally - lets take relevant data from the sales table*/

select "VendorNo", "Brand", sum("SalesQuantity") as "Total_Sales_Qty", 
sum("SalesDollars") as "Total_Sales_Dollars", sum("SalesPrice") as "Total_Sales_Price", 
sum("ExciseTax") as "Total_Excise_Tax"
from sales 
group by "VendorNo", "Brand"
Order by "Total_Sales_Dollars";



/* Base Table Selection & WORKING ON our Final Aggregated table: */

/* Base Table Selection – purchase_prices vs purchases: 
Used `purchase_prices` as the base table since it contained all key pricing fields 
(`Price`, `Volume`, `PurchasePrice`) needed for analysis, unlike `purchases`.

`Quantity` and `Dollars` columns were present in both the purchases table and the vendor_invoice table 
So it was an easier choice to pick the vendor_invoice - `Quantity` and `Dollars` columns */

/* AGGREGATED TABLE - SO lets perform a join on purchase_prices table, sales table and vendor_invoice table*/

select pp."VendorNumber", pp."Brand", pp."PurchasePrice" as "", pp."Price" as "Actual_Price", 
sum(S."SalesQuantity") as "Total_Sales_Qty", sum(S."SalesDollars") as "Total_Sales_Dollars", 
sum(S."SalesPrice") as "Total_Sales_Price", sum(S."ExciseTax") as "Total_Excise_Tax",
sum(Vi."Quantity") as "Total_Purchase_Quantity", sum(Vi."Dollars") as "Total_Purchase_Dollars", 
sum(Vi."Freight") as "Total_Freight_Cost"

from purchase_prices as pp
join sales as S on S."VendorNo" = pp."VendorNumber" and S."Brand" = pp."Brand"
join vendor_invoice as Vi on pp."VendorNumber" = Vi."VendorNumber"
group by pp."VendorNumber", pp."Brand", pp."PurchasePrice", pp."Price";

/*RESULT: ^^Kept Buffering^^ */

/*So initially I Tried to just simply join all 3 of these tables we created above BUT 
that did not run due to much of Memory Usage - SO we made use of CTEs(With - As) */


/*SO that^^ obviously didn't work*/
/*I will make use of CTEs to create 3 summary tables*/
/*Creating our 3 Summary tables - to be joined in order to create our Aggregated Table*/

With FreightSummary as(

	select vi."VendorNumber", sum(vi."Freight") as "Freight_Cost"
	from vendor_invoice as vi
	group by "VendorNumber"

),

 PurchaseSummary as(

	select P."VendorNumber", P."VendorName", P."Brand", P."Description", P."PurchasePrice", 
	sum(P."Quantity") as "Total_Purchase_Quantity", sum(P."Dollars") as "Total_Purchase_in_Dollars", 
	pp."Price" as "Actual_Price", pp."Volume"
	
	from purchases as P
	join purchase_prices as pp on pp."Brand" = P."Brand"
	where P."PurchasePrice" > 0
	group by P."VendorNumber", P."VendorName", P."Brand", P."Description", P."PurchasePrice", 
	pp."Price", pp."Volume"
	
),

 SalesSummary as (

 	select ss."VendorNo", ss."Brand", sum(ss."SalesQuantity") as "Total_Sales_Quantity",
	sum(ss."SalesDollars") as "Total_Sales_in_Dollars", sum(ss."SalesPrice") as "Total_Sales_Price",
	sum(ss."ExciseTax") as "Total_Excise_Tax"
	
	from sales as ss
	group by ss."VendorNo", ss."Brand"
 
 ),

 Vendor_Sales_Aggregated as(

	select ps."VendorNumber", ps."VendorName", ps."Brand", ps."Description", ps."PurchasePrice", 
	ps."Actual_Price", ps."Volume", ps."Total_Purchase_Quantity", ps."Total_Purchase_in_Dollars",
	ss."Total_Sales_Quantity",ss."Total_Sales_in_Dollars", ss."Total_Sales_Price", ss."Total_Excise_Tax",
	fs."Freight_Cost"

	from PurchaseSummary as ps
	left join SalesSummary as ss on ss."VendorNo" = ps."VendorNumber" and ss."Brand" = ps."Brand"
	left join FreightSummary as fs on fs."VendorNumber" = ps."VendorNumber"
	order by ps."Total_Purchase_in_Dollars" desc
)

select *
from Vendor_Sales_Aggregated 
order by "Total_Purchase_in_Dollars" desc;





/*We will now create this table: Vendor_Sales_Summary: */


Create table vendor_sales_summary as 

With FreightSummary as(

	select vi."VendorNumber", sum(vi."Freight") as "Freight_Cost"
	from vendor_invoice as vi
	group by "VendorNumber"

),

 PurchaseSummary as(

	select P."VendorNumber", P."VendorName", P."Brand", P."Description", P."PurchasePrice", 
	sum(P."Quantity") as "Total_Purchase_Quantity", sum(P."Dollars") as "Total_Purchase_in_Dollars", 
	pp."Price" as "Actual_Price", pp."Volume"
	
	from purchases as P
	join purchase_prices as pp on pp."Brand" = P."Brand"
	where P."PurchasePrice" > 0
	group by P."VendorNumber", P."VendorName", P."Brand", P."Description", P."PurchasePrice", 
	pp."Price", pp."Volume"
	
),

 SalesSummary as (

 	select ss."VendorNo", ss."Brand", sum(ss."SalesQuantity") as "Total_Sales_Quantity",
	sum(ss."SalesDollars") as "Total_Sales_in_Dollars", sum(ss."SalesPrice") as "Total_Sales_Price",
	sum(ss."ExciseTax") as "Total_Excise_Tax"
	
	from sales as ss
	group by ss."VendorNo", ss."Brand"
 
 ),

 Vendor_Sales_Aggregated as(

	select ps."VendorNumber", ps."VendorName", ps."Brand", ps."Description", ps."PurchasePrice", 
	ps."Actual_Price", ps."Volume", ps."Total_Purchase_Quantity", ps."Total_Purchase_in_Dollars",
	ss."Total_Sales_Quantity",ss."Total_Sales_in_Dollars", ss."Total_Sales_Price", ss."Total_Excise_Tax",
	fs."Freight_Cost"

	from PurchaseSummary as ps
	left join SalesSummary as ss on ss."VendorNo" = ps."VendorNumber" and ss."Brand" = ps."Brand"
	left join FreightSummary as fs on fs."VendorNumber" = ps."VendorNumber"
)

select *
from Vendor_Sales_Aggregated;


/*Table created after like 2 attempts because I had mistakenly added a paranthteses here: Create table vendor_sales_summary as (   <--- */

/*So we just changed 12 million + rows of data - and extracted the meaningful rows and columns and reduced it to 10692 by 14 rows of summarized table - which is GREAT*/
