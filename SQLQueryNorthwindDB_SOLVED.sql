                         --Queries based on 'NORTHWIND' database

--1- Find the number of orders sent by each shipper.

SELECT COUNT(O.OrderID)
FROM Orders AS O
RIGHT JOIN Shippers AS S
ON O.ShipVia = S.ShipperID  

--2- Find the number of orders sent by each shipper, sent by each employee

SELECT S.ShipperID, S.CompanyName ShipperName, O.EmployeeID, E.FirstName+' '+E.LastName Employee, COUNT(*)NoofOrders
FROM Orders AS O
RIGHT JOIN Shippers AS S
ON O.ShipVia = S.ShipperID 
JOIN Employees AS E
ON O.EmployeeID = E.EmployeeID
GROUP BY S.ShipperID, S.CompanyName, O.EmployeeID , E.FirstName+' '+E.LastName

--3- Find  name  of  employees who has registered more than 100 orders.

SELECT O.EmployeeID, E.FirstName+' '+E.LastName Employee, COUNT(*)NoofOrders
FROM Orders AS O
JOIN Employees AS E
ON O.EmployeeID = E.EmployeeID
GROUP BY  O.EmployeeID, E.FirstName+' '+E.LastName
HAVING COUNT(*) > 100
ORDER BY 3 DESC

--4-Find if the employees "Davolio" or "Fuller" have registered more than 25 orders.
SELECT O.EmployeeID, E.FirstName, E.LastName, COUNT(*)NoofOrders
FROM Orders AS O
RIGHT JOIN Employees AS E
ON O.EmployeeID = E.EmployeeID
WHERE E.FirstName = 'DAVOLIO' OR E.LastName = 'DAVOLIO'  OR E.FirstName = 'FULLER' OR E.LastName  = 'FULLER'
GROUP BY O.EmployeeID, E.FirstName, E.LastName

--5-Find the customer_id and name of customers who had placed orders more than one time and how many times they have placed the order

SELECT C.CustomerID, C.CompanyName, COUNT(O.CustomerID)NoofOrders
FROM Orders O
JOIN Customers C
ON O.CustomerID = C.CustomerID
group by C.CustomerID, C.CompanyName
HAVING COUNT(O.CustomerID) > 1
order by 3 desc

--6-Select all the orders where the employee’s city and order’s ship city are same.

SELECT O.*, E.City
FROM Orders O
LEFT JOIN Employees E
ON O.EmployeeID = E.EmployeeID
WHERE O.ShipCity = E.City

--7-Create a report that shows the order ids and the associated employee names for orders that shipped after the required date.

SELECT O.OrderID, E.FirstName+' '+E.LastName EmployeeName, O.RequiredDate, O.ShippedDate
FROM Orders O
JOIN Employees E
ON O.EmployeeID = E.EmployeeID
WHERE  O.ShippedDate > O.RequiredDate

--8-Create a report that shows the total quantity of products ordered fewer than 200.
SELECT OD.OrderID, P.ProductName, OD.Quantity
FROM [Order Details] OD
JOIN Products P
ON OD.ProductID = P.ProductID 
WHERE OD.Quantity < 200
ORDER BY 3 DESC

--9-Create a report that shows the total number of orders by Customer since December 31, 1996 and the NumOfOrders is greater than 15. 
SELECT OD.OrderID, O.CustomerID, O.OrderDate, COUNT(OD.OrderID)NumofOrders
FROM [Order Details] OD
JOIN Orders O
ON OD.OrderID = O.OrderID
WHERE (O.OrderDate > '1996-12-31')
GROUP BY OD.OrderID, O.CustomerID, O.OrderDate
HAVING COUNT(OD.OrderID) > 15


--10-Create a report that shows the company name, order id, and total price of all products of which Northwind
-- has sold more than $10,000 worth.
SELECT O.OrderID, P.ProductName, C.CompanyName,  
ROUND(SUM((OD.UnitPrice- OD.Discount*OD.UnitPrice)* OD.Quantity),2)TotalPrice
FROM [Order Details] OD
JOIN Products P 
ON OD.ProductID =P.ProductID
JOIN Orders O
ON OD.OrderID = O.OrderID
JOIN Customers C
ON O.CustomerID = C.CustomerID
GROUP BY C.CompanyName, O.OrderID, P.ProductName
HAVING ROUND(SUM((OD.UnitPrice- OD.Discount*OD.UnitPrice)* OD.Quantity),2) > 10000

--11-Create a report showing the Order ID, the name of the company that placed the order,
--and the first and last name of the associated employee. Only show orders placed after January 1, 1998 
--that shipped after they were required. Sort by Company Name.

