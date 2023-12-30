--COUNT DISTINCT
--A vásárlások számának összesítése
--A vásárlások számának összesítése a 789 termékre

SELECT
    YEAR(OrderDate) as [Year],
    COUNT(DISTINCT o.OrderID) as [Count],
    COUNT(od.ProductID) as [CountProduct_798]
FROM Orders as o
INNER JOIN OrderDetail as od on od.OrderID = o.OrderID
WHERE od.ProductID = 789
GROUP BY YEAR(o.OrderDate)

/*
A fenti lekérdezés problémái:
A 789 termék eladásainak darabszámát visszakapom, visztont azt nem, hogy 
mennyi volt az összes eladás abban az évben.
A where kinyírja azokat az éveket, ahol nem volt eladás a 798-ból.

Az orders táblából minden sor kell. Az inner join viszont szűri az orders táblát
Left Join ugyanaz.
FONTOS
Ha left joint használunk a jobb oldali táblára (orderdetail) nem szabad semmilyen 
szűrést használni mert ha where-t alkalmazok, az inner joinná alakítja a left joint.

Ha mégis szűrni kell a jobb táblára akkor a szűrési feltételt át kell alakítani
összekapcsolási feltétellé.
*/

--Feladat : ki kell számolti a termék %-os eladási arányát.
SELECT
    YEAR(OrderDate) as [Year],
    COUNT(DISTINCT o.OrderID) as [Count],
    COUNT(od.ProductID) as [CountProduct_798]
FROM Orders as o
LEFT JOIN OrderDetail as od on od.OrderID = o.OrderID and od.ProductID = 789 --összekapcs feltétel átfogalmazása
GROUP BY YEAR(o.OrderDate)

/*
A count visztont nem biztos hogy jó.
*/

--A 2013 adat elleőrzés
SELECT count(*) FROM Orders WHERE YEAR(OrderDate) = 2013