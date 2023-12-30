--Week 4 Gyakorlatok

/*
Adott két lekérdezés: 
a.) az 1. feladathoz hasonlóan évenként visszaadja a vásárlások számát
b.) visszaad egy fix év listát

A feladat, hogy kombináljuk össze a két lekérdezést, hogy az minden évet visszaadjon a fix 
év listából és jelenítsen meg nulla értékeket, azoknál az éveknél ahol nincs egyetlen 
vásárlás sem.
*/

select 
    year(OrderDate) as Year, 
    count(*) as Orders
from Orders
where SubTotal > 150000
group by year(OrderDate)

select Y
from(
values
    (2010),
    (2011),
    (2012),
    (2013),
    (2014),
    (2015)
) years(Y)
/*
A kiindulási alap a 2. lita. Ehez hozzá kell left joinozni az 1. lehérdezést.
*/
select years.Y as [Year1], ISNULL(od.Orders,0) as NumberOfOrders
from(
values
    (2010),
    (2011),
    (2012),
    (2013),
    (2014),
    (2015)
) years(Y)
left JOIN (select 
        year(OrderDate) as [Year], 
        count(*) as Orders
    from Orders
    where SubTotal > 150000
    group by year(OrderDate)
) as od on od.[Year] = years.Y

/*
Adott egy termék lista, amelyet a mellékelt lekérdezés ad vissza. 
*/
SELECT ProductID, Name, ListPrice
FROM Product
Where ListPrice > 1000 and Name LIKE '%60%'

/*
A feladat, hogy az listát egészítsük ki, a termék 2014-es legutolsó vásárlási
adataival, vagyis az OrderID, OrderDate, LineTotal, CustomerID oszlopokkal
az Orders és OrderDetail táblákból.
Ha van olyan a 6 termék közül, amelyet egyáltalán nem értékesítettek 2014-
ben, akkor annak az adatainál adjunk vissza NULL-okat.
*/

SELECT 
    p.Name,
    p.ListPrice,
    LastOrder.*
FROM (
    SELECT ProductID, Name, ListPrice
    FROM Product
    Where ListPrice > 1000 and Name LIKE '%60%'
) as p
OUTER APPLY (
    SELECT TOP 1 o.OrderID, o.OrderDate, LineTotal
    FROM Orders as o
    JOIN OrderDetail as od on o.OrderID = od.OrderID
    WHERE YEAR(o.OrderDate) = 2014 and od.ProductID = p.ProductID
    ORDER BY o.OrderDate DESC
) as LastOrder

/*
Az előző lekérdezés kiegészítésével számoljuk ki egy új oszlopban (DiscountPrice), hogy 
az adott vásárlásnál a jelenlegi listaárhoz (ListPrice) képest a vásárló mennyi 
kedvezményt kapott (UnitPrice).
*/

SELECT 
    p.Name,
    p.ListPrice,
    LastOrder.OrderID,
    LastOrder.OrderDate,
    LastOrder.LineTotal,
    LastOrder.CustomerID,
    CASE 
        When LastOrder.ActualUnitPrice - p.ListPrice = 0 Then 0 
        ELSE p.listPrice - LastOrder.ActualUnitPrice END as Discount
FROM (
    SELECT ProductID, Name, ListPrice
    FROM Product
    Where ListPrice > 1000 and Name LIKE '%60%'
) as p
OUTER APPLY (
    SELECT TOP 1 
        o.OrderID, 
        o.OrderDate,
        o.CustomerID, 
        UnitPrice, 
        OrderQty, 
        LineTotal, LineTotal / OrderQty as ActualUnitPrice
    FROM Orders as o
    JOIN OrderDetail as od on o.OrderID = od.OrderID
    WHERE YEAR(o.OrderDate) = 2014 and od.ProductID = p.ProductID
    ORDER BY o.OrderDate DESC
) as LastOrder