SELECT O.OrderID, C.CompanyName, E.FirstName+' '+E.LastName EmployeeName, 
O.OrderDate,O.ShippedDate, O.RequiredDate
FROM [Order Details] OD
JOIN Orders O
ON OD.OrderID = O.OrderID
JOIN Customers C
ON O.CustomerID = C.CustomerID
JOIN Employees E
ON O.EmployeeID = E.EmployeeID
WHERE O.OrderDate > '1998-01-01' AND (O.ShippedDate > O.RequiredDate)
ORDER BY C.CompanyName




--12-Get the phone numbers of all shippers, customers, and suppliers

SELECT C.Phone CustomerPhone, S.Phone ShipperPhone, SP.Phone SupplierPhone
FROM Orders O
JOIN Customers C
ON O.CustomerID = C.CustomerID
JOIN Shippers S
ON O.ShipVia = S.ShipperID
JOIN [Order Details] OD
ON O.OrderID = OD.OrderID
JOIN Products P
ON OD.ProductID = P.ProductID
JOIN Suppliers SP
ON P.SupplierID = SP.SupplierID

--13-Create a report showing the contact name and phone numbers for all employees,customers, and suppliers.

SELECT C.ContactName Customer, C.Phone, E.FirstName+' '+E.LastName EmployeeName, E.HomePhone Phone, 
SP.ContactName Supplier, SP.Phone
FROM Orders O
JOIN Customers C
ON O.CustomerID = C.CustomerID
JOIN Employees E
ON O.EmployeeID = E.EmployeeID
JOIN [Order Details] OD
ON O.OrderID = OD.OrderID
JOIN Products P
ON OD.ProductID = P.ProductID
JOIN Suppliers SP
ON P.SupplierID = SP.SupplierID

--14-Fetch all the orders for a given customer’s phone number 030-0074321.
SELECT C.ContactName Customer, C.Phone,  O.* 
FROM Orders O
JOIN Customers C
ON O.CustomerID = C.CustomerID
WHERE Phone = '030-0074321'

--15-Fetch all the products which are available under Category ‘Seafood’.
SELECT P.ProductID, P.ProductName, C.CategoryID, C.CategoryName
FROM Products P
JOIN Categories C
ON P.CategoryID = C.CategoryID
WHERE C.CategoryName = 'SEAFOOD'

--16-Fetch all the products which are supplied by a company called ‘Pavlova, Ltd.’
SELECT P.ProductID, P.ProductName, S.CompanyName
FROM Products P
JOIN Suppliers S
ON P.SupplierID = S.SupplierID
WHERE S.CompanyName = 'PAVLOVA, LTD.'

--17-All orders placed by the customers belong to London city.

SELECT C.CompanyName, C.City, O.OrderID
FROM Orders O
LEFT JOIN Customers C
ON O.CustomerID = C.CustomerID
WHERE C.City = 'LONDON'
order by 1


--18-All orders placed by the customers not belong to London city.

SELECT C.CompanyName, C.City, O.OrderID, O.ShipCity
FROM Orders O
LEFT JOIN Customers C
ON O.CustomerID = C.CustomerID
WHERE C.City <> 'LONDON'
order by 2

--19-All the orders placed for the product Chai.
SELECT OD.*, P.ProductName
FROM [Order Details] OD
JOIN Products P
ON OD.ProductID = P.ProductID
WHERE P.ProductName = 'CHAI'

--20-Find the name of the company that placed order 10290.
SELECT C.CompanyName
FROM Orders O
JOIN Customers C
ON O.CustomerID = C.CustomerID
WHERE O.OrderID = 10290

--21-Find the Companies that placed orders in 1997
SELECT C.CompanyName, O.OrderDate
FROM Orders O
JOIN Customers C
ON O.CustomerID = C.CustomerID
WHERE O.OrderDate LIKE '%1997%'

--22-Get the product name , count of orders processed 
SELECT P.ProductName, COUNT(OD.OrderID)NumberofOrders
FROM [Order Details] AS OD
JOIN Products AS P
ON OD.ProductID = P.ProductID
GROUP BY  P.ProductName
--23-Get the top 3 products which has more orders

SELECT TOP 3 P.ProductName, COUNT(OD.OrderID)NumberofOrders
FROM [Order Details] AS OD
JOIN Products AS P
ON OD.ProductID = P.ProductID
GROUP BY  P.ProductName
ORDER BY 2 DESC

--24-Get the list of employees who processed the order “chai”
SELECT O.OrderID, P.ProductName, E.FirstName+' '+E.LastName Employee
FROM [Order Details] OD
JOIN Products P
ON OD.ProductID = P.ProductID
JOIN Orders O
ON OD.OrderID = O.OrderID
JOIN Employees E
ON O.EmployeeID =E.EmployeeID
WHERE P.ProductName = 'CHAI'

