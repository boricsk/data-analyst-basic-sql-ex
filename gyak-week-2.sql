/*Keresd meg a Customer tábla legnagyobb ID-ű elemét*/
SELECT TOP 1 * FROM Customer
ORDER BY CustomerID DESC

/*Azok, akik ID-je kissebb mint 20000*/
SELECT * FROM Customer
WHERE CustomerID < '20000'

/*Ellenőrid van-e olyan ahol nincs város megadva*/
SELECT City FROM Customer
WHERE City is NULL

/*Szűrjük le a Budapestieket*/
SELECT *
FROM Customer
WHERE City in ('Budapest')

SELECT *
FROM Customer
WHERE City = 'Budapest'

/*Rendezd first name szerint növekvőbe, majd város szerint csökkenőbe (ASC az alapértelmezett rendezés, nem kötelező kiirni)*/
SELECT * FROM Customer
ORDER BY FirstName ASC, City DESC

--Számított oszlopok, egyedi nevek
SELECT FirstName as [Előnév], LastName, FirstName + ' ' + LastName as FullName
FROM Customer

SELECT FirstName + ' ' + LastName as FullName, City
FROM Customer

--Cak az order by esetén lehet az alias-t használni, máshol nem.
SELECT FirstName, LastName, FirstName + ' '+LastName as FullName, City
FROM Customer
ORDER BY FullName DESC, City ASC
--vagy
SELECT FirstName, LastName, FirstName + ' '+LastName as FullName, City
FROM Customer
ORDER BY FirstName + ' '+LastName DESC, City ASC
--vagy
SELECT FirstName, LastName, FirstName + ' '+LastName as FullName, City
FROM Customer
ORDER BY 2 DESC, 3 ASC --a select oszlopszámot adod meg a név helyett (oszlopindexnek nevezik és a lekérdezésben elfoglat helyére vonatkozik)

--Csak azokat a sorokat kérdezzük le, ahol a Country = US
SELECT *
FROM Customer
WHERE Country = 'US'
--vagy
SELECT *
FROM Customer
WHERE Country in ('US')
/*
Nem feltétlen kell megjelníteni azokat az oszlopokat, amelyekre szűrni szeretnénk
A WHERE után olyan kifejezésnek kell lenni, ami igazat vagy hamisat ad vissza.
*/
SELECT FirstName
FROM Customer
WHERE Country in ('US')

--Összetett szöveg szűrés
--Csak azokat a sorokat kérdezzük le, ahol az ország US,AU,GB
SELECT *
FROM Customer
WHERE Country in ('US', 'AU', 'GB')
--    Skalár      Konstansok (Azonos tipusnak kell lennie)
--vagy
SELECT *
FROM Customer
WHERE Country ='US' or  Country = 'AU' or  Country = 'GB'

--kezdődjön a first name A-val
SELECT *
FROM Customer
WHERE (Country ='US' or  Country = 'AU' or  Country = 'GB') and FirstName LIKE 'A%'
/*
Helyettesítő karakterek a LIKE-ban

% -> Akárhány és akármilyen karakter
_ -> Akármilyen karakter, de csak egy
[a-c]% -> Első helyen a-c szerepelhetnek karakterek, utánna bármi.
[a-c0-9]% -> Első helyen a-c vagy 0-9 lehet
[a-c0-9]___5 -> Első helyen a-c vagy 0-9 utánna 3 bármi és a vége 5

Több logikai kiértékelés esetén () -el meg kell adni melyik logikai feltételet tartoznak össze
*/
SELECT *
FROM Customer
WHERE Country in ('US', 'AU', 'GB') and FirstName LIKE 'A%'

--A first name a vagy s betuvel kezd
SELECT * 
FROM Customer
WHERE Country in ('US', 'AU', 'GB') and FirstName LIKE '[a,s]%'
--vagy
SELECT * 
FROM Customer
WHERE Country in ('US', 'AU', 'GB') and (FirstName LIKE 'a%' or FirstName LIKE 's%')

