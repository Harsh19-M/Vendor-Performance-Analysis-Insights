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
