--Week 04 HW
/*
Kérdezzük le, hogy hány féle termék vonal szerepel a vállalat rendszerében és azt is, hogy az egyes 
termék vonalakhoz hány termék tartozik. Rendezzük abc szerint növekvőbe. 
*/
SELECT ProductLine, Count(ProductID) as Products
FROM Product
GROUP BY ProductLine
ORDER BY ProductLine ASC

/*
Jelenítsünk meg egy listát arról, hogy a 2013. márciusában hányféle terméket értékesítettünk
a 12-es termék kategóriában (ProductSubCategoryID), összesen hány darabot és mekkora össz értékben. 
A listát rendezzük termék név szerint növekvőbe.
*/

SELECT 
    p.Name as ProductName,
    sum(od.OrderQty) as SlesQty,
    sum(od.lineTotal) as SalesAmount
FROM Product as p
JOIN OrderDetail as od on od.productID = p.ProductID
JOIN Orders as o on od.orderID = o.OrderID
WHERE YEAR(o.OrderDate) = 2013 and Month(o.OrderDate) = 3 and p.ProductSubcategoryID = 12
GROUP BY p.Name
ORDER BY p.Name ASC
--vagy
/*
1. Kiindulás a product táblából
2. Subquery -> Orders-ből a rendelési dátum 2013 márciusra
3. Illesszük be az első lekérdezésbe.
4. Joinozzuk az orders táblát
5. Készítsük el a group-ot.
*/
SELECT *
FROM Product as p
Where p.ProductSubcategoryID = 12

SELECT o.OrderDate as OrderDate
FROM Orders as o
WHERE Year(o.OrderDate) = 2013 and Month(o.OrderDate) = 3

SELECT p.Name, sum(od.OrderQty), sum(od.LineTotal)
FROM Product as p
JOIN OrderDetail as od on p.ProductID = od.ProductID
JOIN Orders as o on od.OrderID = o.OrderID
Where (p.ProductSubcategoryID = 12) and o.OrderDate in (
    SELECT o.OrderDate as OrderDate
    FROM Orders as o
    WHERE Year(o.OrderDate) = 2013 and Month(o.OrderDate) = 3
)
GROUP BY p.Name
ORDER BY p.Name ASC
--vagy
WITH DateList as (
    SELECT o.OrderDate as OrderDate
    FROM Orders as o
    WHERE Year(o.OrderDate) = 2013 and Month(o.OrderDate) = 3
)
SELECT p.Name, sum(od.OrderQty), sum(od.LineTotal)
FROM Product as p
JOIN OrderDetail as od on p.ProductID = od.ProductID
JOIN Orders as o on od.OrderID = o.OrderID
Where (p.ProductSubcategoryID = 12) and o.OrderDate in (
    SELECT *
    FROM DateList
)
GROUP BY p.Name
ORDER BY p.Name ASC

/*
Készítsünk Éves-Havi bontású öszesítést az eladásokról 2013-01 és 2014-12 között
(darabszám és összeg). Csak azokat a termékeket vegyük figyelembe, amelyeknek a nevében 
a “tire” szó szerepel. A megadott dátum intervallum között mindenhónapot
jelenítsük meg független attól, hogy volt-e eladás az adott termékből abban a hónapban
vagy sem (ha nem volt, akkor 0 értékeket jelenítsünk meg). 
Rendezés év és hónap szerint.
*/

WITH TireProducts as (
    SELECT p.Name
    FROM Product as p
    WHERE p.Name LIKE '%tire%'
)
SELECT
    YEAR(o.OrderDate) as [Year],
    MONTH(o.OrderDate) as [Month],
    SUM(od.OrderQty) as OrderQuantity,
    SUM(od.LineTotal) as SalesAmount
    
FROM Orders as o
JOIN OrderDetail as od on o.orderID = od.orderID
JOIN Product as p on od.ProductID = p.ProductID
WHERE (year(o.OrderDate) in (2013,2014)) and (p.Name in (Select * FROM TireProducts))
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate)
ORDER BY 1, 2

/*
Listázzunk ki minden eladást 2011-ben, amelyek abban az évben a napi átlagos eladás felettiek. A napi 
átlagot úgy kapjuk meg, hogy kiszámítjuk az összes eladást az év minden napjára (amelyiken volt 
bármilyen eladás), majd ezekből számítunk egy átlagot).
*/

WITH DailyAvg2011 as (
    SELECT
    sum(o.SubTotal) as DailySum
    FROM Orders as o
    WHERE YEAR(o.OrderDate) = 2011
    GROUP BY (o.OrderDate)
)
SELECT *
FROM Orders as o
WHERE o.SubTotal > (SELECT avg(DailySum) FROM DailyAvg2011) and YEAR(o.OrderDate) = 2011


/*
Keressük meg azt a terméket, amelyből eddig a legtöbbet adták az egész vállalat történetében és 
jelenítsük meg a termék minden adatát (a Product tábla összes oszlopát).
*/
WITH TopOneProduct as (
    SELECT TOP 1 od.productID
    From OrderDetails as od
    GROUP BY od.ProductID
    ORDER BY sum(od.LineTotal) DESC
)
SELECT * 
FROM Product as p
WHERE p.ProductID = (SELECT * FROM TopOneProduct)
