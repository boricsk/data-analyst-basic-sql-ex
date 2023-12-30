--Inline tábla készítés (Táblakonstruktor)
/*
Szintax

SELECT *
FROM (
    VALUES
        (1, 'Budapest),
        (2, 'Szeged),
        (3, 'Miskolc)
) varos(ID, Nev)

A felsorolt értékeket visszaadja, mint egy tábla
*/

SELECT *
FROM (
    VALUES
        (1, 'Budapest',2000000),
        (2, 'Szeged', 500000),
        (3, 'Miskolc', 600000)
) varos(ID, Nev, Nepesseg)
WHERE Nepesseg > 500000

--Állítsunk elő év és hónap listát
SELECT *
FROM (
    VALUES
        (2010),
        (2011),
        (2012),
        (2013),
        (2014)
) as Evek(Ev)
CROSS JOIN
    (
    VALUES
        (1),
        (2),
        (3),
        (4),
        (5)
) as Honapok(Honap)