--A first name a vagy s betuvel kezd és a last nam johnson-ra végződik
SELECT * 
FROM Customer
WHERE Country in ('US', 'AU', 'GB') and (FirstName LIKE '[a,s]%' and LastName LIKE '%Johnson')
--vagy
SELECT * 
FROM Customer
WHERE Country in ('US', 'AU', 'GB') and (FirstName LIKE 'a%' or FirstName LIKE 's%') and (LastName LIKE '%Johnson')

/*
Lehet olyan eset, amikor meg kell adni a keresést, de nem akarok keresni semmire, ekkor 
LIKE '%' adható meg.
LIKE '%%' adható meg.
LIKE '% + @var + %' adható meg.
*/

--NULL kezelés
/*
A NULL az adat hiányát jelöli, az IS operátorral lehet kezelni
A NULL-al ovatosan matematikai képletben, mert mindent kinulláz.
*/

--Vásárlók teljes neve kell, FullName legyen a neve, ahol a title = null
SELECT *, FirstName + ' '+ LastName as FullName
FROM Customer
WHERE Title is NULL
--hány sorban nem null a title
SELECT *, FirstName + ' '+ LastName as FullName
FROM Customer
WHERE Title is not NULL
--vagy
SELECT *, FirstName + ' '+ LastName as FullName
FROM Customer
WHERE not Title is NULL

--van city = null?
SELECT *, FirstName + ' '+ LastName as FullName
FROM Customer
WHERE City is NULL

--van-e email null
SELECT *, FirstName + ' '+ LastName as FullName
FROM Customer
WHERE Email is NULL

--illesszük a teljes névhez a title oszlopot is
SELECT Title, Title + ' ' + FirstName + ' '+ LastName as FullName
FROM Customer
WHERE Title is not NULL
/*
Ha valami null-al érintkezik, akkor minen null lesz!!
Megoldás : ISNULL(mező, mi legyen ha null)
NULLIF : Ha egy érték megegyezik a másikkal akkor null jön vissza
*/
SELECT Title, isnull(Title, '') + ' ' + FirstName + ' '+ LastName as FullName
FROM Customer
WHERE Title is NULL
--A full névnél bekerül egy szóköz. Megoldás az , hogy be kell vinni az isnull belsejébe a szóközt is.
SELECT Title, isnull(Title+' ', '') + FirstName + ' '+ LastName as FullName
FROM Customer
WHERE Title is NULL

--Concat
SELECT 
    Title, 
    isnull(Title+' ', '') + FirstName + ' '+ LastName as FullName,
    CONCAT(FirstName + ' ',LastName) as FullName2
FROM Customer
WHERE Title is NULL

--Dátumszűrés
--Kérdezzük le a vásárlásokat az orders táblából 2011 2QY-re
SELECT * FROM Orders
WHERE OrderDate BETWEEN '2011-04-01' and '2011-06-30'
/*
A between nek 3 operandusa van : A bal odalon egy skaláris érték a jobb oldalon a tartomány
Zárt intervallumú szűrés, azaz a tartomány két vége is benne van.
*/
--vagy
SELECT * FROM Orders
WHERE OrderDate >= '2011-04-01' and OrderDate <= '2011-06-30'
--vagy
SELECT * FROM Orders
WHERE MONTH(OrderDate) in (4,5,6)
--Van DAY is, amivel a napokat lehet kiszedni
--Van datePart is, amivel minden szart ki lehet szedni

--Kérdezzük le a vásárlásokat az orders táblából 2012 és 2013 ból
SELECT *
FROM Orders
WHERE OrderDate BETWEEN '2012-01-01' and '2013-12-31' --A tartományra figyelni, rossz sorrend esetén is lefut!!
--vagy
SELECT *
FROM Orders
WHERE YEAR(OrderDate) in (2012, 2013)
--vagy
SELECT *
FROM Orders
WHERE YEAR(OrderDate) = 2012 or YEAR(OrderDate) = 2013

--Számadat szűrés
--Kérd le a vásárlásokat amelynek összege nagyobb mint 100 000 (SQL-be a számokat egybe kell írni)
SELECT *
FROM Orders
WHERE SubTotal > 100000

