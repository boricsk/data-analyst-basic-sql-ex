--https://www.w3resource.com/sql-exercises/adventureworks/adventureworks-exercises.php
--db : AdventureWorks2022
/*
1. From the following table write a query in SQL to retrieve all rows and columns from 
the employee table in the Adventureworks database. Sort the result set in ascending order on jobtitle.
Sample table: HumanResources.Employee 
*/

SELECT *
FROM HumanResources.Employee as emp
ORDER BY emp.jobtitle

/*
2. From the following table write a query in SQL to retrieve all rows and columns from the employee 
table using table aliasing in the Adventureworks database. Sort the output in ascending order on lastname.
Sample table: Person.Person
*/

SELECT *
FROM person.person as pers
ORDER BY pers.lastname

/*
3. From the following table write a query in SQL to return all rows and a subset of the columns 
(FirstName, LastName, businessentityid) from the person table in the AdventureWorks database. 
The third column heading is renamed to Employee_id. Arranged the output in ascending order by lastname.
Sample table: Person.Person
*/

SELECT 
    pers.FirstName,
    pers.LastName,
    pers.businessentityid as employee_id
FROM person.person as pers
ORDER BY 2 asc

/*
4. From the following table write a query in SQL to return only the rows for product that 
have a sellstartdate that is not NULL and a productline of 'T'. Return productid, 
productnumber, and name. Arranged the output in ascending order on name.

Sample table: production.Product
*/

SELECT *
FROM production.product as p
WHERE p.sellstartdate is not null AND p.productline = 'T'
ORDER BY p.name ASC

/*
5. From the following table write a query in SQL to return all rows from the 
salesorderheader table in Adventureworks database and calculate the percentage 
of tax on the subtotal have decided. Return salesorderid, customerid, orderdate, 
subtotal, percentage of tax column. Arranged the result set in ascending order 
on subtotal.

Sample table: sales.salesorderheader
*/
SELECT 
    sh.salesorderid,
    sh.customerid,
    sh.orderdate,
    sh.subtotal,
    (sh.taxamt / sh.subtotal) *100 as taxPercent 
FROM sales.salesorderheader as sh
ORDER BY sh.subtotal DESC

/*
6. From the following table write a query in SQL to create a list of unique 
jobtitles in the employee table in Adventureworks database. Return jobtitle 
column and arranged the resultset in ascending order.

Sample table: HumanResources.Employee
*/

SELECT DISTINCT emp.jobtitle
FROM HumanResources.Employee as emp

/*
6/A
Számoljuk meg a droidokat a munkakörökben, mert kell a bossnak.
*/
SELECT 
    DISTINCT emp.jobtitle,
    COUNT (emp.businessentityid) as numberOfDroids
    --COUNT (*) vagy ez de ettől herótom van
FROM HumanResources.Employee as emp
GROUP BY cube (emp.jobtitle)
ORDER BY 2 

--Ellenőrzés
select *
from HumanResources.employee as emp
WHERE emp.jobtitle = 'Production Technician - WC30'

/*
7. From the following table write a query in SQL to calculate the total 
freight paid by each customer. Return customerid and total freight. 
Sort the output in ascending order on customerid.

Sample table: sales.salesorderheader
*/

select * 
from sales.salesorderheader as sh

select 
    sh.customerid,
    SUM(sh.freight) as totalFreight
from sales.salesorderheader as sh
GROUP BY sh.customerid
ORDER BY 1

/*
8. From the following table write a query in SQL to find the average and the sum of 
the subtotal for every customer. Return customerid, average and sum of the subtotal. 
Grouped the result on customerid and salespersonid. Sort the result on customerid 
column in descending order.

Sample table: sales.salesorderheader
*/

select *
from sales.salesorderheader as sls

select 
    sls.customerid,
    sls.salespersonid,
    avg (sls.subtotal) as avg_subtotal,
    sum (sls.subtotal) as sum_subtotal
from sales.salesorderheader as sls
GROUP BY sls.customerid, sls.salespersonid
ORDER BY 1 DESC

/*
9. From the following table write a query in SQL to retrieve total quantity of each productid 
which are in shelf of 'A' or 'C' or 'H'. Filter the results for sum quantity is more than 500. 
Return productid and sum of the quantity. Sort the results according to the productid in 
ascending order.

Sample table: production.productinventory
*/

select 
    pi.productid,
    sum(pi.quantity) as total_quantity
from production.productinventory as pi
WHERE pi.shelf in ('A', 'C', 'H')
GROUP BY pi.productid
HAVING sum(pi.quantity) > 500
ORDER BY 1 

/*
9. From the following table write a query in SQL to retrieve total quantity of each productid 
which are in shelf of 'A' or 'C' or 'H'. Filter the results for sum quantity is more than 500. 
Return productid and sum of the quantity. Sort the results according to the productid in ascending order. 

Sample table: production.productinventory
*/

select 
    pi.ProductID,
    sum(pi.Quantity) as total_quantity

from Production.ProductInventory as pi
WHERE pi.Shelf in ('A','C','H')
GROUP BY pi.ProductID
HAVING sum(pi.Quantity) > 500
ORDER BY 1

/*
10. From the following table write a query in SQL to find the total quentity for a group of locationid multiplied by 10. 
Sample table: production.productinventory
*/

SELECT
    SUM(pi.Quantity) as total_quantity
from Production.ProductInventory as pi
GROUP BY pi.LocationID*10

/*
11. From the following tables write a query in SQL to find the persons whose last name starts with letter 'L'. 
Return BusinessEntityID, FirstName, LastName, and PhoneNumber. Sort the result on lastname and firstname.
Sample table: Person.PersonPhone
*/

select 
    p.BusinessEntityID,
    p.FirstName,
    p.LastName,
    pp.PhoneNumber
from Person.Person as p
left join Person.PersonPhone as pp on pp.BusinessEntityID = p.BusinessEntityID
where p.LastName like 'L%'
ORDER BY 3, 2

/*
12. From the following table write a query in SQL to find the sum of subtotal column. Group the sum on 
distinct salespersonid and customerid. Rolls up the results into subtotal and running total. 
Return salespersonid, customerid and sum of subtotal column i.e. sum_subtotal.
Sample table: sales.salesorderheader
*/

select 
    ISNULL(sh.SalesPersonID,999) as SalesPersonID,
    sh.customerid,
    SUM(sh.SubTotal) as sumSubtotal
from sales.SalesOrderHeader as sh
GROUP by ROLLUP(sh.SalesPersonID, sh.CustomerID)
