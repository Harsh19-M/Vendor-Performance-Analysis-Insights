
/*So we will Perform EDA to explore and Understand the DataSets 
According to/Based on - our Business Problem Statement: If there is a need to create any Aggregated tables that help with
Vendor Selection for Profitability
Product Pricing Optimization*/

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


/*Right so running these 6 basic queries above let us know the column headers/titles/names AND
SOME quick things we can see/pick up on are:

- That all the 4 tables purchase_prices, purchases, sales, vendor_invoice - 
these 4 tables all have these 2 specific columns--> Vendor Number/No and Vendor Name - in them 
BUT begin_inventory AND end_inventory tables DO NOT have these 2 columns - and 
the whole project is about Vendor Performance Analysis so we might not keep use these 2 tables in our Analysis.

AND 

- All the Columns that are present in purchase_prices are also there in the purchases table - IDK about this NOW
*/

SELECT P."VendorName", P."VendorNumber", pp."Price", P."PurchasePrice", P."Dollars", P."Quantity", pp."Volume"
FROM purchases AS P
JOIN purchase_prices as pp ON pp."VendorName" = P."VendorName"
LIMIT 5;


Select count(*)
From purchases;


Select count(*)
From sales;


/*Let's now look at each individual table and gather basic insights*/
/*Lets just choose one single vendor - and see How the table - information - data has been stored 
- This should give us an idea of all other vendors too*/


SELECT distinct P."VendorName", P."VendorNumber"
FROM purchases as P
JOIN purchase_prices as pp ON P."Brand" = pp."Brand"



SELECT P."VendorName", P."VendorNumber", sum(S."SalesQuantity") as "Total Sales Qty"
FROM purchases as P
JOIN sales as S ON S."VendorNo" = P."VendorNumber"
GROUP BY P."VendorName", P."VendorNumber"
Order by "Total Sales Qty" desc
LIMIT 50;



CREATE TEMP TABLE vendor_sales_summary AS
SELECT 
    "VendorNo",
    SUM("SalesQuantity") AS total_sales_qty
FROM sales
GROUP BY "VendorNo";


SELECT 
    P."VendorName",
    P."VendorNumber",
    V.total_sales_qty
FROM vendor_sales_summary AS V
JOIN purchases AS P
    ON V."VendorNo" = P."VendorNumber"
ORDER BY V.total_sales_qty DESC
LIMIT 50;

/*This ^^ here gave us like 50 rows of just our top vendor with the name, no, Qty 
but we want top 50 distinct ones*/


/*SO this is how (Limit 50): */

SELECT DISTINCT P."VendorName",P."VendorNumber",V.total_sales_qty
FROM vendor_sales_summary AS V
JOIN (
    SELECT DISTINCT "VendorNumber", "VendorName"
    FROM purchases) AS P ON V."VendorNo" = P."VendorNumber"
	
ORDER BY V.total_sales_qty DESC
LIMIT 50;


/*(Limit 100) */
SELECT DISTINCT P."VendorName",P."VendorNumber",V.total_sales_qty
FROM vendor_sales_summary AS V
JOIN (
    SELECT DISTINCT "VendorNumber", "VendorName"
    FROM purchases) AS P ON V."VendorNo" = P."VendorNumber"
	
ORDER BY V.total_sales_qty DESC
LIMIT 100;



/*Lets choose one single vendor and see how the information has been stored: 
For eg; We pick VendorNumber 4466
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

/*
purchase_prices → reference table (defines valid price per brand)

purchases → transactional table (each purchase event)

When you merge them once, you can safely keep using purchases after that, 
since it now carries everything you need.*/

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

/*So there's a column called PONumber - Purchase Order Number (Most likely)*/

select count(distinct "PONumber") as "Count of Distinct PONumber", count("PONumber") as "Total PONumber"
from vendor_invoice 
where "VendorNumber" = 4466;

/*Result: 55 - So we can confirm there ar*/



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
like how are all three values = 0 BUT Total_Purchase_Qty is more than 0 --> 2015 - How and why are Quantities sold
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





/* Base Table Selection - WORKING ON our Final Aggregated table: */

/* Base Table Selection – purchase_prices vs purchases: 
Used `purchase_prices` as the base table since it contained all key pricing fields 
(`Price`, `Volume`, `PurchasePrice`) needed for analysis, unlike `purchases`.*/


/* SO lets perform a join on purchase_prices table, sales table and vendor_invoice table*/


select *
from purchase_prices 
limit 5;

select * 
from sales 
limit 5;

select *
from vendor_invoice
limit 5;



select pp."VendorNumber", pp."Brand", pp."PurchasePrice", pp."Price", sum(S."SalesQuantity"), 
sum(S."SalesDollars"), sum(S."SalesPrice"), sum(S."ExciseTax")

from purchase_prices as pp
join sales as S on S."VendorNo" = pp."VendorNumber" and S."Brand" = pp."Brand"
join vendor_invoice as Vi on pp."VendorNumber" = Vi."VendorNumber"
limit 15

/*So initially we Tried to just simply join all 3 of these tables we created above BUT 
that did not run due to much of Memory Usage - SO we made use of CTEs(With - As) */



