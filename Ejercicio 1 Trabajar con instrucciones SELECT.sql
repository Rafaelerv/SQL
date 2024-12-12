 --- Use SELECT queries to retrieve data

 SELECT* 
 FROM SalesLT.Product;
 
 SELECT Name, StandardCost, ListPrice
 FROM SalesLT.Product;
 
 SELECT Name, ListPrice - StandardCost
 FROM SalesLT.Product;
 
 SELECT Name AS ProductName, ListPrice - StandardCost AS Markup
 FROM SalesLT.Product;

 SELECT ProductNumber, Color, Size, Color + ', '+ Size AS ProductDetails
 FROM SalesLT.Product;

 --- Work with data types

--- Query returns an error
 SELECT ProductID + ': '+ Name AS ProductName
 FROM SalesLT.Product; 

 --- Use the CAST fuction to change the numeric ProductID column into a varchar (variable-length character data) value
 SELECT CAST(ProductID AS varchar(5)) + ': '+ Name AS ProductName
 FROM SalesLT.Product; 

 --- CAST function is a ANSI Standard therefore is available in most database systems, while CONVERT is a SQL Server specific function
 SELECT CONVERT(varchar(5), ProductID) + ': '+ Name AS ProductName
 FROM SalesLT.Product; 

 --- CONVERT includes an addtional parameter that can be useful for formatting date and time values when converting them to text-based data
 SELECT SellStartDate,
    CONVERT(nvarchar(30), SellStartDate) AS ConvertedDate,
    CONVERT(nvarchar(30), SellStartDate, 126) AS ISO8601FormatDate
 FROM SalesLT.Product; 

--- There is an error example because there are values that not are numeric
 SELECT Name, CAST(Size AS Integer) AS NumericSize
 FROM SalesLT.Product; 

--- Numeric values were converted to integers, but that non-numerics sizes are returned as Null
SELECT Name, TRY_CAST(Size AS Integer) AS NumericSize
FROM SalesLT.Product; 

--- Handle NULL values

--- ISNULL function Replaces NULL values with the specified value, so in this case, sizes that are not numeric are returned as 0
SELECT Name, ISNULL(TRY_CAST(Size AS Integer),0) AS NumericSize
FROM SalesLT.Product;

--- The ISNULL function replaces NULL values with a specified literal value
SELECT ProductNumber, ISNULL(Color, '') + ', '+ ISNULL(Size, '') AS ProductDetails
FROM SalesLT.Product;

--- Sometimes, you may want to achieve the opposite result by replacing an explicit value with NULL. To do this, you can use the NULLIF function.
SELECT Name, NULLIF(Color, 'Multi') AS SingleColor
FROM SalesLT.Product;

--- To find the first non-NULL column, you can use the COALESCE function.
SELECT Name, COALESCE(SellEndDate, SellStartDate) AS StatusLastUpdated
FROM SalesLT.Product;

--- The CASE expression has two variants: a simple CASE that evaluates a specific column or value, or a searched CASE that evaluates one or more expressions.
--- In this example, our CASE expression must determine if the SellEndDate column is NULL.
SELECT Name, SellEndDate,
     CASE 
     WHEN SellEndDate IS NULL 
     THEN 'Currently for sale'
     ELSE 'No longer available'
     END AS SalesStatus
 FROM SalesLT.Product;

---  it’s more appropriate to use a simple CASE expression that applies multiple WHERE…THEN predictes to the same value.
 SELECT Name, Size,
     CASE Size 
     WHEN 'S' THEN 'Small'
     WHEN 'M' THEN 'Medium'
     WHEN 'L' THEN 'Large'
     WHEN 'XL' THEN 'Extra-Large'
     ELSE ISNULL(Size, 'n/a')
     END AS ProductSize
 FROM SalesLT.Product;

--- CHALLENGES

--- CHALLENGE 1 Retrieve Customer Data
 --- 1. Retrieve customer details. Familiarize yourself with the SalesLT.Customer table by writing a Transact-SQL query that retrieves all columns for all customers.
SELECT *
FROM SalesLT.Customer;

 --- 2. Retrieve customer name data. Create a list of all customer contact names that includes the title, first name, middle name (if any), last name, and suffix (if any) of all customers.
SELECT Title, FirstName, MiddleName, LastName, Suffix, ISNULL(Title + ' ','') + ISNULL(FirstName + ' ','') + ISNULL(MiddleName + ' ','')  + ISNULL(LastName + ' ','')  + ISNULL(Suffix,'') AS ContactName
FROM SalesLT.Customer;

