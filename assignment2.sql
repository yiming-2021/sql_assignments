--Answer following questions
	--1. What is a result set?
		-- A result set is the output generated by a query. 
	--2. What is the difference between Union and Union All?
		-- UNION ALL keeps all rows including duplicated ones; while UNION removes the duplicated rows.
		-- UNION will sort the records by the first column of the first result set, but UNION ALL will not
		-- UNION ALL can be used in recursive CTE but UNION cannot.
	--3. What are the other Set Operators SQL Server has?
		-- INTERSECT, EXCEPT.
	--4. What is the difference between Union and Join?
		-- UNION is used to combine rows from two result sets; while JOIN is used to combine the columns from different tables based on some specified logic.
	--5. What is the difference between INNER JOIN and FULL JOIN?
		-- INNER JOIN only returns the matched rows between the left and right tables; but FULL JOIN returns all rows from both tables. 
	--6. What is difference between left join and outer join
		-- LEFT JOIN returns all rows in the left table including the unmatched rows, but not unmatched ones in right table; OUTER JOIN returns all the rows no matter matched or not.
	--7. What is cross join?
		-- CROSS JOIN returns the Cartesian product of rows from the two tables.
	--8. What is the difference between WHERE clause and HAVING clause?
		-- WHERE clause is used to filter records by conditions on individual rows; while HAVING clause adds conditions on the groups or aggregate values, which means that it has to be used with GROUP BY.
	--9. Can there be multiple group by columns?
		-- Yes.

