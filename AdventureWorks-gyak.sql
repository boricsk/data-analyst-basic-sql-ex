--https://www.w3resource.com/sql-exercises/adventureworks/adventureworks-exercises.php

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