---	3. Retrieve customer names and phone numbers
    --- Each customer has an assigned salesperson. You must write a query to create a call sheet that lists:
	    --- The salesperson
		--- A column named CustomerName that displays how the customer contact should be greeted (for example, Mr Smith)
        --- The customer’s phone number.
SELECT  SalesPerson, 
        ISNULL(Title + ' ',FirstName + ' ') + ISNULL(LastName + ' ','')  + ISNULL(Suffix,'') AS CustomerName, 
        Phone
FROM SalesLT.Customer;

--- CHALLENGE 2 Retrieve Customer Order Data
--- 1. Retrieve a list of customer companies. 
    --- You have been asked to provide a list of all customer companies in the format Customer ID : Company Name - for example, 78: Preferred Bikes.
SELECT CONVERT(varchar(5),CustomerID) + ': ' + CompanyName AS CustomerCompany
FROM SalesLT.Customer;

---	2. Retrieve a list of sales order revisions
	--- The SalesLT.SalesOrderHeader table contains records of sales orders. You have been asked to retrieve data for a report that shows:
		--- The purchase order number and revision number in the format * ()* – for example *PO348186287 (2)*.
        --- The order date converted to ANSI standard 102 format (yyyy.mm.dd – for example 2015.01.31).
SELECT  '*' + PurchaseOrderNumber + ' (' + CONVERT(varchar(10),RevisionNumber) + ')*' AS OrderRevision,
        CONVERT(nvarchar(30), OrderDate, 102) AS FormatDate
FROM SalesLT.SalesOrderHeader;

--- CHALLENGE 3 Retrieve customer contact details
--- 1. Retrieve customer contact names with middle names if known
    --- You have been asked to write a query that returns a list of customer names. The list must consist of a single column in the format first last 
    --- (for example Keith Harris) if the middle name is unknown, or first middle last (for example Jane M. Gates) if a middle name is known.
SELECT ISNULL(Title + ' ','') + ISNULL(FirstName + ' ','') + ISNULL(MiddleName + ' ','')  + ISNULL(LastName + ' ','')  + ISNULL(Suffix,'') AS ContactName
FROM SalesLT.Customer;

--- 2. Retrieve primary contact details
    --- Customers may provide Adventure Works with an email address, a phone number, or both. If an email address is available, 
    --- then it should be used as the primary contact method; if not, then the phone number should be used. 
    --- You must write a query that returns a list of customer IDs in one column, and a second column named PrimaryContact that contains the email address if known, 
    --- and otherwise the phone number.
    --- IMPORTANT: In the sample data provided, there are no customer records without an email address.

--- Crear una copia de la tabla Customer
SELECT *
INTO SalesLT.Customer_Copia
FROM SalesLT.Customer;

--- Verificar que la tabla copia contiene los datos
SELECT *
FROM SalesLT.Customer_Copia

--- Remove some existing email addresses before creating your query:
  UPDATE SalesLT.Customer_Copia
  SET EmailAddress = NULL 
  WHERE CustomerID % 7=1;

--- Query to solve the challenge
SELECT CustomerID, CompanyName,
     CASE 
     WHEN EmailAddress IS NULL 
     THEN Phone
     ELSE EmailAddress
     END AS PrimaryContact
FROM SalesLT.Customer_Copia;

--- Other answer to solve the challenge
 SELECT CustomerID, COALESCE(EmailAddress, Phone) AS PrimaryContact
 FROM SalesLT.Customer_Copia;

--- 3. Retrieve shipping status
    --- You have been asked to create a query that returns a list of sales order IDs and order dates with a column named ShippingStatus that contains the text Shipped for 
    --- orders with a known ship date, and Awaiting Shipment for orders with no ship date.
    --- IMPORTANT: In the sample data provided, there are no sales order header records without a ship date. Therefore, to verify that your query works as expected, 
    --- run the following UPDATE statement to remove some existing ship dates before creating your query.


-- Crear una copia de la tabla SalesOrderHeader
SELECT *
INTO SalesLT.SalesOrderHeader_Copia
FROM SalesLT.SalesOrderHeader;

-- Verificar que la nueva tabla ha sido creada y contiene los datos
SELECT *
FROM SalesLT.SalesOrderHeader_Copia;

--- to remove some existing ship dates before creating your query
UPDATE SalesLT.SalesOrderHeader_Copia
SET ShipDate = NULL
WHERE SalesOrderID > 71899;

--- Query to solve the challenge 3-3
SELECT SalesOrderID, OrderDate, Shipdate,
     CASE 
     WHEN ShipDate IS NULL 
     THEN 'Awaiting Shipment'
     ELSE 'Shipped'
     END AS ShippingStatus
FROM SalesLT.SalesOrderHeader_Copia;




