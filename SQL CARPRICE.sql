select*
from dbo.CarPrices

--Removing duplicates rows
select vin,make,saledate,model,count(*)
from dbo.CarPrices
group by vin,make,saledate,model
having count(*)>1

WITH RowNumCTE AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY vin, make, model, saledate
            ORDER BY vin
        ) AS row_num
    FROM dbo.CarPrices
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY vin;

WITH RowNumCTE AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY vin, make, model, saledate
            ORDER BY vin
        ) AS row_num
    FROM dbo.CarPrices
)
DELETE FROM dbo.CarPrices
WHERE vin IN (
    SELECT vin
    FROM RowNumCTE
    WHERE row_num > 1
);

select*
from dbo.CarPrices


--standard date formate

select *
from dbo.CarPrices

SELECT CONVERT(VARCHAR(19), saledate, 120) as Saledate
FROM dbo.CarPrices;

--checking null values

SELECT COUNT(*) AS null_count
FROM  dbo.CarPrices
WHERE saledate IS NULL;

--removing columns


ALTER TABLE dbo.CarPrices
DROP COLUMN color;
ALTER TABLE dbo.CarPrices
DROP COLUMN body;
ALTER TABLE dbo.CarPrices
DROP COLUMN condition;
ALTER TABLE dbo.CarPrices
DROP COLUMN interior;
ALTER TABLE dbo.CarPrices
DROP COLUMN odometer;
ALTER TABLE dbo.CarPrices
DROP COLUMN vin;

select*from dbo.CarPrices





















