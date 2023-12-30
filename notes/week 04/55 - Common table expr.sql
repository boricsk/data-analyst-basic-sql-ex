--Kiemelt subqueryk (Common table expressions)
/*
Fogunk 1 subqueryt, adunk egy nevet neki, kiemeljük a lekérdezés elejére
és a név alapján többször is felhasználható lesz a lekérdezésben.

*/

--kérdezd le azon termékek listáját, amelyek eladási átlagon felüliek.
--1. ki kell számolni az átlagos termék eladást

--1 terméknek mennyi eladása volt

With termek as (
    SELECT ProductID, SUM(LineTotal) as Total
    FROM OrderDetail
    GROUP BY ProductID
)
SELECT p.*, termek.Total
FROM Termek
INNER JOIN Product as p on p.ProductID = termek.ProductID
Where Total > (
    SELECT AVG(Total)
    FROM Termek
)

--Rekurzív lekérdezés
WITH CTE as (
    SELECT CAST('2010-01-01' as Date) as [Date]
    UNION ALL
    SELECT DATEADD(day, 1, [Date]) from CTE --saját magából kérdez le
    WHERE [Date] < GETDATE()
)
SELECT [Date] from CTE
OPTION (maxrecursion 10000)