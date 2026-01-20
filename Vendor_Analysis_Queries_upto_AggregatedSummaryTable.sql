
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




SELECT 
    DISTINCT P."VendorName",
    P."VendorNumber",
    V.total_sales_qty
FROM vendor_sales_summary AS V
JOIN (
    SELECT DISTINCT "VendorNumber", "VendorName"
    FROM purchases
) AS P
    ON V."VendorNo" = P."VendorNumber"
ORDER BY V.total_sales_qty DESC
LIMIT 50;
