--25-Get the shipper company who processed the order categories “Seafood” 
SELECT DISTINCT S.CompanyName ShipperCompany
FROM Orders O
JOIN Shippers S
ON O.ShipVia = S.ShipperID
JOIN [Order Details] OD
ON O.OrderID = OD.OrderID
JOIN Products P
ON OD.ProductID = P.ProductID
JOIN Categories C
ON P.CategoryID = C.CategoryID
WHERE C.CategoryName = 'SEAFOOD'

--26-Get category name , count of orders processed by the USA employees 
SELECT C.CategoryName, E.Country, COUNT(O.OrderID)NoofOrders
FROM Orders O
JOIN Employees E
ON O.EmployeeID = E.EmployeeID
JOIN [Order Details] OD
ON O.OrderID = OD.OrderID
JOIN Products P
ON OD.ProductID = P.ProductID
JOIN Categories C
ON P.CategoryID = C.CategoryID
WHERE E.COUNTRY = 'USA'
GROUP BY  C.CategoryName, E.Country


--27-Select CategoryName and Description from the Categories table sorted by CategoryName.
SELECT C.CategoryName, C.Description
FROM Categories C
ORDER BY C.CategoryName

--28-Select ContactName, CompanyName, ContactTitle, and Phone from the Customers table sorted byPhone.
SELECT ContactName, CompanyName, ContactTitle, Phone
FROM Customers 
ORDER BY Phone

--29-Create a report showing employees' first and last names and hire dates sorted from newest to oldest employee
SELECT FirstName, LastName, HireDate
FROM Employees
ORDER BY 3 DESC

--30-Create a report showing Northwind's orders sorted by Freight from most expensive to cheapest. Show OrderID, 
--OrderDate, ShippedDate, CustomerID, and Freight
SELECT O.OrderID, O.OrderDate, O.ShippedDate, O.CustomerID, O.Freight
FROM ORDERS O
ORDER BY O.Freight DESC

--31-Select CompanyName, Fax, Phone, HomePage and Country from the Suppliers table sorted by Country in descending 
--order and then by CompanyName in ascending order
SELECT CompanyName, Fax, Phone, HomePage, Country
FROM Suppliers
ORDER BY Country DESC, CompanyName ASC

--32-Create a report showing all the company names and contact names of Northwind's customers in Buenos Aires
SELECT CompanyName, ContactName, City
FROM Customers 
WHERE City = 'BUENOS AIRES'

--33-Create a report showing the product name, unit price and quantity per unit of all products that are out of stock
SELECT ProductName, UnitPrice, QuantityPerUnit
FROM Products
WHERE UnitsInStock = 0

--34-Create a report showing the order date, shipped date, customer id, and freight of all orders placed on May 19, 1997
SELECT OrderID, OrderDate, ShippedDate, CustomerID, Freight
FROM Orders
WHERE OrderDate = '1997-05-19'

--35-Create a report showing the first name, last name, and country of all employees not in the United States.
SELECT FirstName, LastName, Country
FROM Employees
WHERE COUNTRY <> 'USA'

--36-Create a report that shows the city, company name, and contact name of all customers who are in cities that begin with "A" or "B."
SELECT City, CompanyName, ContactName
FROM Customers
WHERE City LIKE '[AB]%'

--37-Create a report that shows all orders that have a freight cost of more than $500.00.
SELECT O.*
 --O.OrderID, O.OrderDate, O.ShippedDate, O.CustomerID, O.Freight
FROM ORDERS O
WHERE O.Freight > 500
ORDER BY O.Freight DESC

--38-Create a report that shows the product name, units in stock, units on order, and reorder level of all
-- products that are up for reorder
SELECT ProductName, UnitsInStock, UnitsOnOrder, ReorderLevel
FROM Products P
where UnitsInStock = 0

--39-Create a report that shows the company name, contact name and fax number of all customers that have a fax number.
SELECT CompanyName, ContactName, Fax
FROM Customers
WHERE Fax IS NOT NULL

--40-Create a report that shows the first and last name of all employees who do not report to anybody
SELECT FirstName, LastName
FROM Employees
WHERE ReportsTo IS NULL

--41-Create a report that shows the company name, contact name and fax number of all customers that have a fax number, 
--Sort by company name.
SELECT CompanyName, ContactName, Fax
FROM Customers
WHERE Fax IS NOT NULL
ORDER BY CompanyName

--42-Create a report that shows the city, company name, and contact name of all customers who are in cities 
--that begin with "A" or "B." Sort by contact name in descending order
SELECT City, CompanyName, ContactName
FROM Customers
WHERE City LIKE '[AB]%'
ORDER BY ContactName DESC

--43-Create a report that shows the first and last names and birth date of all employees born in the 1950s
SELECT FirstName, LastName, BirthDate
FROM Employees
WHERE BirthDate LIKE '%195_%'

--44-Create a report that shows the shipping postal code, order id, and order date for all orders with a ship postal code 
--beginning with "02389".
SELECT OrderID,  OrderDate, ShipPostalCode
FROM Orders
WHERE ShipPostalCode LIKE '02389%'

