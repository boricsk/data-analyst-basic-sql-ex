--SQL Gyakorlatok
/*
Kérdezzük le az összes vásárlót (a Customer táblából) amelyeknek van titulusunk és 
városuk. Adjuk vissza az CustomerID-t és egyetlen oszlopban a teljes nevet titulussal 
valamint utána zárójelben a várost(City).
Az eredmény (101 sor):
*/

SELECT 
    CustomerID,
    Title + ' ' + FirstName + ' ' + LastName + ' ' + '(' + City + ')' as FullName
FROM Customer
WHERE Title is not NULL And City is not NULL

--Alakítsd át, hogy akkor is értelmes legyen, ha kivesszük a város szűrést
SELECT 
    CustomerID,
    Title + ' ' + FirstName + ' ' + LastName + ' ' + isnull('(' + City + ')' , '') as FullName
FROM Customer
WHERE Title is not NULL 

--Alakítsd át, hogy akkor is értelmes legyen, ha kivesszük a title szűrést
SELECT 
    CustomerID,
    isnull(Title + ' ','') + FirstName + ' ' + LastName + ' ' + isnull('(' + City + ')' , '') as FullName
FROM Customer

--Leghosszab nevű vásárló
SELECT 
    CustomerID,
    isnull(Title + ' ','') + FirstName + ' ' + LastName as FullName
FROM Customer 
ORDER BY LEN(Title + FirstName + LastName) DESC

--Kérdezzük le, hogy hány különböző város van a Customer táblában. Az eredmény (271 sor):
SELECT City
FROM Customer
GROUP BY City

/*
Kérdezzük le az összes vásárlót úgy, hogy az utónevük(LastName) rövidítve legyen és 
utána ott legyen zárójelben az ország (Country), ha van.
Az eredmény (19 122 sor)
*/

SELECT 
    FirstName + ' ' + LEFT(LastName,1) + '. ' + isnull('(' + Country + ')','')
FROM Customer

/*
Kérdezzük le az összes rendelést(az Orders táblából)
2012.02.01 és 2012.09.30 között(OrderDate).
Az eredmény (2 497 sor):
*/

SELECT *
FROM Orders
WHERE OrderDate BETWEEN '2012.02.01' and '2012.09.30'

/*
Bővítsük a lekérdezés szűrését, hogy csak az 50000 felettieket
(SubTotal)adja vissza.
Az eredmény (124sor):
*/
SELECT *
FROM Orders
WHERE (OrderDate BETWEEN '2012.02.01' and '2012.09.30') and SubTotal > 50000

/*
Az előző lekérdezést folytatva jelenítsük meg az OrderDate oszlopot ebben a 
formátumban: 2011 May 01.Az eredmény (124 sor):

SELECT FORMAT (getdate(), 'dd/MM/yyyy ') as date                                21/03/2021
SELECT FORMAT (getdate(), 'dd/MM/yyyy, hh:mm:ss ') as date 	                    21/03/2021, 11:36:14
SELECT FORMAT (getdate(), 'dddd, MMMM, yyyy') as date 	                        Wednesday, March, 2021
SELECT FORMAT (getdate(), 'MMM dd yyyy') as date 	                            Mar 21 2021
SELECT FORMAT (getdate(), 'MM.dd.yy') as date 	                                03.21.21
SELECT FORMAT (getdate(), 'MM-dd-yy') as date 	                                03-21-21
SELECT FORMAT (getdate(), 'hh:mm:ss tt') as date 	                            11:36:14 AM
SELECT FORMAT (getdate(), 'd','us') as date 	                                03/21/2021
SELECT FORMAT (getdate(), 'yyyy-MM-dd hh:mm:ss tt') as date 	                2021-03-21 11:36:14 AM
SELECT FORMAT (getdate(), 'yyyy.MM.dd hh:mm:ss t') as date 	                    2021.03.21 11:36:14 A
SELECT FORMAT (getdate(), 'MM-dd-yyyy ') as date 	                            03-21-2021
SELECT FORMAT (getdate(), 'MM dd yyyy ') as date 	                            03 21 2021
SELECT FORMAT (getdate(), 'yyyyMMdd') as date 	                                20231011
SELECT FORMAT (getdate(), 'HH:mm:dd') as time 	                                11:36:14
SELECT FORMAT (getdate(), 'HH:mm:dd.ffffff') as time 	                        11:36:14.84000 
SELECT FORMAT (getdate(), 'dddd, MMMM, yyyy','es-es') as date --Spanish      	domingo, marzo, 2021
SELECT FORMAT (getdate(), 'dddd dd, MMMM, yyyy','ja-jp') as date --Japanese 	日曜日 21, 3月, 2021
*/

SELECT 
    OrderID,
    FORMAT(OrderDate, 'yyyy MMM dd') as OrderDate,
    CustomerID,
    SalesPersonID,
    SubTotal
FROM Orders
WHERE (OrderDate BETWEEN '2012.02.01' and '2012.09.30') and SubTotal > 50000

/*
Kérdezzük le az összes rendelést, ahol a SalesPersonID nincs kitöltve.
Az eredmény (27659 sor):
*/
SELECT *
FROM Orders
WHERE SalesPersonID is NULL

/*
Kérdezzük le az összes terméket a Product táblából, amely nevében (Name) szerepel a "tire" szó.
Az eredmény (10 sor):
*/

SELECT *
FROM Product
WHERE Name LIKE '%tire%'

/*
Az előzőt alakítsuk át, hogy a termék nevek első tagjaiból egy egyedi listát adjon vissza.
Az eredmény (6 sor):
*/
SELECT 
SUBSTRING(Name,1,CHARINDEX(' ', Name+' ')-1) as Name
FROM Product
WHERE Name LIKE '%tire%'
GROUP BY SUBSTRING(Name,1,CHARINDEX(' ', Name+' ')-1)

/*
Új lekérdezéssel kérdezzük le melyik a legolcsóbb termék ListPrice alapján (a nullákat ne).
Az eredmény (1 sor):
*/
SELECT TOP 1 * 
FROM Product
WHERE (ListPrice is not NULL) and ListPrice > 0
ORDER BY ListPrice ASC

/*
Kérdezzük az összes termékeket, amelyeknél sem stílus (Style), sem osztály (Class) nincs 
megadva és a következő kategóriákban vannak: 33, 34, 35 (ProductSubCategoryID).
Az eredmény (5 sor):
*/

SELECT *
FROM Product
WHERE (Style is null and Class is NULL) and ProductSubCategoryID in (33, 34, 35)

/*
Kérdezzük le a különféle termék kategóriákat (ProductSubCategoryID) a Product-ban.
Az eredmény (38 sor):
*/

SELECT ProductSubCategoryID
FROM Product
GROUP BY ProductSubCategoryID

/*
Kérdezzük le azokat a termékeket, amelyek: 
színe sárga (Color = Yellow) és női(Style = W)
vagy fekete(Color = Black) és férfi(Style = M) 
vagy kék(Color = Blue) és unisex(Style = U).
Az eredmény (43 sor):
*/
SELECT * 
FROM Product
WHERE 
    (Color = 'Yellow' and Style = 'W') 
    or (Color = 'Black' and Style = 'M')
    or (Color = 'Blue' and Style = 'U')

/*
Kérdezzünk le minden terméket és számítsuk ki mennyi lenne a listaáruk, ha 25%-al 
emelnénk az árukat (csak ahol nem nulla az ár).
Az eredmény (304 sor):
*/

SELECT *,
    ListPrice * 1.25 as NewPrice
FROM Product
WHERE ListPrice <> 0 and not ListPrice is NULL


