--Allekérdezések (Subquery)

/*
Hívják még : beágyazott lekérdezés, subselect ,belső lekérdezésnek
Bármilyen select lekérdezés,amiben lehet bármi (Join, group by)
átalakítható sub selet-é és ez is tartalmazhat másik allekérdezéseket.
SQL serverenként más lehet a limit, SQL szervernél 255 a limit.
Lehet benne order by is (alapból nem lehetne), de ekkor kell TOP
meghatározás is. Minden allaekérdezés () ben van.

Csoportjai:
1.  SELECT és a FROM között
    -Left join helyettesítő
    -Inline subquery
    -kötelezően 1 sorral és 1 oszloppal tér vissza

2.  FROM és a WHERE közötti allekérdezések
    -sorok előszűrése rendezése, összesítése
    -akárhány sort és akárhány oszlopot visszaadhat
    -nem használhat másik táblából származó értéket

3.  WHERE vagy HAVING után
    -dinamikus feltételek definiálása
    -1 oszlopos lista bármennyi sorral IN, EXISTS, ALL operátorok
*/

/*
1. Csoport
SELECT *, (SELECT Value FROM T2) as Column1 FROM Table1
*/

select o.*, c.FirstName, c.LastName
from Orders o
inner join Customer c on c.customerID = o.customerID

--inline subquery-vel
select 
    *, 
    --      Csak 1 oszlop adható meg!!
    (select c.FirstName + ' '+ c.LastName from Customer as c where c.CustomerID = o.CustomerID) as [Name],
    (select count(*) from Customer) as LineOfCustomers
from Orders as o
/*
Csak 1 sor és egy oszlop lehet az eredményben.
Minden egyes Orders során le fog futni. Több sort nem lehet 1 
cellába betenni, ezért van a korlátozása. (Futás idejű hiba)
Az o.customerid lesz az átadott paraméter.
Ha valahol több soros lesz a subquery akkor hiba keletkezik
és leáll, de az addigi sorokat visszaadja.
Ha olyan where feltételt adok meg ami hamis akkor is vissza-
jön csak NULL értékkel. (Join-nál nem jött vissza semmi)
A subselecten belül lehet oszlop alias, de nem az lessza a neve.

A 2. allekérdezés nem kapott külső paramétert, így is jó.
Ha több oszlopos visszatérés kell, akkor aleft join kell.
*/

/*
2. Csoport (FROM utáni)
SELECT *
FROM (SELECT * FROM T1) as T1
*/

/*
Készítsünk összesítést a termékekről termék nevekkel, de csak
azokat jelenítsük meg, amelyek összes eladása 3 millió felett van.
*/
--Having-el (szűrés az összeaítő fgvk-re)
select p.Name as ProductName, sum(od.LineTotal)
from Product as p
inner join OrderDetail as od on od.ProductID = p.ProductID
Group by p.Name
Having sum(od.LineTotal) > 3000000

--Subqueryvel
select *
from (
    --először a subquery fut le. Alias kötelező, és csak 1x lehet
    select p.Name as ProductName, sum(od.LineTotal) as Total
    from Product as p
    inner join OrderDetail as od on od.ProductID = p.ProductID
    Group by p.Name
) as suborders
where Total > 3000000

--Subquery joinolás. Össze lehet kapcsolni más táblákkal is
select suborders.*
from Product as pr 
    inner join(
    select p.Name as ProductName, sum(od.LineTotal) as Total
    from Product as p --csak ezeket a táblákat használhatja
    inner join OrderDetail as od on od.ProductID = p.ProductID
    Group by p.Name
) as suborders on 1=1
where Total > 3000000

--Apply is egy subquery
/*
A cross apply használhat külső táblát, () kívüli táblát.
A FROM utáni subqueryknél ilyen nem lehet.
*/
SELECT * 
FROM Product p
CROSS APPLY (
    SELECT TOP 3 * 
    FROM OrderDetail as od
    WHERE od.ProductID = p.productID
ORDER BY od.OrderID DESC
) as top3
WHERE p.ProductSubCategoryID = 10


