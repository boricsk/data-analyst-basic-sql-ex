--CUBE ROLLUP
--Vegyük alapúl a lenti lekérdezést
SELECT 
    YEAR(OrderDate) as [Year],
    MONTH(OrderDate) as [Month],
    --DAY(OrderDate) as [Day],
    COUNT (*) as [Count],
    SUM(SubTotal) as [Total]
FROM Orders
GROUP BY YEAR(OrderDate), MONTH(OrderDate) --DAY(OrderDate)
ORDER BY 1,2

--Éves részösszesítő készítése
SELECT 
    YEAR(OrderDate) as [Year],
    MONTH(OrderDate) as [Month],
    DAY(OrderDate) as [Day],
    COUNT (*) as [Count],
    SUM(SubTotal) as [Total]
FROM Orders
GROUP BY YEAR(OrderDate), MONTH(OrderDate),DAY(OrderDate)
WITH ROLLUP

--Összes összesítési kombinációt megcsinálja
/*
A cube az OLAP adatbázisokból ered, ahol az adatok így vannak előre aggregálva
*/
SELECT 
    YEAR(OrderDate) as [Year],
    MONTH(OrderDate) as [Month],
    DAY(OrderDate) as [Day],
    COUNT (*) as [Count],
    SUM(SubTotal) as [Total]
FROM Orders
GROUP BY YEAR(OrderDate), MONTH(OrderDate),DAY(OrderDate)
WITH CUBE