--Write queries for following scenarios
	use AdventureWorks2019
	go	
	--1. How many products can you find in the Production.Product table?
	
	select count(distinct p.ProductID) totalNumOfProducts
	from Production.Product p


	--2. Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory. The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.
	
	select count(distinct p.ProductID) productsInSubcat
	from Production.Product p
	where p.ProductSubcategoryID is not null




	--3. How many Products reside in each SubCategory? Write a query to display the results with the following titles.
	--ProductSubcategoryID CountedProducts
	---------------------- ---------------
	
	select p.ProductSubcategoryID, count(distinct p.ProductID) CountedProducts
	from Production.Product p
	where p.ProductSubcategoryID is not null
	group by p.ProductSubcategoryID


	--4. How many products that do not have a product subcategory. 

	select count(distinct p.ProductID) productsWithoutSubcat
	from Production.Product p
	where p.ProductSubcategoryID is null


	--5. Write a query to list the summary of products quantity in the Production.ProductInventory table.

	select p.ProductID, sum(p.Quantity) TheSum
	from Production.ProductInventory p
	group by p.ProductID


	--6. Write a query to list the summary of products in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100.
	--              ProductID    TheSum
	-------------        ----------
	
	select p.ProductID, sum(p.Quantity) TheSum
	from Production.ProductInventory p
	where p.LocationID = 40
	group by p.ProductID
	having sum(p.Quantity) < 100


	--7. Write a query to list the summary of products with the shelf information in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100
	--Shelf      ProductID    TheSum
	------------ -----------        -----------

	select p.shelf, p.ProductID, sum(p.Quantity) TheSum
	from Production.ProductInventory p
	where p.LocationID = 40
	group by p.shelf, p.ProductID
	having sum(p.Quantity) < 100

	

	--8. Write the query to list the average quantity for products where column LocationID has the value of 10 from the table Production.ProductInventory table.
	
	select p.ProductID, avg(p.Quantity) TheAvg
	from Production.ProductInventory p
	where p.LocationID = 10
	group by p.ProductID




	--9. Write query  to see the average quantity  of  products by shelf  from the table Production.ProductInventory
	--ProductID   Shelf      TheAvg
	------------- ---------- -----------

	select p.ProductID, p.Shelf, avg(p.Quantity) TheAvg
	from Production.ProductInventory p
	group by p.ProductID, p.Shelf


	--10. Write query  to see the average quantity  of  products by shelf excluding rows that has the value of N/A in the column Shelf from the table Production.ProductInventory
	--ProductID   Shelf      TheAvg
	------------- ---------- -----------

	select p.ProductID, p.Shelf, avg(p.Quantity) TheAvg
	from Production.ProductInventory p
	where p.Shelf != 'N/A'
	group by p.ProductID, p.Shelf


	--11. List the members (rows) and average list price in the Production.Product table. This should be grouped independently over the Color and the Class column. Exclude the rows where Color or Class are null.
	--Color           	Class 	TheCount   	 AvgPrice
	----------------	- ----- 	----------- 	---------------------
	
	select p.Color, p.Class, count(1) TheCount, avg(p.ListPrice) AvgPrice
	from Production.Product p
	where color is not null and class is not null
	group by color, class
	

	--Joins:
	--12.  Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. Join them and produce a result set similar to the following. 

	--Country                        Province
	-----------                          ----------------------

	select c.Name Country , p.Name Province
	from Person.CountryRegion c
	full join Person.StateProvince p
	on c.CountryRegionCode = p.CountryRegionCode


	--13. Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.
	
	--Country                        Province
	-----------                          ----------------------

	select c.Name Country , p.Name Province
	from Person.CountryRegion c
	full join Person.StateProvince p
	on c.CountryRegionCode = p.CountryRegionCode
	where c.Name in ('Canada', 'Germany')


	--        Using Northwnd Database: (Use aliases for all the Joins)

	use Northwind
	go
	--14. List all Products that has been sold at least once in last 25 years.

	select distinct p.ProductName
	from Products p, Orders o, [Order Details] od
	where p.ProductID = od.ProductID 
	and o.OrderID = od.OrderID
	and o.OrderDate > '1996-09-15'

	--15. List top 5 locations (Zip Code) where the products sold most.

	select top 5 o.ShipPostalCode
	from Orders o, [Order Details] od
	where o.ShipPostalCode is not null and o.OrderID = od.OrderID
	group by o.ShipPostalCode
	order by sum(od.Quantity) desc


	--16. List top 5 locations (Zip Code) where the products sold most in last 20 years.
		
	select top 5 o.ShipPostalCode
	from Orders o, [Order Details] od
	where o.ShipPostalCode is not null and o.OrderDate > '2001-09-15' and o.OrderID = od.OrderID
	group by o.ShipPostalCode
	order by sum(od.Quantity) desc --there is actually no orders placed in the last 20 yrs for this dataset


	--17. List all city names and number of customers in that city.     

	select City, count(CustomerID) numOfCustomers
	from Customers
	group by City

	--18. List city names which have more than 10 customers, and number of customers in that city 

	select City, count(CustomerID) numOfCustomers
	from Customers
	group by City
	having count(customerID) > 10

	--19. List the names of customers who placed orders after 1/1/98 with order date.

	select c.ContactName, o.OrderDate
	from Customers c
	left join 
	Orders o
	on c.CustomerID = o.CustomerID
	where o.OrderDate > '1998-01-01'

	--20. List the names of all customers with most recent order dates 

	select c.ContactName, max(o.OrderDate) mostRecentOrderDate
	from Customers c
	left join 
	Orders o
	on c.CustomerID = o.CustomerID
	group by c.ContactName


	--21. Display the names of all customers  along with the  count of products they bought 

	select c.ContactName, sum(od.Quantity) countOfProducts
	from Customers c, Orders o, [Order Details] od
	where c.customerID = o.CustomerID
	and o.OrderID = od.OrderID
	group by c.ContactName


	--22. Display the customer ids who bought more than 100 Products with count of products.

	select c.CustomerID, sum(od.Quantity) countOfProducts
	from Customers c, Orders o, [Order Details] od
	where c.customerID = o.CustomerID
	and o.OrderID = od.OrderID
	group by c.CustomerID
	having sum(od.Quantity) > 100
	

	--23. List all of the possible ways that suppliers can ship their products. Display the results as below
	--Supplier Company Name   	Shipping Company Name
	-----------------------------------            ----------------------------------

	select spl.CompanyName 'Supplier Company Name', shp.CompanyName 'Shipping Company Name'
	from Suppliers spl, Shippers shp

	
	--24. Display the products order each day. Show Order date and Product Name.

	select o.OrderDate, p.ProductName
	from orders o
	left join 
	[Order Details] od
	on o.OrderID = od.OrderID
	left join 
	Products p
	on od.ProductID = p.ProductID
	order by o.OrderDate, p.ProductName


	--25. Displays pairs of employees who have the same job title.

	select concat(e1.FirstName, ' ', e1.LastName) Employee1Name, concat(e2.FirstName,' ', e2.LastName) Employee2Name
	from Employees e1, Employees e2
	where e1.Title = e2.Title and e1.EmployeeID < e2.EmployeeID


	--26. Display all the Managers who have more than 2 employees reporting to them.

	select concat(m.FirstName,' ', m.LastName) managerName
	from Employees e, Employees m
	where e.ReportsTo = m.EmployeeID
	group by m.FirstName, m.LastName
	having count(1) > 2
	order by m.FirstName


	--27. Display the customers and suppliers by city. The results should have the following columns
	--City 
	--Name 
	--Contact Name,
	--Type (Customer or Supplier)

	select c.City, c.CompanyName Name, c.ContactName, 'Customer'  as Type
	from Customers c
	UNION
	select s.City, s.CompanyName Name, s.ContactName, 'Supplier' as Type
	from Suppliers s


	-- 28. Have two tables T1 and T2
	--F1.T1  --F2.T2
	--1			2
	--2			3
	--3			4



	--Please write a query to inner join these two tables and write down the result of this query.

		--select f1.t1.column
		--from f1.t1
		--inner join f2.t2
		--on f1.t1.column = f2.t2.column

		-- result:
		-- column
		-- 2
		-- 3 

	-- 29. Based on above two table, Please write a query to left outer join these two tables and write down the result of this query.

		--select f1.t1.column
		--from f1.t1
		--left join f2.t2
		--on f1.t1.column = f2.t2.column

		--result:
		--column
		--1
		--2
		--3