/*
3. Csoport a Where vagy having utáni lekérdezések
Ezek is 3 csoportra oszthatóad, de csak abban különböznek, hogy hány sorral
és oszloppal térnek vissza. Közös tulajdonságuk:
-Nem lehet alias neve
-Külső adatokat használhat, de csak azokból a táblákból, ami a from és a where közt van
-Dinamikus szűréshez van (a szűréshez használt érték nem fix, hanem számítandó)

Kategóriái:
-Exists, All után
-In után
-Összehasonlító operátor után (= <> LIKE)

EXISTS, ALL

SELECT *
FROM T1
WHERE EXISTS(SELECT * FROM T2)
*/
--Jelenítsük meg az összes vásárlást a 716,725,764 termékre
SELECT o.OrderID, o.OrderDate, o.SubTotal
from Orders as o
INNER JOIN OrderDetail as od on od.OrderID = o.OrderID
WHERE od.ProductID in (716,725,764)
ORDER BY o.OrderID
--Az a gond, ha olyan terméket választok ki, amit egy rendelésen belül
--rendeltek, az orderid duplikálódni fog a join miatt.
--Lehet distinct-et használni a selectben vagy
SELECT o.OrderID, o.OrderDate, o.SubTotal
FROM Orders as o
WHERE exists (
    select * 
    from OrderDetail as od 
    WHERE od.OrderID = o.OrderID 
    and od.ProductID in (716,725,764)
)
ORDER BY o.OrderID
/*
Működés: jönnek a sorok az o ból, és beadom a beágyazott lekérdezésnek a 
orderID-t. (Önmagában ez a subquery nem fut le, mert nincs meg az OrderID)
Az exists-et csak az érdekli, hogy a lekérdezés visszatér-e valamivel,
ha igen akkor azt a sort visszakapjuk az orders táblából, ha nem ad vissza
semmit a subquery, a where hamis lesz és nem jön vissza az a sor.
A join esetében sorok duplikálódtak. Lehet azt csinálni h a duplikált sort 
kiszűrögetem, de  ez felesleges teljesítmény probléma, mert exist-el meg lehet
csinálni duplikáció nélkül.
*/

----------------------IN után----------------------------
/*
Az a különbség, az 1. től, hogy mig az exists-t nem érdekili, hogy milyen és 
mennyi adattal tér vissza a subq az IN esetében ez fontos.

SELECT *
FROM T1
WHERE Column1 IN (SELECT Column2 FROM T2)

Az IN egy listát vár a paraméterébe, amit egy allekérdezéssel elő lehet állítani.
Használhat hivatkozást külső táblára de nem kötelező.
*/

--Kérdezd le azokat a vásárlásokat, amelyek ugyanaznap történtek mint a 911 temék
--vásárlása. Meg kell keresni azokat a napokat, amikor a 911 ből vásároltak. Ezzel
--lesz 1 dátum listánk, amit használhatunk az in-ben.

select distinct o.OrderDate
from OrderDetail as od
INNER JOIN Orders as o on od.OrderID = o.OrderID
where od.ProductID = 911
--ezt kell bettenni az IN halmazába

--ez a subquery nem használ külső adatot, ezért önmagában is futtatható
select *
from Orders as o
where o.OrderDate in (
    select distinct o.OrderDate
    from OrderDetail as od
    INNER JOIN Orders as o on od.OrderID = o.OrderID
    where od.ProductID = 911
)
/*
Az IN operátornál nem számít, hogy a lista elemek ismétlődnek-e.
A distinct nélküli subqueryvel is ugyanez lesz az eredmény.
*/

-------Összehasonlító operátor után--------------------
/*
Csak 1 sort és 1 oszlopot adhat vissza
Alias nincs
Oszlopnevek nem számítanak, nem kötelezőek

SELECT *
FROM T1
Where Column = (SELECT Column2 FROM T2)

Where Column < (SELECT Column2 FROM T2)
Where Column >= (SELECT Column2 FROM T2)
Where Column <> (SELECT Column2 FROM T2)
*/

--Keressük ki azt a vásárlót aki a legnagyobb értékban vásárolt
--és listázzuk ki az összes vásárlását

--1. Ki kell keresni azt aki a legnagyobb értékben vásárolt
SELECT TOP 1 CustomerID, SUM(SubTotal)
FROM Orders
GROUP BY CustomerID
ORDER BY 2 DESC
--2.Listázzuk ki az összes vásárlás
SELECT *
FROM Orders as o
Where o.CustomerID = (
    SELECT TOP 1 CustomerID, SUM(SubTotal)
    FROM Orders
    GROUP BY CustomerID
    ORDER BY 2 DESC
)
/*
A fenti hibára fut,
Msg 116, Level 16, State 1, Line 8
Only one expression can be specified in the select list when the subquery is not introduced with EXISTS.
Könnyű megoldás: lezozom a SUM(SubTotal)-t az order by ba.
*/
SELECT *
FROM Orders as o
Where o.CustomerID = (
    SELECT TOP 1 CustomerID
    FROM Orders
    GROUP BY CustomerID
    ORDER BY SUM(SubTotal) DESC
)
--vagy
SELECT *
FROM Orders as o
Where o.CustomerID = (
    SELECT CustomerID --csak 1 oszlop lehet
    FROM (
        SELECT TOP 1 CustomerID, SUM(SubTotal) as Total
        FROM Orders
        GROUP BY CustomerID
        ORDER BY 2 DESC
    ) as s
)
/*
Általában igaz, hogy subqueryben nem lehet order by. Mert a subquery
csak 1 előlekérdezést csinál, visszaadja a sorokat, de a végleges rendezés
attól függ, hogy mi történik a visszaadott sorokkal.

Ha mégis akarok order by-t használni meg kell adni a top -ot is, mert
ebben az esetben a top listát rendezem.
*/