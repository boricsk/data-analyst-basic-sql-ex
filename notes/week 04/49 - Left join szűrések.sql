--LEFT JOIN szűrések

SELECT
    YEAR(OrderDate) as [Year],
    COUNT(o.OrderID) as [Count],
    COUNT(od.ProductID) as [CountProduct_798]
FROM Orders as o
LEFT JOIN OrderDetail as od on od.OrderID = o.OrderID and od.ProductID = 789 --összekapcs feltétel átfogalmazása
GROUP BY YEAR(o.OrderDate)
ORDER BY 1

SELECT
    YEAR(OrderDate) as [Year],
    COUNT(DISTINCT o.OrderID) as [Count],
    SUM(case when od.productId = 789 then 1 else 0 end)
FROM Orders as o
LEFT JOIN OrderDetail as od on od.OrderID = o.OrderID --and od.ProductID = 789 --összekapcs feltétel átfogalmazása
GROUP BY YEAR(OrderDate)
ORDER BY 1

/*
A left join képes beduplikálni a bal oldali tábla sorait
ha a feltételnek több sor is megfelel a jobb táblában, 
ezért vigyázni kell a count-al. A count-ba ha distinct-et 
adunk meg akkor az ismétlődések számát nem fogja számolni.
*/

select count(orderID), Count(distinct OrderID)
from OrderDetail
WHERE OrderID = 43662