--45-Create a report that shows the contact name and title and the company name for all customers whose contact title
-- does not contain the word "Sales".
SELECT ContactName, ContactTitle, CompanyName
FROM Customers
WHERE ContactTitle  NOT LIKE '%SALES%'

--46-Create a report that shows the first and last names and cities of employees from cities other than Seattle
-- in the state of Washington.
SELECT FirstName, LastName, City
FROM Employees
WHERE City <> 'SEATTLE' AND Region = 'WA'

--47-Create a report that shows the company name, contact title, city and country of all customers in Mexico 
--or in any city in Spain except Madrid.
SELECT CompanyName, ContactTitle, City, Country
FROM Customers
WHERE (Country = 'MEXICO') OR (COUNTRY = 'SPAIN' AND City <> 'MADRID')

--48-List of Employees along with the Manager
SELECT M.EmployeeID, M.FirstName+' '+M.LastName Employee, E.FirstName+' '+E.LastName Manager
FROM Employees M
JOIN Employees E
ON M.ReportsTo = E.EmployeeID

--49-List of Employees along with the Manager and his/her title
SELECT M.FirstName+' '+M.LastName Employee, M.Title, E.FirstName+' '+E.LastName Manager, E.Title
FROM Employees M
JOIN Employees E
ON M.ReportsTo = E.EmployeeID

--50-Provide Agerage Sales per order

SELECT O.OrderID, O.OrderDate, O.CustomerID ,ROUND(AVG(UnitPrice * (1- Discount)* Quantity),2)AVGSales
FROM Orders O
JOIN [Order Details] OD
ON O.OrderID = OD.OrderID
GROUP BY O.OrderID, O.OrderDate, O.CustomerID 

--51-Employee wise Agerage Freight
SELECT O.EmployeeID, E.FirstName+' '+E.LastName EmployeeName, AVG(O.Freight) AggFreight
FROM Orders AS O
JOIN Employees AS E
ON O.EmployeeID = E.EmployeeID
GROUP BY O.EmployeeID, E.FirstName+' '+E.LastName
ORDER BY 2, 3 DESC

--52-Agerage Freight per employee
SELECT O.EmployeeID, E.FirstName+' '+E.LastName EmployeeName, AVG(O.Freight) AggFreight
FROM Orders AS O
JOIN Employees AS E
ON O.EmployeeID = E.EmployeeID
GROUP BY O.EmployeeID, E.FirstName+' '+E.LastName
ORDER BY 2, 3 DESC

--53-Average no. of orders per customer

SELECT C.CustomerID, C.CompanyName, COUNT(O.OrderID) as OrderCount
FROM Orders AS O
JOIN Customers AS C
ON O.CustomerID = C.CustomerID
GROUP BY C.CustomerID, C.CompanyName;

--54-AverageSales per product within Category
WITH TotalSales AS
(
SELECT OD.OrderID, P.ProductName, C.CategoryName,(OD.UnitPrice*(OD.Quantity - OD.Discount))TotalSale
FROM [Order Details] OD
JOIN Products P
ON OD.ProductID = P.ProductID
JOIN Categories C
ON P.CategoryID = C.CategoryID
)
SELECT T.ProductName, T.CategoryName, ROUND(AVG(T.TotalSale),2)ProductwiseAvgSale
FROM TotalSales  as T
GROUP BY T.ProductName, T.CategoryName;

--55-PoductName which have more than 100 no.of UnitsinStock
SELECT ProductName, UnitsInStock
FROM Products 
WHERE UnitsInStock > 100

--56-Query to Provide Product Name and Sales Amount for Category Beverages
SELECT P.ProductName, C.CategoryName,(OD.UnitPrice*(OD.Quantity - OD.Discount))TotalSale
FROM [Order Details] OD
JOIN Products P
ON OD.ProductID = P.ProductID
JOIN Categories C
ON P.CategoryID = C.CategoryID
WHERE C.CategoryName = 'Beverages'

--57-Query That Will Give  CategoryWise Yearwise number of Orders
SELECT YEAR(O.OrderDate) Year, C.CategoryName, COUNT(O.OrderID)NoOfOrders
FROM Orders O
JOIN [Order Details] OD
ON O.OrderID = OD.OrderID
JOIN Products P
ON OD.ProductID = P.ProductID
JOIN Categories C
ON P.CategoryID = C.CategoryID
GROUP BY C.CategoryName, YEAR(O.OrderDate)
ORDER BY 1 DESC, 2 ASC

--58-Query to Get ShipperWise employeewise Total Freight for shipped year 1997
SELECT S.CompanyName, E.FirstName+' '+E.LastName Employee, SUM(O.Freight)TotalFrieght
FROM Orders AS O
JOIN Employees AS E
ON O.EmployeeID = E.EmployeeID
JOIN Shippers S
ON O.ShipVia = S.ShipperID
GROUP BY S.CompanyName, E.FirstName+' '+E.LastName
ORDER BY 1,3 DESC

