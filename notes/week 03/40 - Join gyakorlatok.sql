--JOIN Gyakorlatok

--Kérdezzük le a 2011 év vásárlásait, jelenítsük meg a vásárló nevét

SELECT 
    o.OrderID,
    o.OrderDate,
    c.FirstName, 
    c.LastName,
    o.SalesPersonID,
    o.SubTotal
FROM Orders as o
JOIN Customer as c on c.CustomerID = o.CustomerID
WHERE YEAR(o.OrderDate) = 2011

--Kérdezzük le a 2012 év vásárlásait, jelenítsük meg a vásárló nevét, és a termék nevét

SELECT 
o.*, od.*, c.FirstName, c.LastName, p.Name
FROM Orders as o
JOIN Customer as c on c.CustomerID = o.CustomerID
JOIN OrderDetail as od on od.orderID = o.orderID
JOIN Product as p on od.productID = p.ProductID

WHERE YEAR(o.OrderDate) = 2012 