--APPLY
/*
Adott egy tábla, amelynek minden egyes sorára fefut egy másik lekérdezés
azaz a T1 tábla valamely oszlopának az értékét beadjuk egy másik lekérdezésnek. (where feltételnek)


Kérdezzük le a 10 termékkategóriában található elemekből az utolsó 3 vásárlást
*/

--Egy termékre vonatkozó lekérdezés
SELECT TOP 3 * 
FROM OrderDetail
WHERE ProductID = 751
ORDER BY OrderID DESC

--10 termék kategória lekérdezése
SELECT * 
FROM Product p
WHERE p.ProductSubCategoryID = 10

--Allekérdezés létrehozása
SELECT * 
FROM Product p
CROSS APPLY (
    SELECT TOP 3 * 
    FROM OrderDetail as od
    WHERE od.ProductID = p.productID
ORDER BY od.OrderID DESC
) as top3
WHERE p.ProductSubCategoryID = 10

SELECT * 
FROM Product p
OUTER APPLY (
    SELECT TOP 3 * 
    FROM OrderDetail as od
    WHERE od.ProductID = p.productID
ORDER BY od.OrderID DESC
) as top3
WHERE p.ProductSubCategoryID = 10