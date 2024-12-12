--- Ejercicio 2: Ordenar y filtrar los resultados de una consulta

--- Sort results using the ORDER BY clause

--- No particular order
SELECT Name, ListPrice
FROM SalesLT.Product;

--- This time the products are listed in alphabetical order by Name
SELECT Name, ListPrice
FROM SalesLT.Product
ORDER BY Name;

--- The results are listed in ascending order of ListPrice. By default, the ORDER BY clause applies an ascending sort order to the specified field.
SELECT Name, ListPrice
FROM SalesLT.Product
ORDER BY ListPrice;

--- The results now show the most expensive items first.
SELECT Name, ListPrice
FROM SalesLT.Product
ORDER BY ListPrice DESC;

--- Note that they are sorted into descending order of ListPrice, and each set of products with the same price is sorted in ascending order of Name.
SELECT Name, ListPrice
FROM SalesLT.Product
ORDER BY ListPrice DESC, Name ASC;

--- Restrict results using TOP

--- The results contain the first twenty products in descending order of ListPrice.
SELECT TOP (20) Name, ListPrice
FROM SalesLT.Product
ORDER BY ListPrice DESC;
--- Typically, you include an ORDER BY clause when using the TOP parameter; otherwise the query just returns the first specified number of rows in an arbitrary order.

--- Add the WITH TIES parameter as shown here. There are multiple products that share the same price, 
--- one of which wasn’t included when ties were ignored by the previous query
SELECT TOP (20) WITH TIES Name, ListPrice
FROM SalesLT.Product
ORDER BY ListPrice DESC;

--- Add the PERCENT parameter as shown here. this time the results contain the 20% most expensive products.
SELECT TOP (20) PERCENT WITH TIES Name, ListPrice
FROM SalesLT.Product
ORDER BY ListPrice DESC;

--- Retrieve pages of results with OFFSET and FETCH

--- note the effect of the OFFSET and FETCH parameters of the ORDER BY clause
SELECT Name, ListPrice
FROM SalesLT.Product
ORDER BY Name OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;
--- The results start at the 0 position (the beginning of the result set) and include only the next 10 rows, essentially defining the first page of results with 10 rows per page.
--- to retrieve the next page of results
SELECT Name, ListPrice
FROM SalesLT.Product
ORDER BY Name OFFSET 10 ROWS FETCH NEXT 10 ROWS ONLY;

--- Use the ALL and DISTINCT options

--- The results, which includes the color of each product in the table.
SELECT Color
FROM SalesLT.Product;

---  The ALL parameter is the default behavior, and is applied implicitly to return a row for every record that meets the query criteria.
SELECT ALL Color
FROM SalesLT.Product;

--- the results include one row for each unique Color value
SELECT DISTINCT Color
FROM SalesLT.Product;

--- it returns each unique combination of color and size
SELECT DISTINCT Color, Size
FROM SalesLT.Product;

--- Filter results with the WHERE clause

--- Which contain the Name, Color, and Size for each product with a ProductModelID value of 6. Use WHERE Clause
SELECT ProductModelID, Name, Color, Size
FROM SalesLT.Product
WHERE ProductModelID = 6 
ORDER BY Name;

--- they contain all products with a ProductModelID other than 6.
SELECT ProductModelID, Name, Color, Size
FROM SalesLT.Product
WHERE ProductModelID <> 6 
ORDER BY Name;

--- They contain all products with a ListPrice greater than 1000.00.
SELECT Name, ListPrice
FROM SalesLT.Product
WHERE ListPrice > 1000
ORDER BY ListPrice;

--- Noting that the LIKE operator enables you to match string patterns. The % character in the predicate is a wildcard for one or more characters, 
--- so the query returns all rows where the Name is HL Road Frame followed by any string.
SELECT Name, ListPrice
FROM SalesLT.Product
WHERE Name LIKE 'HL Road Frame %'
--- The LIKE operator can be used to define complex pattern matches based on regular expressions, which can be useful when dealing with string data that follows a predictable pattern.

--- This time the results include products with a ProductNumber that matches patterns similar to FR-xNNx-NN (in which x is a letter and N is a numeral).
SELECT ProductNumber, Name, ListPrice
FROM SalesLT.Product
WHERE ProductNumber LIKE 'FR-_[0-9][0-9]_-[0-9][0-9]';

--- Note that to filter based on NULL values you must use IS NULL (or IS NOT NULL) you cannot compare a NULL value using the = operator.
SELECT SellEndDate, Name, ListPrice
FROM SalesLT.Product
WHERE SellEndDate IS NOT NULL;

--- the following query, which uses the BETWEEN operator to define a filter based on values within a defined range.
SELECT SellEndDate, Name, ListPrice
FROM SalesLT.Product
WHERE SellEndDate BETWEEN '2006/1/1' AND '2006/12/31';

--- the following query, which retrieves products with a ProductCategoryID value that is in a specified list.
SELECT ProductCategoryID, Name, ListPrice
FROM SalesLT.Product
WHERE ProductCategoryID IN (5,6,7);

--- The following query, which uses the AND operator to combine two criteria.
SELECT ProductCategoryID, Name, ListPrice, SellEndDate
FROM SalesLT.Product
WHERE ProductCategoryID IN (5,6,7) AND SellEndDate IS NULL;

--- the following query, which filters the results to include rows that match one (or both) of two criteria.
SELECT  Name, ProductCategoryID, ProductNumber
FROM SalesLT.Product
WHERE ProductNumber LIKE 'FR%' OR ProductCategoryID IN (5,6,7);

--- CHALLENGES

--- Challenge 1: Retrieve data for transportation reports
--- 1. Retrieve a list of cities 
    --- Initially, you need to produce a list of all of you customers’ locations. Write a Transact-SQL query that queries the SalesLT.Address table 
    ---and retrieves the values for City and StateProvince, removing duplicates and sorted in ascending order of city.
SELECT City, StateProvince
FROM SalesLT.Address
ORDER BY City;
    
---2. Retrieve the heaviest products
	--- Transportation costs are increasing and you need to identify the heaviest products. Retrieve the names of the top ten percent of products by weight.
SELECT TOP (10) PERCENT WITH TIES Name, ListPrice, Weight
FROM SalesLT.Product
ORDER BY Weight DESC;

--- Challenge 2: Retrieve product data
--- 1. Retrieve product details for product model 1
	---Initially, you need to find the names, colors, and sizes of the products with a product model ID 1.
    SELECT Name, Color, Size 
    FROM SalesLT.Product
    WHERE ProductModelID = 1;
    
    
--- 2. Filter products by color and size
	--- Retrieve the product number and name of the products that have a color of black, red, or white and a size of S or M.
	SELECT ProductNumber, Name, Color, Size 
    FROM SalesLT.Product
    WHERE Color IN ('black', 'red', 'white') OR Size IN ('S', 'M');
    
    
--- 3. Filter products by product number
	--- Retrieve the product number, name, and list price of products whose product number begins BK-
	SELECT ProductNumber, Name, ListPrice
    FROM SalesLT.Product
    WHERE ProductNumber LIKE 'BK%';
    
    
--- 4. Retrieve specific products by product number
    --- Modify your previous query to retrieve the product number, name, and list price of products whose product number begins BK- followed by any character other than R,
    --- and ends with a - followed by any two numerals.
	SELECT ProductNumber, Name, ListPrice
    FROM SalesLT.Product
    WHERE ProductNumber LIKE 'BK-[^R]%-[0-9][0-9]';

