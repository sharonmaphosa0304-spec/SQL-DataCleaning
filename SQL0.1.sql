select*
from dbo.histproductdemand

select Product_Code, count(Product_Code) as num
from dbo.histproductdemand
group by  Product_Code


--breaking into individual columnws


select prodate,convert(date,Datepro) 
from dbo.histproductdemand

update dbo.histproductdemand
set Datepro = CONVERT(Date,Datepro)

alter table dbo.histproductdemand
add prodate date;

update dbo.histproductdemand
set prodate = CONVERT(Date,Datepro)

select*
from dbo.histproductdemand

--removing duplicates

with RowNumCTE as (
select *,
    row_number()over(
    partition by Product_Code,	Warehouse,Product_Category,Order_Demand,prodate
	order by Product_code) row_num
from dbo.histproductdemand
)
select*
from RowNumCTE
where row_num>1
order by Product_Code
  
with RowNumCTE as (
select *,
    row_number()over(
    partition by Product_Code,	Warehouse,Product_Category,Order_Demand,prodate
	order by Product_code) row_num
from dbo.histproductdemand
)
delete
from RowNumCTE
where row_num>1
--order by Product_Code 

select*
from dbo.histproductdemand

--delete unused columns

select*
from dbo.histproductdemand

alter table dbo.histproductdemand
drop column Datepro

alter table dbo.histproductdemand
drop column Product_Category

select*
from dbo.histproductdemand

alter table dbo.histproductdemand
drop column Warehouse

--put everything together

select*
from dbo.histproductdemand

select Product_Code,Order_Demand, 
sum(Order_Demand)over(partition by Product_Code ) as runningtotal
from dbo.histproductdemand
order by Product_Code 

--add the total colunmn

alter table  dbo.histproductdemand
add  total_order_demand int

select*from dbo.histproductdemand

WITH TotalD AS (
    SELECT Product_Code, SUM(Order_Demand) AS Total_Order_Demand
    FROM dbo.histproductdemand
    GROUP BY Product_Code
	)
update dbo.histproductdemand  
SET total_order_demand = td.Total_Order_Demand
FROM dbo.histproductdemand a 
JOIN TotalD td ON a.Product_Code = td.Product_Code;

--put them in order

SELECT Product_Code, SUM(Order_Demand) AS Total_Order_Demand
FROM dbo.histproductdemand
GROUP BY Product_Code 
order by Product_Code;

select*from dbo.histproductdemand 
order by Product_Code

--create a new table

SELECT Product_Code, SUM(Order_Demand) AS Total_Order_Demand
INTO dbo.NewTable
FROM dbo.histproductdemand
GROUP BY Product_Code;

select*from dbo.totalorderdemand
order by  Product_Code
select*from dbo.histproductdemand 
order by Product_Code

-- products that need to be discontinued

SELECT Product_Code,Order_Demand
FROM dbo.histproductdemand
    WHERE
    Order_Demand = (SELECT MAX(Order_Demand) FROM dbo.histproductdemand) OR
    Order_Demand = (SELECT MIN(Order_Demand) FROM dbo.histproductdemand)
	order by Product_Code

SELECT Product_Code,Total_Order_Demand
FROM dbo.totalorderdemand
    WHERE
    Total_Order_Demand = (SELECT MAX(Total_Order_Demand) FROM dbo.totalorderdemand) OR
    Total_Order_Demand = (SELECT MIN(Total_Order_Demand) FROM dbo.totalorderdemand)
	order by Product_Code

--deide by the target which is 100000 per year

SELECT Product_Code, Total_Order_Demand,
    CASE 
        WHEN Total_Order_Demand >= 100000 THEN 'keep'
        ELSE 'discontinue'
    END AS Product_Status
FROM dbo.totalorderdemand


--decide by avarage

SELECT  AVG(Total_Order_Demand) AS Average_Order_Demand
FROM  dbo.totalorderdemand

SELECT  Product_Code,Total_Order_Demand,
    'keep' AS Product_Status
FROM  dbo.totalorderdemand
WHERE Total_Order_Demand >= (SELECT AVG(Total_Order_Demand) FROM dbo.totalorderdemand)

SELECT  Product_Code,Total_Order_Demand,
    'discontinue' AS Product_Status
FROM  dbo.totalorderdemand
WHERE Total_Order_Demand < (SELECT AVG(Total_Order_Demand) FROM dbo.totalorderdemand)