/*
Alakítsuk át az előző lekérdezést úgy, hogy azokat a termékeket ne adja vissza, amelyhez 
nem volt értékesítés 2014-ben és közben a CustomerID-t cseréljük le a vásárló teljes 
nevére (előtaggal) a Customer táblából.
*/

SELECT 
    p.Name,
    p.ListPrice,
    LastOrder.OrderID,
    LastOrder.OrderDate,
    LastOrder.LineTotal,
    LastOrder.CustomerID,
    CASE 
        When LastOrder.ActualUnitPrice - p.ListPrice = 0 Then 0 
        ELSE p.listPrice - LastOrder.ActualUnitPrice 
    END as Discount,
    LastOrder.FullName
FROM (
    SELECT ProductID, Name, ListPrice
    FROM Product
    Where ListPrice > 1000 and Name LIKE '%60%'
) as p
OUTER APPLY (
    SELECT TOP 1 
        o.OrderID, 
        o.OrderDate,
        o.CustomerID, 
        UnitPrice, 
        OrderQty, 
        LineTotal, LineTotal / OrderQty as ActualUnitPrice,
        isnull(c.Title + ' ','')+ c.FirstName + ' ' + c.LastName as FullName
    FROM Orders as o
    JOIN OrderDetail as od on o.OrderID = od.OrderID
    JOIN Customer as c on o.CustomerID = c.CustomerID
    WHERE YEAR(o.OrderDate) = 2014 and od.ProductID = p.ProductID
    ORDER BY o.OrderDate DESC
) as LastOrder
WHERE LastOrder.OrderID is not NULL

/*
Kérdezzük le azt a vásárlót, aki az eddigi legnagyobb összegű rendelést adta le. 
Jelenítsük meg az összes oszlopot a Customer táblából, de az eredmény első oszlopa a
vásárló összesített eladása legyen (Total).
*/

--1. A legnagyobb rendelés összege
SELECT TOP 1 SUM(SubTotal)
FROM Orders
GROUP BY CustomerID
ORDER BY SUM(SubTotal) desc


SELECT bigestOrder.*,c.*
FROM Customer as c
INNER JOIN (
    SELECT TOP 1 CustomerID, SUM(SubTotal) as TotalPurchase
    FROM Orders
    GROUP BY CustomerID
    ORDER BY SUM(SubTotal) desc
    ) as bigestOrder on bigestOrder.customerID = c.CustomerID

/*
Kérdezzük le, hogy van-e olyan vásárló a Customer táblában, akinek egyáltalán nincs 
vásárlása (az Orders táblában). Jelenítsük meg az összes oszlopot a Customer-ből.
*/

select *
From Customer
Where not exists(select * from Orders where Customer.CustomerID = Orders.CustomerID) 

/*
Adott a következő lekérdezés, amely termék szinten összesíti az eladások
at több különböző értéket is kiszámítva.
A feladat, hogy adj hozzá egy új oszlopot (Customers) , amely megmutatja, 
hogy az adott terméket hány különböző vásárló vásárolta már meg.
Rendezzük a listát ez az új oszlop szerint csökkenőbe.
*/

select
    od.ProductID,
    count(*) as Orders,
    sum(od.LineTotal) as Total,
    sum(od.OrderQty) as Qty,
    avg(od.LineTotal) as Avgqty,
    avg(od.UnitPrice) as AvgPrice,
    count(distinct(o.CustomerID)) as NumOfCustomer
from OrderDetail as od
join Orders as o on o.OrderID = od.OrderID
GROUP BY od.ProductID
ORDER BY count(distinct(o.CustomerID)) desc

/*
Jelenítsük meg az összes rendelést (Orders), amelyek az utolsó napon történtek (az 
adatbázisban található utolsó rendelés napján).
*/

SELECT *
FROM Orders as o
WHERE o.OrderDate = (SELECT max(Orders.OrderDate) FROM Orders)