--59-Query That Gives Employee Full Name, Territory Description and Region Description
SELECT E.FirstName+' '+E.LastName FullName, T.TerritoryDescription, R.RegionDescription
FROM Employees E
JOIN EmployeeTerritories ET
ON E.EmployeeID = ET.EmployeeID
JOIN Territories T
ON ET.TerritoryID = T.TerritoryID
JOIN Region R
ON T.RegionID = R.RegionID;

--60-Query That Will Give Managerwise Total Sales for each year 
SELECT M.FirstName+' '+M.LastName ManagerName, ROUND(SUM(OD.UnitPrice*(OD.Quantity - OD.Discount)),2)TotalSale
FROM Orders O
JOIN Employees M
ON O.EmployeeID = M.EmployeeID
JOIN Employees E
ON M.EmployeeID = E.ReportsTo
JOIN [Order Details] OD
ON O.OrderID = OD.OrderID
GROUP BY M.FirstName+' '+M.LastName;

--61-Names of customers to whom we are sellinng less than average sales per cusotmer
-- Find customers selling less than average sales per customer

WITH CTE AS 
(
SELECT C.CompanyName, 
SUM(OD.UnitPrice * (OD.Quantity - OD.Discount)) AS TotalSale
FROM Orders O
JOIN Customers C
ON O.CustomerID = C.CustomerID
JOIN [Order Details] OD
ON O.OrderID = OD.OrderID
GROUP BY C.CompanyName
)
SELECT CompanyName, TotalSale
FROM CTE
WHERE TotalSale < (
SELECT AVG(TotalSale) AS AvgSale
FROM CTE
)
--62-Query That Gives Average Freight Per Employee and Average Freight Per Customer
SELECT E.FirstName+' '+E.LastName Employee, C.CompanyName, AVG(O.Freight)AverageFreight 
FROM Orders O
JOIN Employees E
ON O.EmployeeID = E.EmployeeID
JOIN Customers C
ON O.CustomerID = C.CustomerID
GROUP BY  E.FirstName+' '+E.LastName, C.CompanyName
--ORDER BY 1,2

--63-Query That Gives Category Wise Total Sale Where Category Total Sale < the Average Sale Per Category
;WITH CTE as
(
SELECT C.CategoryName, ROUND(SUM(OD.UnitPrice * (OD.Quantity - OD.Discount)),2)TotalSale
FROM [Order Details] OD
JOIN Products P
ON OD.ProductID = P.ProductID
JOIN Categories C
ON P.CategoryID = C.CategoryID
GROUP BY C.CategoryName
)
SELECT CategoryName, TotalSale
FROM CTE
where TotalSale < (SELECT AVG(TotalSale) FROM CTE)

--64-Query That Provides Month No and Month OF Total Sales < Average Sale for Month for Year 1997
WITH TEMP AS
(
SELECT MONTH(OrderDate) MONTH, YEAR(OrderDate)YEAR, ROUND(SUM(OD.UnitPrice * (OD.Quantity - OD.Discount)),2)TotalSale
FROM Orders O
JOIN [Order Details] OD
ON O.OrderID = OD.OrderID
GROUP BY MONTH(OrderDate), YEAR(OrderDate)
)
SELECT MONTH, TotalSale
FROM TEMP
WHERE TotalSale < (SELECT AVG(TotalSale) FROM TEMP WHERE YEAR = 1997)

--65-Find out the contribution of each employee towards the total sales done by Northwind for selected year

WITH EmployeewiseSales AS
(
SELECT E.FirstName+' '+E.LastName EmployeeName, YEAR(O.OrderDate) YEAR, ROUND(SUM(OD.UnitPrice * (OD.Quantity - OD.Discount)),2)TotalSale
FROM Orders O
JOIN [Order Details] OD
ON O.OrderID = OD.OrderID
JOIN Employees E
ON O.EmployeeID = E.EmployeeID
GROUP BY E.FirstName+' '+E.LastName, YEAR(O.OrderDate)
)
SELECT EmployeeName, YEAR, ROUND((TotalSale/(SELECT SUM(TotalSale) FROM EmployeewiseSales WHERE YEAR = 1997 )*100),2)Contribution
FROM EmployeewiseSales
WHERE YEAR = 1997

--66-Give the Customer names that contribute 80% of the total sale done by Northwind for given year
WITH TEMP AS
(
SELECT C.CompanyName CustomerName,YEAR(O.OrderDate) YEAR, ROUND(SUM(OD.UnitPrice * (OD.Quantity - OD.Discount)),2)TotalSale
FROM [Order Details] OD
JOIN Orders O
ON OD.OrderID = O.OrderID
JOIN Customers C
ON O.CustomerID = C.CustomerID
GROUP BY C.CompanyName,YEAR(O.OrderDate)
HAVING YEAR(O.OrderDate) = 1998
)
SELECT CustomerName, ROUND((TotalSale/(SELECT SUM(TotalSale) FROM TEMP)*100),2)Contribution
FROM TEMP
ORDER BY 2 DESC


