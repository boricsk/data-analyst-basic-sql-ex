--Data analyst basics Home work Week 02

--Keressük ki azokat az eladásokat (Orders tábla), amelyeknél az eladó azonosítója nincs kitöltve (SalesPersonID).
SELECT *
FROM Orders
WHERE SalesPersonID is NULL

/*
A következő lekérdezés visszaadja, hogy hány darab (és összesen mekkora összegű) vásárlás 
van tárolva az adatbázisban, amelynek összege legalább $50 000.

select
count(*), 
sum(SubTotal)
from Orders
where SubTotal >= 50000
*/
select
    count(*), 
    sum(SubTotal)
from Orders
where SubTotal >= 50000

--A 10 000 és 100 000 közötti vásárlásokat adja vissza és ne a 50 000 felettieket, mint most
select
    count(*), 
    sum(SubTotal)
from Orders
where SubTotal BETWEEN 10000 and 100000

--Számítsd ki az átlagos vásárlási értéket is egy plusz oszlopban
select
    count(*) as "Number of orders", 
    sum(SubTotal) as TotalSales,
    AVG(SubTotal) as AvgSales
from Orders
where SubTotal BETWEEN 10000 and 100000

/*
A következő lekérdezés visszaadja az egyes eladók összes eladását 18 sorban (a létező 18 eladóra):

SELECT SalesPersonID, SUM(SubTotal) as [Total]
FROM Orders
GROUP BY SalesPersonID

*/
SELECT SalesPersonID, SUM(SubTotal) as [Total]
FROM Orders
GROUP BY SalesPersonID

--A 18 sorból 1 sorban a SalesPersonID értéke NULL. Ezt szűrd ki, hogy ne jelenjen meg
SELECT SalesPersonID, SUM(SubTotal) as [Total]
FROM Orders
WHERE SalesPersonID is not NULL
GROUP BY SalesPersonID

--Csak a 2012 es évben tötént eladásokat összesítse
SELECT SalesPersonID, SUM(SubTotal) as [Total]
FROM Orders
WHERE SalesPersonID is not NULL and YEAR(OrderDate) in (2012)
GROUP BY SalesPersonID

--Számojuk meg egy plusz oszlopban (pl. SalesAmount), hogy a Total oszlopban kimutatott összeg hány darab eladásból tevődik össze
SELECT 
    SalesPersonID, 
    SUM(SubTotal) as [Total],
    COUNT(OrderID) as "Number of orders"
FROM Orders
WHERE SalesPersonID is not NULL and YEAR(OrderDate) in (2012)
GROUP BY SalesPersonID

--Készíts egy lekérdezést, amely éves és havi bontásban jeleníti meg az összesített eladásokat. Year, Month TotalSales oszlopokkal
SELECT 
    YEAR(OrderDate) as [Year],
    MONTH(OrderDate) as [Month],
    SUM(SubTotal) as TotalSales
FROM Orders
GROUP BY YEAR(OrderDate), MONTH(OrderDate)

/*
A következő lekérdezés visszaadja a 17 eladó eladásait 2011-ben

SELECT SalesPersonID, 
    SUM(Case When YEAR(OrderDate) = 2011 then Subtotal end) as [2011]
FROM Orders
GROUP BY SalesPersonId
*/

SELECT SalesPersonID, 
    SUM(Case When YEAR(OrderDate) = 2011 then Subtotal end) as [2011],
    SUM(Case When YEAR(OrderDate) = 2012 then Subtotal end) as [2012],
    SUM(Case When YEAR(OrderDate) = 2013 then Subtotal end) as [2013],
    SUM(Case When YEAR(OrderDate) = 2014 then Subtotal end) as [2014],
    SUM(Case When YEAR(OrderDate) = 2015 then Subtotal end) as [2015],
    SUM(Case When YEAR(OrderDate) = 2016 then Subtotal end) as [2016],
    SUM(SubTotal) as [Total]
FROM Orders
GROUP BY SalesPersonId
ORDER BY Total

--Null helyettesítés
SELECT 
    CASE 
        When SalesPersonID is null then 0 
        When SalesPersonID is not null then SalesPersonID  
    end as SalesPerson, 
    SUM(ISNULL(Case When YEAR(OrderDate) = 2011 then Subtotal end,0)) as [2011],
    SUM(ISNULL(Case When YEAR(OrderDate) = 2012 then Subtotal end,0)) as [2012],
    SUM(ISNULL(Case When YEAR(OrderDate) = 2013 then Subtotal end,0)) as [2013],
    SUM(ISNULL(Case When YEAR(OrderDate) = 2014 then Subtotal end,0)) as [2014],
    SUM(ISNULL(Case When YEAR(OrderDate) = 2015 then Subtotal end,0)) as [2015],
    SUM(ISNULL(Case When YEAR(OrderDate) = 2016 then Subtotal end,0)) as [2016],
    SUM(SubTotal) as [Total]
FROM Orders
GROUP BY SalesPersonId
ORDER BY Total