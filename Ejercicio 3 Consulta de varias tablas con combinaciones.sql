--- Ejercicio 3: Consulta de varias tablas con combinaciones

--- Query Multiple Tables with Joins

--- Use inner joins
SELECT SalesLT.Product.Name AS ProductName, SalesLT.ProductCategory.Name AS Category 
FROM SalesLT.Product
INNER JOIN SalesLT.ProductCategory
ON SalesLT.Product.ProductCategoryID = SalesLT.ProductCategory.ProductCategoryID;
--- which include the ProductName from the products table and the corresponding Category from the product category table. Because the query uses an INNER join, 
--- any products that do not have corresponding categories, and any categories that contain no products are omitted from the results.

--- Modify the query as follows to remove the INNER keyword
SELECT SalesLT.Product.Name AS ProductName, SalesLT.ProductCategory.Name AS Category
FROM SalesLT.Product
JOIN SalesLT.ProductCategory
ON SalesLT.Product.ProductCategoryID = SalesLT.ProductCategory.ProductCategoryID;
--- The results should be the same as before. INNER joins are the default kind of join.

--- Modify the query to assign aliases to the tables in the JOIN clause
SELECT p.Name AS ProductName, c.Name AS Category
FROM SalesLT.Product AS p
JOIN SalesLT.ProductCategory AS c
ON p.ProductCategoryID = c.ProductCategoryID;

--- which retrieves sales order data from the SalesLT.SalesOrderHeader, SalesLT.SalesOrderDetail, and SalesLT.Product tables
 SELECT oh.OrderDate, oh.PurchaseOrderNumber, p.Name AS ProductName, od.OrderQty, od.UnitPrice
 FROM SalesLT.SalesOrderHeader AS oh
 JOIN SalesLT.SalesOrderDetail AS od
    ON od.SalesOrderID = oh.SalesOrderID
 JOIN SalesLT.Product AS p
    ON od.ProductID = p.ProductID
 ORDER BY oh.OrderDate, oh.SalesOrderID, od.SalesOrderDetailID;
 ---  it returns data from all three tables

 --- Use outer joins
 SELECT c.FirstName, c.LastName, oh.PurchaseOrderNumber
 FROM SalesLT.Customer AS c
 LEFT OUTER JOIN SalesLT.SalesOrderHeader AS oh
    ON c.CustomerID = oh.CustomerID
 ORDER BY c.CustomerID;
 --- Te results contain data for every customer. If a customer has placed an order, the order number is shown. 
 --- Customers who have registered but not placed an order are shown with a NULL order number.

--- Modify the query to remove the OUTER keyword
SELECT c.FirstName, c.LastName, oh.PurchaseOrderNumber
FROM SalesLT.Customer AS c
LEFT JOIN SalesLT.SalesOrderHeader AS oh
    ON c.CustomerID = oh.CustomerID
ORDER BY c.CustomerID;
--- which should be the same as before. Using the LEFT (or RIGHT) keyword automatically identifies the join as an OUTER join.

--- Modify the query as shown below to take advantage of the fact that it identifies non-matching rows and return only the customers who have not placed any orders.
SELECT c.FirstName, c.LastName, oh.PurchaseOrderNumber
FROM SalesLT.Customer AS c
LEFT JOIN SalesLT.SalesOrderHeader AS oh
    ON c.CustomerID = oh.CustomerID
WHERE oh.SalesOrderNumber IS NULL
ORDER BY c.CustomerID;
--- the results, which contain data for customers who have not placed any orders.

--- which uses outer joins to retrieve data from three tables.
SELECT p.Name As ProductName, oh.PurchaseOrderNumber
FROM SalesLT.Product AS p
LEFT JOIN SalesLT.SalesOrderDetail AS od
    ON p.ProductID = od.ProductID
LEFT JOIN SalesLT.SalesOrderHeader AS oh
    ON od.SalesOrderID = oh.SalesOrderID
ORDER BY p.ProductID;
 --- Note that when you join multiple tables like this, after an outer join has been specified in the join sequence, 
 --- all subsequent outer joins must be of the same direction (LEFT or RIGHT).

 --- Modify the query as shown below to add an inner join to return category information. When mixing inner and outer joins, 
 --- it can be helpful to be explicit about the join types by using the INNER and OUTER keywords.
SELECT p.Name AS ProductName, c.Name AS Category, oh.PurchaseOrderNumber
FROM SalesLT.Product AS p
LEFT OUTER JOIN SalesLT.SalesOrderDetail AS od
    ON p.ProductID = od.ProductID
LEFT OUTER JOIN SalesLT.SalesOrderHeader AS oh
    ON od.SalesOrderID = oh.SalesOrderID
INNER JOIN SalesLT.ProductCategory AS c
    ON p.ProductCategoryID = c.ProductCategoryID
 ORDER BY p.ProductID;
 --- Which include product names, categories, and sales order numbers.

--- Use a cross join