--67-Top 3 performing employees by freight cost for given year
WITH TEMP AS
(
SELECT E.FirstName+' '+E.LastName Employee, O.Freight, RANK() OVER(ORDER BY Freight DESC) RK
FROM Orders O
JOIN Employees E
ON O.EmployeeID = E.EmployeeID
WHERE YEAR(O.OrderDate) = 1998
)
SELECT Employee, Freight
FROM TEMP
WHERE RK <4

--68-Find the bottom 5 customers per product based on Sales Amount
WITH TEMP AS
(
SELECT E.FirstName+' '+E.LastName Employee, O.Freight, RANK() OVER(ORDER BY Freight ASC) RK
FROM Orders O
JOIN Employees E
ON O.EmployeeID = E.EmployeeID
WHERE YEAR(O.OrderDate) = 1998
)
SELECT Employee, Freight
FROM TEMP
WHERE RK <= 5

--69-Display first and the last row of the table

WITH FIRST AS 
(
SELECT E.*, ROW_NUMBER() OVER(ORDER BY EmployeeId)RN
FROM Employees E
), LAST AS
(
SELECT E.*, ROW_NUMBER() OVER(ORDER BY EmployeeId DESC)RN
FROM Employees E
)
SELECT * FROM FIRST WHERE RN = 1
UNION ALL
SELECT * FROM LAST WHERE RN = 1

--70-Display employee doing highest sale and lowest sale in each year
WITH SALES AS
(
SELECT E.FirstName+' '+E.LastName EmployeeName, YEAR(O.OrderDate) YEAR, ROUND(SUM(OD.UnitPrice * (OD.Quantity - OD.Discount)),2)TotalSale
FROM Orders o
JOIN Employees e
ON O.EmployeeID = E.EmployeeID
JOIN [Order Details] OD
ON O.OrderID = OD.OrderID
GROUP BY E.FirstName+' '+E.LastName, YEAR(O.OrderDate)
), MAX as 
(SELECT *, RANK() OVER (PARTITION BY YEAR ORDER BY TotalSale desc)SalesRank from SALES
),MIN AS
(SELECT *, RANK() OVER (PARTITION BY YEAR ORDER BY TotalSale ASC)SalesRank from SALES)
SELECT * FROM MAX
WHERE SalesRank = 1
UNION
SELECT * 
FROM MIN
WHERE SalesRank = 1
ORDER BY YEAR

--71-Top 3 products of each employee by sales for given year
WITH SALES AS
(
SELECT P.ProductName Product, E.FirstName+' '+E.LastName EmployeeName, YEAR(O.OrderDate) YEAR, 
ROUND(SUM(OD.UnitPrice * (OD.Quantity - OD.Discount)),2)TotalSale
FROM Orders o
JOIN Employees e
ON O.EmployeeID = E.EmployeeID
JOIN [Order Details] OD
ON O.OrderID = OD.OrderID
JOIN Products P
ON OD.ProductID = P.ProductID
GROUP BY P.ProductName, E.FirstName+' '+E.LastName, YEAR(O.OrderDate)
HAVING YEAR(O.OrderDate) = 1998
),EmployeeWiseProductSale AS
(
SELECT S.*, RANK() OVER (PARTITION BY S.EmployeeName ORDER BY TotalSale DESC)RNK
FROM SALES AS S
)
SELECT *
FROM EmployeeWiseProductSale
WHERE RNK <= 3

--72-Query That Will Give territorywise number of Orders for given region for given year
SELECT T.TerritoryID, T.TerritoryDescription Territory, R.RegionDescription, COUNT(O.OrderID)NoOfOrders
FROM Orders O
JOIN Employees E
ON O.EmployeeID =E.EmployeeID
JOIN EmployeeTerritories ET
ON E.EmployeeID = ET.EmployeeID
JOIN Territories T
ON ET.TerritoryID = T.TerritoryID
JOIN Region R
ON T.RegionID = R.RegionID
WHERE R.RegionDescription= 'WESTERN' AND YEAR(O.OrderDate) = 1997
GROUP BY T.TerritoryID, T.TerritoryDescription, R.RegionDescription
 
--73-Display sales amount by category for given year
SELECT C.CategoryID, C.CategoryName, ROUND(SUM(OD.UnitPrice * (OD.Quantity - OD.Discount)),2)TotalSale
FROM [Order Details] OD
JOIN Products P
ON OD.ProductID = P.ProductID
JOIN Categories C
ON P.CategoryID = C.CategoryID
GROUP BY C.CategoryID, C.CategoryName

