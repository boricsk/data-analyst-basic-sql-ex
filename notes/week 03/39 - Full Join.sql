--FULL JOIN
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
FULL JOIN #T2 on #T2.ID = #T1.ID

--Ideiglenes táblák
create TABLE [#Kulsosok] (
    [Igazolványszám] nvarchar(10),
    [Név] nvarchar(100)
)

create TABLE [#Belsosok] (
    [Igazolványszám] nvarchar(10),
    [Név] nvarchar(100)
)

SELECT * FROM #Kulsosok

--adat hozzáadása a táblához
INSERT INTO #Kulsosok VALUES
('888777XZ', 'Takács Olivér'),
('666555UH', 'Kiss Zoltán'),
('444333XA', 'Kopasz István'),
('111000AA', 'Kovács aladár')

INSERT INTO #Belsosok VALUES
('888767XZ', 'Krokod Ilus'),
('666556UH', 'Teszt Elek'),
('444333XA', 'Kopasz István'),
('111000BA', 'Mikorka Kálmán')

SELECT * FROM #Kulsosok
FULL JOIN #Belsosok on #Kulsosok.Igazolványszám = #Belsosok.Igazolványszám