--Kérd le a vásárlásokat amelynek összege 10000 és 20k között van
SELECT *
FROM Orders
WHERE SubTotal BETWEEN 10000 and 20000

--számítsd ki az adót
SELECT *, SubTotal * 0.27 as tax
FROM Orders
WHERE SubTotal BETWEEN 10000 and 20000
--vagy
SELECT 
    *, 
    ROUND(SubTotal * 0.27, 2) as tax
FROM Orders
WHERE SubTotal BETWEEN 10000 and 20000
/*
Ha megnézed a SubTotal money tipusú, ez fix pontos tört típus, ezért round esetén megmaradnak a tizedesek 0-val
*/

--Kérdezd le a 10 legnagyobb összegű vásárlást
SELECT TOP 10 *
FROM Orders
ORDER BY SubTotal DESC

/*
Egyszerű lekérdezések összefoglaló

SELECT TOP / DISTINCT ...
FROM ...
WHERE ...
(
GROUP BY ...
HAVING ...
)
ORDER BY ...

*/

--Aggregált lekérdezések
/*
Nem sorokat ad vissza, hanem csoportokat képez, és a csoporton belül végez el műveleteket (aggregációt, valamilyen összesítés).
Jellemzője, hogy amit vissza akarunk kapni az nincs benne a táblában.

Jellemző szavai az emberi beszédben:
...ként
...bontásban
...szinten
...összesítve

Két lépést kell megcsinálni:
1. Csoport képzés (GROUP BY)
2. Összesítés (COUNT, SUM, AVG, MIN, MAX)

51131	2013-05-30 00:00:00	29641	281	163930,3943
55282	2013-08-30 00:00:00	29641	281	160378,3913
46616	2012-05-30 00:00:00	29614	289	150837,4387
46981	2012-06-30 00:00:00	30103	290	147390,9328
47395	2012-07-31 00:00:00	29701	275	146154,5653
47369	2012-07-31 00:00:00	29998	281	140078,3959
47355	2012-07-31 00:00:00	29957	276	129261,254
51822	2013-06-30 00:00:00	29913	276	128873,2206
44518	2011-10-01 00:00:00	29624	279	126198,3362
57150	2013-09-30 00:00:00	29923	290	122285,724

Group by CustomerID A 4. oszlopot csoportosítja, majd végrehatja az aggregáló lekérzezést
azokon az oszlopokon, ahol a CustomerID egforma. Ha a fenti pépdát nézzük a sum(Subtotal)
csak az első két sort összegzi, mert az tartozik egy customerid csoportba.
*/

--Kérdezd le, h a vásárlók hányféle és milyen országból vannak
SELECT Country, COUNT(ISNULL(Country,'NA')) as NumberOfCust FROM Customer
GROUP BY Country
--vagy (A Countnál olyan oszlopot adsz meg, ahol minden sorban van érték)
SELECT Country, COUNT(CustomerID) as NumberOfCust FROM Customer
GROUP BY Country
--vagy (Ez akkor jó, ha nem tudjuk, hogy melyik oszlop tartalmaz minden sorban értéket.)
SELECT Country, COUNT(*) as NumberOfCust FROM Customer
GROUP BY Country

--Hány sorban van title-nek érték adva
SELECT 
    Country, COUNT(*) as NumberOfCust, 
    COUNT(Title) as TitleNumber
FROM Customer
GROUP BY Country

/*
Ha egyszer megvannak a csoportok, akkor az aggregációt már könnyen tudja kezelni a rendszer.
*/

--hány sor van az orders táblában (Nem kötelező a GROUP BY, ilyenkor az egész tábla lesz 1 csoport)
SELECT COUNT(OrderID) 
FROM Orders

--bontsuk le a sorok darabszámát évenként és rendezzük darabszám szerint csökkenőbe, összegezzük a vásárlás értékét
SELECT 
    YEAR(OrderDate) as [Year], 
    COUNT(OrderID) as [Number of purchases],
    SUM(SubTotal) as Total,
    MAX(SubTotal) as "Highest purchase"
FROM Orders
GROUP BY YEAR(OrderDate)
ORDER BY 2 DESC