--74-Find  name  of customers who has registered orders less than 10 times.
SELECT C.CustomerID, C.CompanyName CustomerName, COUNT(O.OrderID)NoOfOrders
FROM Orders O
JOIN Customers C
ON O.CustomerID =C.CustomerID
GROUP BY C.CustomerID, C.CompanyName
HAVING COUNT(O.OrderID) < 10
ORDER BY 2

--75-Regions with the Sale in the range of +/- 30% of average sale per Region for year 1997...
WITH RegionwiseTotalSales as
(
SELECT R.RegionDescription Region, YEAR(O.OrderDate) Year, ROUND(SUM(OD.UnitPrice * (OD.Quantity - OD.Discount)),2)TotalSale
FROM Orders O
JOIN [Order Details] OD
ON O.OrderID = OD.OrderID
JOIN Employees E
ON O.EmployeeID =E.EmployeeID
JOIN EmployeeTerritories ET
ON E.EmployeeID = ET.EmployeeID
JOIN Territories T
ON ET.TerritoryID = T.TerritoryID
JOIN Region R
ON T.RegionID = R.RegionID
--WHERE YEAR(O.OrderDate) = 1997
GROUP BY R.RegionDescription, YEAR(O.OrderDate)
), RegionwisePercentSales as
(
SELECT Region, Year, TotalSale, ROUND(TotalSale/SUM(TotalSale) OVER ()*100,2) SalePercent
FROM RegionwiseTotalSales
WHERE Year = 1997
GROUP BY Region, Year, TotalSale
)
SELECT Region, TotalSale, SalePercent
FROM RegionwisePercentSales
WHERE SalePercent BETWEEN -30 AND 30

--76-Top 5 countries based on Order Count for year 1998...

--CHECK IF SHIP COUNTRY AND CUSTOMER COUNTRY SAME
--SELECT O.ShipCountry, C.Country, COUNT(O.OrderID)
--FROM Orders O 
--JOIN Customers C
--ON O.CustomerID = C.CustomerID
--WHERE O.ShipCountry != C.Country
--GROUP BY O.ShipCountry, C.Country;

WITH CountrywiseCount AS
(
SELECT O.ShipCountry, COUNT(O.OrderID)NoOfOrders
FROM Orders O
WHERE YEAR(O.OrderDate)= 1998
GROUP BY O.ShipCountry
--ORDER BY 2 DESC
)
SELECT TOP 5 ShipCountry, NoOfOrders, RANK() OVER(ORDER BY NoOfOrders DESC)RNK
FROM CountrywiseCount

--77-Category-wise Sale along with deviation % wrt average sale per category for year 1996...

WITH CategorywiseTotalSale as 
(
SELECT C.CategoryName, YEAR(O.OrderDate) Year, ROUND(SUM(OD.UnitPrice * (OD.Quantity - OD.Discount)),2)TotalSale
FROM Orders O
JOIN [Order Details] OD
ON  O.OrderID = OD.OrderID
JOIN Products P
ON OD.ProductID = P.ProductID
JOIN Categories C
ON P.CategoryID = C.CategoryID
GROUP BY C.CategoryName, YEAR(O.OrderDate)
HAVING YEAR(O.OrderDate) = 1996
), CategorywiseSalePercent as
(
SELECT CategoryName, TotalSale,(TotalSale - AVG(TotalSale) OVER ())Deviation, 
ROUND(TotalSale / SUM(TotalSale) OVER ()*100,2)SalePercent
FROM CategorywiseTotalSale
GROUP BY CategoryName, TotalSale
)
SELECT CategoryName, SalePercent, Deviation
FROM CategorywiseSalePercent ;

--78-Count of orders by Customers which are shipped in the same month as ordered...
SELECT C.CompanyName CustomerName, COUNT(O.OrderID)TotalOrders
FROM Orders O
JOIN Customers C
ON O.CustomerID = C.CustomerID
WHERE MONTH(O.OrderDate) = MONTH(O.ShippedDate)
GROUP BY C.CompanyName 

--79-Average Demand Days per Order per country for year 1997...
SELECT O.OrderID,O.ShipCountry,YEAR(O.ORDERDATE) Year, AVG(DAY(O.ShippedDate - O.OrderDate))DemandDays
FROM Orders O
WHERE YEAR(O.ORDERDATE) = 1997
GROUP BY O.OrderID,O.ShipCountry, YEAR(O.ORDERDATE);

--80-Create the report as Country, Classification, Product Count, Average Sale per Product, Threshold... 
--Classification will be based on Sales and as follows -
--Top if the sale is 1.5 times the average sale per product...
--Excellent if the sale is between 1.2 and 1.5 times the average sale per product...
--Acceptable if the sale is between 0.8 to 1.2 time the average sale per product...
--Need Improvement if the sale is 0.5 to 0.8 times the average sale per product...
--Discontinue for remaining products...
--Produce this report for year 1998..

