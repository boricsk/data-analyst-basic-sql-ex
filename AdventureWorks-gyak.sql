/*
1. From the following table write a query in SQL to retrieve all rows and columns from 
the employee table in the Adventureworks database. Sort the result set in ascending order on jobtitle.
Sample table: HumanResources.Employee 
*/

SELECT *
FROM HumanResources.Employee as emp
ORDER BY emp.jobtitle