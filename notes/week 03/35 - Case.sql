--35 - Case és if

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

/*
A messages fülön van egy figyelmeztetés ami szerint az aggregáló fgv kihagyja a null
értékeket.
Warning: Null value is eliminated by an aggregate or other SET operation.
Ha sum-ok és group by  nélkül futtatod, akkor lesznek olyan oszlopok, 
ahol null lesz. Ezeket hagyja ki az aggregáló fgv, mert ha nem hagyná ki minden
null lenne.
*/

/*
Kérdezzük le az összes vásárlót helyettesítsük az ország kódokat a lentiek szerint:
US - United States
DE - Germany
HU - Hungary
A többi other.

Összesítsünk az így létrehozott nevekre.
*/

SELECT CustomerID, FirstName, LastName, Country,
    case 
        when Country = 'US' then 'United states'
        when Country = 'DE' then 'Germany'
        when Country = 'HU' then 'Hungary'
        else 'Other' --nem kötelező, de ha nem teljesül egyik feltétel
        --sem akkor null lesz az eredmény
    END as CountryName

FROM Customer
--vagy (ez a szerkezet egyenlőséget vizsgál.)
SELECT CustomerID, FirstName, LastName, Country,
    case Country
        when 'US' then 'United states'
        when 'DE' then 'Germany'
        when 'HU' then 'Hungary'
        else 'Other'

    END as CountryName

FROM Customer

--ha egy feltétel igaz a következőek már nem lesznek végrehajtva
SELECT CustomerID, FirstName, LastName, Country,
    case 
        when 1 = 1 then 'United states'
        when Country = 'DE' then 'Germany'
        when Country = 'HU' then 'Hungary'
        else 'Other' --nem kötelező, de ha nem teljesül egyik feltétel
        --sem akkor null lesz az eredmény
    END as CountryName

FROM Customer

/*
IIF csak kétirányú elágazás
Azért iif mert az if már be volt vezetve mikor ezt kitalálták.
Valójában egy függvény.
*/
SELECT CustomerID, FirstName, LastName, Country,
    IIF(Country = 'US', 'United States', 'Not United States') as CountryName
FROM Customer
--Csoportképzés
SELECT --CustomerID, FirstName, LastName, Country, (Azért kell kiszedni, 
        --mert nincsennek benne egy aggregáló fgv-ben sem)
    case Country
        when 'US' then 'United states'
        when 'DE' then 'Germany'
        when 'HU' then 'Hungary'
        else 'Other'
    END as CountryName,
    count(*) [Count]
FROM Customer
GROUP BY
        case Country
        when 'US' then 'United states'
        when 'DE' then 'Germany'
        when 'HU' then 'Hungary'
        else 'Other'
    END

select Count(*)
From Customer
GROUP By Country

SELECT --CustomerID, FirstName, LastName, Country,
    IIF(Country = 'US', 'United States', 'Not United States') as CountryName,
    COUNT(*)
FROM Customer
GROUP BY IIF(Country = 'US', 'United States', 'Not United States')