WITH SALE AS
(
SELECT P.ProductName, O.ShipCountry Country, COUNT(P.ProductID) ProductCount, ROUND(SUM(OD.UnitPrice * (OD.Quantity - OD.Discount)),2)Sale
FROM Orders O
JOIN [Order Details] OD
ON O.OrderID = OD.OrderID
JOIN Products P
ON OD.ProductID = P.ProductID
WHERE YEAR(O.OrderDate) = 1998
GROUP BY P.ProductName, O.ShipCountry 
)
SELECT S.*,
(SELECT AVG(Sale) FROM SALE) AS AvgSale,
 CASE 
 WHEN S.Sale >= 1.5 * (SELECT AVG(Sale) FROM SALE) THEN 'Top'
 WHEN S.Sale BETWEEN 1.2 *(SELECT AVG(Sale) FROM SALE) AND 1.5 * (SELECT AVG(Sale) FROM SALE) THEN 'Excellent'
 WHEN S.Sale BETWEEN 0.8 *(SELECT AVG(Sale) FROM SALE) AND 1.2 * (SELECT AVG(Sale) FROM SALE) THEN 'Acceptable'
 WHEN S.Sale BETWEEN 0.5 * (SELECT AVG(Sale) FROM SALE)AND 0.8 *(SELECT AVG(Sale) FROM SALE) THEN 'Need Improvement'
 ELSE 'Discontinue'
 END AS Classification
FROM SALE S
ORDER BY Sale DESC

--81-Top 30% products in each Category by their Sale for year 1997...
WITH CategorywiseSale as
(SELECT P.ProductName, C.CategoryName ,ROUND(SUM(OD.UnitPrice * (OD.Quantity - OD.Discount)),2)Sale
FROM Orders O
JOIN [Order Details] OD 
ON O.OrderID = OD.OrderID
JOIN Products P
ON OD.ProductID =P.ProductID
JOIN Categories C
ON P.CategoryID = C.CategoryID
WHERE YEAR(O.OrderDate) = 1997
GROUP BY P.ProductName, C.CategoryName
), 
ToptoBottomSale AS(
SELECT *, PERCENT_RANK() OVER ( PARTITION BY CategoryName ORDER BY Sale DESC)RK
from CategorywiseSale) 
SELECT *
FROM ToptoBottomSale
where RK <= 0.3
ORDER BY CategoryName, SALE DESC


--82-Bottom 40% countries by the Freight for year 1997 along with the Freight to Sale ratio in %...
WITH CountrywiseFreightandSale as 
(
SELECT O.ShipCountry, ROUND(SUM(OD.UnitPrice * (OD.Quantity - OD.Discount)),2)Sale, SUM(O.Freight)Freight
FROM Orders O
JOIN [Order Details] OD
ON O.OrderID = OD.OrderID
WHERE YEAR(O.OrderDate) = 1997
GROUP BY O.ShipCountry
),Rank as(
SELECT *, ROUND(Freight/Sale*100, 2)FreightSaleRatio, PERCENT_RANK() OVER (ORDER BY ROUND(Freight/Sale, 2))RK
FROM CountrywiseFreightandSale
)
SELECT *
FROM Rank
WHERE RK<= 0.4
ORDER BY 4, 5

--83-Countries contributing to 50% of the total sale for the year 1997...
WITH CountrywiseSale as 
(
SELECT O.ShipCountry, ROUND(SUM(OD.UnitPrice * (OD.Quantity - OD.Discount)),2)Sale,
PERCENT_RANK() OVER (ORDER BY ROUND(SUM(OD.UnitPrice * (OD.Quantity - OD.Discount)),2) DESC)RK
FROM Orders O
JOIN [Order Details] OD
ON O.OrderID = OD.OrderID
WHERE YEAR(O.OrderDate) = 1997
GROUP BY O.ShipCountry
)
SELECT *
FROM CountrywiseSale
WHERE RK <= 0.5
ORDER BY Sale desc
--84-Top 5 repeat customers for each country in year 1997...

WITH CustomerandCountrywise_OrderCount AS
(SELECT C.CompanyName, C.Country, COUNT( O.OrderID)NoofOrders
FROM Orders O 
JOIN Customers C
ON O.CustomerID = C.CustomerID
WHERE YEAR( O.OrderDate) = 1997
GROUP BY C.CompanyName, C.Country
HAVING COUNT( O.OrderID) > 1
--ORDER BY 3 DESC
), RANKED AS 
(
SELECT *, ROW_NUMBER() OVER(PARTITION BY Country ORDER BY NoofOrders DESC)RANK
FROM CustomerandCountrywise_OrderCount)
SELECT *
FROM RANKED
WHERE RANK <= 5


--85- Week over Week Order Count and change % over previous week for year 1997 as Week Number,
-- Week Start Date, Week End Date, Order Count, Change %