--left join
/*
Ha adott 2 tábla

    T1
ID  A   B
1   q   w
2   a   f

    T2
ID  D   E
1   y   x
1   u   i
3   f   j
4   l   p

Eredmény (LEFT JOIN T2 on T1.ID = T2.ID)
ID  A   B   D   E
1   q   w   y   x
1   q   w   u   i
2   a   f

Ha a jobb oldali táblában nem minden sor található meg ami a balban
és ne szűrje le a jobb oldali a bal oldalit

*/

create TABLE [#T1] (
    ID INT,
    A CHAR,
    B CHAR
)

create TABLE [#T2] (
    ID INT,
    C CHAR,
    D CHAR
)

INSERT INTO [#T1]
VALUES  (1, 'q', 'w'),
        (2, 'a', 'f')

INSERT INTO [#T2]
VALUES  (1, 'y', 'x'),
        (1, 'u', 'i'),
        (3, 'f', 'j'),
        (4, 'l', 'p')

SELECT * FROM #T1
SELECT * FROM #T2

SELECT * FROM #T1 
Left JOIN #T2 on #T2.ID = #T1.ID

--jelenítsük me a product tábla productID, és Name oszlopait, ahol ProductSubCategoryID = 17
--Kapcsoljuk hozzá a rendeléseket

SELECT Product.ProductID, Name, count(*) 
FROM Product
JOIN OrderDetail on Product.ProductID = OrderDetail.ProductID
WHERE ProductSubcategoryID = 17
GROUP BY Product.ProductID, Name 

/*
van 3 olyan termék a 17 kategóriában, amihez nem tartozik rendelés
count(*) visszaadja, hogy hány darab eladás volt (OrderDetail sorok száma)
ha az összes terméket akarom látni ebben a kategóriában akkor
kell a left join
*/
SELECT Product.ProductID, Name, count(*) 
FROM Product
LEFT JOIN OrderDetail on Product.ProductID = OrderDetail.ProductID
WHERE ProductSubcategoryID = 17
GROUP BY Product.ProductID, Name 

/*
Az 1, azoknál ahol nem volt eladás azért van, mert count(*) ot adtam meg
és ez azt jeleni, hogy 1 sor mindenkép van a product táblából.
Ha a vásárlások számára vagyok kíváncsi akkor a OrderDetail.productID-t számolom.
*/
SELECT Product.ProductID, Name, count(OrderDetail.productID) 
FROM Product
LEFT JOIN OrderDetail on Product.ProductID = OrderDetail.ProductID
WHERE ProductSubcategoryID = 17
GROUP BY Product.ProductID, Name 

/*
DISTINCT - Nem ismétli az ismétlődő adatokat
Ha használjuk nem kell GROUP BY, viszont ekkor nem lehet aggregálni.
*/
SELECT DISTINCT Product.ProductID, Name
FROM Product
LEFT JOIN OrderDetail on Product.ProductID = OrderDetail.ProductID
WHERE ProductSubcategoryID = 17

SELECT DISTINCT City 
FROM Customer

/*
A right join ennek az ellentéte, de ritkán használatos, mert left 
joinnel mindent meg lehet csinálni.
*/