--- A cross join matches all possible combinations of rows from the tables being joined. In practice, 
--- it’s rarely used; but there are some specialized cases where it is useful.

SELECT p.Name, c.FirstName, c.LastName, c.EmailAddress
FROM SalesLT.Product AS p
CROSS JOIN SalesLT.Customer AS c;
--- note that the results contain a row for every product and customer combination (which might be used to create a mailing campaign in which an indivdual advertisement 
--- for each product is emailed to each customer - a strategy that may not endear the company to its customers!).

--- Use a self join
--- A self join isn’t actually a specific kind of join, but it’s a technique used to join a table to itself by defining two instances of the table, each with its own alias.
--- This approach can be useful when a row in the table includes a foreign key field that references the primary key of the same table; for example in a table of employees
--- where an employee’s manager is also an employee, or a table of product categories where each category might be a subcategory of another category.
SELECT pcat.Name AS ParentCategory, cat.Name AS SubCategory
FROM SalesLT.ProductCategory AS cat
JOIN SalesLT.ProductCategory AS pcat
    ON cat.ParentProductCategoryID = pcat.ProductCategoryID
ORDER BY ParentCategory, SubCategory;
---  which reflect the hierarchy of parent and sub categories.

--- CHALLENGES

--- Challenge 1: Generate invoice reports

	--- 1. Retrieve customer orders
		--- As an initial step towards generating the invoice report, write a query that returns the company name from the SalesLT.Customer table, 
        --- and the purchase order number and total due (calculated as the sub-total + tax + freight) from the SalesLT.SalesOrderHeader table.
SELECT c.CompanyName, oh.PurchaseOrderNumber, (oh.SubTotal + oh.TaxAmt + oh.Freight) AS TotalDue
FROM SalesLT.Customer AS c
JOIN SalesLT.SalesOrderHeader AS oh
ON c.CustomerID = oh.CustomerID
ORDER BY c.CompanyName
    
    
    --- 2. Retrieve customer orders with addresses
		--- Extend your customer orders query to include the Main Office address for each customer, including the full street address, city, state or province, 
        --- postal code, and country or region.

        --- Tip: Note that each customer can have multiple addressees in the SalesLT.Address table, so the database developer has created the SalesLT.CustomerAddress table
        --- to enable a many-to-many relationship between customers and addresses. Your query will need to include both of these tables, and should filter the results 
        --- so that only Main Office addresses are included.

SELECT  c.CompanyName, ca.AddressID, (a.AddressLine1 + ' ' + ISNULL(a.AddressLine2,'')) AS FullStreetAddress, 
        a.City, a.StateProvince, a.PostalCode, a.CountryRegion,
        oh.PurchaseOrderNumber, (oh.SubTotal + oh.TaxAmt + oh.Freight) AS TotalDue
FROM SalesLT.Customer AS c
JOIN SalesLT.SalesOrderHeader AS oh
ON c.CustomerID = oh.CustomerID
LEFT JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
LEFT JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID 
WHERE ca.AddressType LIKE 'Main Office'
ORDER BY c.CompanyName

--- Challenge 2: Retrieve customer data

	--- 1. Retrieve a list of all customers and their orders
		--- The sales manager wants a list of all customer companies and their contacts (first name and last name), showing the purchase order number 
        --- and total due for each order they have placed. Customers who have not placed any orders should be included at the bottom of the list with NULL values 
        --- for the purchase order number and total due.
SELECT c.CompanyName, c.FirstName, c.LastName, oh.PurchaseOrderNumber, oh.TotalDue
FROM SalesLT.Customer AS c
LEFT JOIN SalesLT.SalesOrderHeader AS oh
ON c.CustomerID = oh.CustomerID
ORDER BY oh.PurchaseOrderNumber DESC;

    
    --- 2. Retrieve a list of customers with no address
        --- A sales employee has noticed that Adventure Works does not have address information for all customers. You must write a query that returns a list of 
        --- customer IDs, company names, contact names (first name and last name), and phone numbers for customers with no address stored in the database.

SELECT  c.CustomerID, c.CompanyName, c.FirstName, c.LastName, c.phone
FROM SalesLT.Customer AS c
LEFT JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
WHERE ca.AddressID IS NULL
ORDER BY c.CustomerID


--- Challenge 3: Create a product catalog
    --- 1. Retrieve product information by category
        --- The product catalog will list products by parent category and subcategory, so you must write a query that retrieves the parent category name, subcategory name,
        --- and product name fields for the catalog.

SELECT pro.ProductID, cat.Name AS Category, scat.Name AS SubCategory,  pro.Name AS ProductName
FROM SalesLT.Product AS pro
JOIN SalesLT.ProductCategory AS scat
    ON pro.ProductCategoryID = scat.ProductCategoryID
JOIN SalesLT.ProductCategory AS cat 
    ON scat.ParentProductCategoryID = cat.ProductCategoryID
ORDER BY Category, SubCategory, ProductName;


