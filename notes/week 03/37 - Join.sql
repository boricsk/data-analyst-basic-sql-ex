--37 - JOIN
/*
Több táblából akarunk adatot lekérdezni, akkor használjuk

Ha le akarom kérni pl. a vevő vevét akkor az orders és a customers
táblát kell használni.

SELECT * 
FROM Orders
JOIN Customer on 1 = 1
     tábla       Feltétel

Ha a feltétel igaz, akkor megkapom a sort.
A * a selectben mindkét táblára vonatkozik, azaz minden visszajön
ha a feltétel teljesül. A fenti példa minden sort összekombinál minden
sorral, azaz 31k sor van az ordersben, tehát a customer 1. sorát hozzá-
fűzi mind a 31k sorhoz, aztán megy a customer 2. sorára.
Abban az esetben, ha nincs a customers-ben olyan id, ami
van az ordersben, akkor azt a sort nem kapjuk vissza.
A NULL nem illeszthetőek.
*/
--INNER JOIN (JOIN)
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

Eredmény (JOIN T2 on T1.ID = T2.ID)
ID  A   B   D   E
1   q   w   y   x
1   q   w   u   i

Egyfajta szűrés is, mert ha nem teljesűl az összekapcsolási feltétel, akkor
azok a sorok nem jönnek vissza
*/

SELECT * 
FROM Orders
JOIN Customer on Orders.CustomerID = Customer.CustomerID
--Result 31465

SELECT * 
FROM Customer
JOIN Orders on Orders.CustomerID = Customer.CustomerID
--Result 31465

/*
Ha * al kérdezek le akkor van 2 azonos nevű oszlop OK lesz, de ha a
selectben felsorolással választom ki az oszlopokat, akkor
egyedilek kell megadnom, mert nem tudja eldönteni a rendszer, 
hogy melyiket akarom. (Customer.CustomerID, Orders.CustomerID) 
*/

SELECT * 
FROM Customer
JOIN Orders on Orders.CustomerID = Customer.CustomerID
Where FirstName LIKE 'A%' --Szűri a másik táblát is!!

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

SELECT * FROM #T1 JOIN #T2 on #T2.ID = #T1.ID