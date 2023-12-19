
/*
Kérdezzük le csak azokat a termékeket (Product) amelyeknek van szine (Color). Végezzünk el egy 
fordítást a szín elnevezéseknél magyarra. A következő megfeleltetés alapján:

Black = Fekete
Blue = Kék
Grey = Szürke
Multi = Több
Red = Piros
Silver = Ezüst
Silver/Black = Ezüst/Fekete
White = Fehér
Yellow = Sárga
A megfeleltetéshez használjunk CASE szerkezetet.
*/

SELECT 
ProductID,
Name,
ProductNumber,
case Color
    when 'Black' then 'Fekete'
    when 'Blue' then 'Kék'
    when 'Grey' then 'Szürke'
    when 'Multi' then 'Több'
    when 'Red' then 'Piros'
    when 'Silver' then 'Ezüst'
    when 'Silver/Black' then 'Ezüst/Fekete'
    when 'White' then 'Fehér'
    when 'Yellow' then 'Sárga'
    else 'Nincs szín'
end as Szinek,
ListPrice,
Weight,
ProductLine,
Class,
Style,
ProductSubCategoryID,
ProductModelID

FROM Product
WHERE Color is not NULL

/*
Készítsünk egy összesítő lekérdezést, amely kimutatja a vásárlók táblából (Customer):

Összesen hány vásárló van a táblában (TotalCustomer)
Hánynál van megadva titulus (CountOfTitle)
Hánynál van megadva város (CountOfCity)
Hánynál an megadva ország (CountOfCountry)
*/

SELECT 
    Count(CustomerID) as TotalCustomer,
    Count(Title) as CountOfTitle,
    Count(City) as CountOfCity,
    Count(Country) as CountOfCountry
FROM Customer
/*
Ha lefuttattuk a lekérdezést figyeljük meg a megjelenő figyelmeztető üzenetet a Messages tabon. Miért 
jelenik meg ez a figyelmeztetés?

A figyelmeztetés azért jelenik meg, mert vannak NULL értékek a rekordban, így ezeket figyelmen kívül
hagyja az összesítés, mert ha nem tenne így minden NULL lenne.
*/

/*
Adott egy lekérdezés, amely lekérdezi 2012-ben az első 3 legnagyobb összegű vásárlást.
*/

SELECT TOP 3 *
FROM Orders
WHERE YEAR(OrderDate) = 2012
ORDER BY SubTotal DESC

/*
A lekérdezés ki kell egészíteni, hogy a vásárló ID-ja helyett (CustomerID) a vásárló teljes neve 
(CustomerName) jelenjen meg (FirstName + LastName). 
*/

SELECT TOP 3 
o.OrderID,
o.OrderDate,
c.FirstName + ' ' + c.LastName as CustomerName,
o.SalesPersonID,
o.Subtotal
FROM Orders o
JOIN Customer c on c.CustomerID = o.CustomerID
WHERE YEAR(OrderDate) = 2012
ORDER BY SubTotal DESC

/*
A 3. Feladatban szereplő lekérdezést alakítsuk át úgy, hogy az összes évből adja vissza évenként az első 3 
legnagyobb összegű eladást.
A listát rednezzük év szerint növekvőbe és összeg szerint csökkenőbe.

A With -el létrehozok egy ideiglenes táblát RankedOrders névvel, ebben
rangsorolom az értékesítéseket a ROW_NUMBER() OVER(PARTITION BY YEAR(o.OrderDate) ORDER BY o.Subtotal DESC) AS Rank
segítségével végezhető a rangsorolás. A fő lehérdezés csak azokat a sorokat adja vissza, ahol a 
rangsor kissebb v. egyenlő 3-al.
*/

WITH RankedOrders AS (
    SELECT
        o.OrderID,
        o.OrderDate,
        c.FirstName + ' ' + c.LastName AS CustomerName,
        o.SalesPersonID,
        o.Subtotal,
        ROW_NUMBER() OVER(PARTITION BY YEAR(o.OrderDate) ORDER BY o.Subtotal DESC) AS Rank
    FROM Orders o
    JOIN Customer c ON c.CustomerID = o.CustomerID
)
SELECT
    YEAR(ro.OrderDate) as [Year],
    ro.OrderID,
    ro.OrderDate,
    ro.CustomerName,
    ro.SalesPersonID,
    ro.Subtotal
FROM RankedOrders as ro
WHERE Rank <= 3
ORDER BY YEAR(ro.OrderDate), Rank, ro.SubTotal DESC;

