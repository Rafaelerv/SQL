--- Ejercicio 6: Modificar datos

--- INSERT DATA
    -- You use the INSERT statement to insert data into a table.

-- create a new table named SalesLT.CallLog
CREATE TABLE SalesLT.CallLog
    (
     CallID int IDENTITY PRIMARY KEY NOT NULL,
     CallTime datetime NOT NULL DEFAULT GETDATE(),
     SalesPerson nvarchar(256) NOT NULL,
     CustomerID int NOT NULL REFERENCES SalesLT.Customer(CustomerID),
     PhoneNumber nvarchar(25) NOT NULL,
     Notes nvarchar(max) NULL);  
-- Don’t worry too much about the details of the CREATE TABLE statement - it creates a table with some fields that we’ll use in subsequent tasks 
-- to insert, update, and delete data.

--  Enter the following code to query the SalesLT.CallLog you just created
SELECT* 
FROM SalesLT.CallLog;

-- the following INSERT statement to insert a new row into the SalesLT.CallLog table 
INSERT INTO SalesLT.CallLog
VALUES('2015-01-01T12:30:00', 'adventure-works\pamela0', 1, '245-555-0173', 'Returning call re: enquiry about delivery');

-- Review data in table
SELECT* 
FROM SalesLT.CallLog;
-- Note that the results contain the row you inserted. The CallID column is an identity column that is automatically incremented (so the first row has the value 1), 
-- and the remaining columns contain the values you specified in the INSERT statement

-- This time, the INSERT statement takes advantage of the fact that the table has a default value defined for the CallTime field, and allows NULL values in the Notes field.
INSERT INTO SalesLT.CallLog
VALUES(DEFAULT, 'adventure-works\david8', 2, '170-555-0127', NULL);

-- Review data in table
SELECT* 
FROM SalesLT.CallLog;
-- Note that the second row has been inserted, with the default value for the CallTime field (the current time when the row was inserted) and NULL for the Notes field.

-- This time, the INSERT statement explicitly lists the columns into which the new values will be inserted. The columns not specified in the statement support either 
-- default or NULL values, so they can be omitted.
INSERT INTO SalesLT.CallLog (SalesPerson, CustomerID, PhoneNumber)
VALUES('adventure-works\jillian0', 3, '279-555-0130');

-- Review data in table
SELECT* 
FROM SalesLT.CallLog;
-- Note that the third row has been inserted, once again using the default value for the CallTime field and NULL for the Notes field.

-- replace it with the following code, which inserts two rows of data into the SalesLT.CallLog table
INSERT INTO SalesLT.CallLog (SalesPerson, CustomerID, PhoneNumber, Notes)
SELECT SalesPerson, CustomerID, Phone, 'Sales promotion call'
FROM SalesLT.Customer
WHERE CompanyName = 'Big-Time Bike Store';

-- Review data in table
SELECT* 
FROM SalesLT.CallLog;
-- Note that two new rows have been added to the table. These are the rows that were retrieved by the SELECT query.

-- Replace it with the following code, which inserts a row and then uses the SCOPE_IDENTITY function to retrieve the most recent identity value that has been assigned 
-- in the database (to any table), and also the IDENT_CURRENT function, which retrieves the latest identity value in the specified table.
INSERT INTO SalesLT.CallLog (SalesPerson, CustomerID, PhoneNumber)
VALUES('adventure-works\josé1', 10, '150-555-0127');

SELECT SCOPE_IDENTITY() AS LatestIdentityInDB,
       IDENT_CURRENT('SalesLT.CallLog') AS LatestCallID;

-- Review data in table
SELECT* 
FROM SalesLT.CallLog;
-- the new row that has been inserted has a CallID value that matches the identity value returned when you inserted it.

-- replace it with the following code, which enables explicit insertion of identity values and inserts a new row with a specified CallID value, 
-- before disabling explicit identity insertion again.
SET IDENTITY_INSERT SalesLT.CallLog ON;

INSERT INTO SalesLT.CallLog (CallID, SalesPerson, CustomerID, PhoneNumber)
VALUES(20, 'adventure-works\josé1', 11, '926-555-0159');

-- Review data in table
SELECT* 
FROM SalesLT.CallLog;
-- to validate that a new row has been inserted with the specific CallID value you specified in the INSERT statement


-- UPDATE DATA
    -- To modify existing rows in a table, use the UPDATE statement.

-- replace the existing code with the following code
UPDATE SalesLT.CallLog
SET Notes = 'No notes'
WHERE Notes IS NULL;

-- Review data in table
SELECT* 
FROM SalesLT.CallLog;
-- Note that the rows that previously had NULL values for the Notes field now contain the text No notes.

--  replace it with the following code, which updates multiple columns.
UPDATE SalesLT.CallLog
SET SalesPerson = '', PhoneNumber = ''

-- Review data in table
SELECT* 
FROM SalesLT.CallLog;
-- Note that all rows have been updated to remove the SalesPerson and PhoneNumber fields - this emphasizes the danger of accidentally omitting a WHERE clause 
-- in an UPDATE statement.

-- replace it with the following code, which updates the SalesLT.CallLog table based on the results of a SELECT query.
UPDATE SalesLT.CallLog
SET SalesPerson = c.SalesPerson, PhoneNumber = c.Phone
FROM SalesLT.Customer AS c
WHERE c.CustomerID = SalesLT.CallLog.CustomerID;

-- Review data in table
SELECT* 
FROM SalesLT.CallLog;
-- Note that the table has been updated using the values returned by the SELECT statement.

-- DELETE DATA
    -- To delete rows in the table, you generally use the DELETE statement; though you can also remove all rows from a table by using the TRUNCATE TABLE statement.

-- replace the existing code with the following code.
DELETE
FROM SalesLT.CallLog
WHERE CallTime < DATEADD(dd, -7, GETDATE());

-- Review data in table
SELECT* 
FROM SalesLT.CallLog;
-- Note that rows with a CallDate older than 7 days have been deleted.

-- which uses the TRUNCATE TABLE statement to remove all rows in the table
TRUNCATE TABLE SalesLT.CallLog;

-- Review data in table
SELECT* 
FROM SalesLT.CallLog;
-- Note that all rows have been deleted from the table.

-- CHALLENGES

-- Challenge 1: Insert products
    -- Each Adventure Works product is stored in the SalesLT.Product table, and each product has a unique ProductID identifier, which is implemented as an identity column in the SalesLT.Product table. Products are organized into categories, which are defined in the SalesLT.ProductCategory table. The products and product category records are related by a common ProductCategoryID identifier, which is an identity column in the SalesLT.ProductCategory table.
	
    -- 1. Insert a product
		-- Adventure Works has started selling the following new product. Insert it into the SalesLT.Product table, using default or NULL values for unspecified columns:
			-- Name: LED Lights
			-- ProductNumber: LT-L123
			-- StandardCost: 2.56
			-- ListPrice: 12.99
			-- ProductCategoryID: 37
			-- SellStartDate: Today’s date
		-- After you have inserted the product, run a query to determine the ProductID that was generated.
		-- Then run a query to view the row for the product in the SalesLT.Product table.

-- Crear una copia de la tabla SalesLT.Product
SELECT *
INTO SalesLT.Product_Copia
FROM SalesLT.Product;

INSERT INTO SalesLT.Product_Copia (Name, ProductNumber, StandardCost, ListPrice, ProductCategoryID, SellStartDate, rowguid, ModifiedDate)
VALUES('LED Lights', 'LT-L123', 2.56, 12.99, 37, GETDATE(), '43de68d6-14a4-461f-9069-55309d90ea7e', GETDATE());

	-- 2. Insert a new category with two products
		-- Adventure Works is adding a product category for Bells and Horns to its catalog. The parent category for the new category is 4 (Accessories). 
        -- This new category includes the following two new products:
			-- First product:
				-- Name: Bicycle Bell
				-- ProductNumber: BB-RING
				-- StandardCost: 2.47
				-- ListPrice: 4.99
				-- ProductCategoryID: The ProductCategoryID for the new Bells and Horns category
				-- SellStartDate: Today’s date
			-- Second product:
				-- Name: Bicycle Horn
				-- ProductNumber: BB-PARP
				-- StandardCost: 1.29
				-- ListPrice: 3.75
				-- ProductCategoryID: The ProductCategoryID for the new Bells and Horns category
				-- SellStartDate: Today’s date
		-- Write a query to insert the new product category, and then insert the two new products with the appropriate ProductCategoryID value.
		-- After you have inserted the products, query the SalesLT.Product and SalesLT.ProductCategory tables to verify that the data has been inserted.

-- Crear una copia de la tabla SalesLT.ProductCategory
SELECT *
INTO SalesLT.ProductCategoryCopia
FROM SalesLT.ProductCategory;

SET IDENTITY_INSERT SalesLT.CallLog OFF;
SET IDENTITY_INSERT SalesLT.ProductCategoryCopia ON;
INSERT INTO SalesLT.ProductCategoryCopia (ProductCategoryID,ParentProductCategoryID, Name, rowguid, ModifiedDate)
VALUES(42, 4, 'Bells and Horns', '43de68d6-14a4-461f-9069-55309d90ea7e', GETDATE());
SET IDENTITY_INSERT SalesLT.ProductCategoryCopia OFF;

INSERT INTO SalesLT.Product_Copia (Name, ProductNumber, StandardCost, ListPrice, ProductCategoryID, SellStartDate, rowguid, ModifiedDate)
VALUES('Bicycle Bell', 'BB-RING', 2.47, 4.99, 42, GETDATE(), '43de68d6-14a4-461f-9070-55309d90ea7e', GETDATE()),
('Bicycle Horn', 'BB-PAPR', 1.29, 3.75, 42, GETDATE(), '43de68d6-14a4-461f-9070-55309d90ea7e', GETDATE());

SELECT c.Name AS Category, p.Name AS Product
FROM SalesLT.Product_Copia AS p
JOIN SalesLT.ProductCategoryCopia AS c
ON p.ProductCategoryID = c.ProductCategoryID
WHERE p.ProductCategoryID = 42


-- Challenge 2: Update products
    -- You have inserted data for a product, but the pricing details are not correct. You must now update the records you have previously inserted to reflect 
    -- the correct pricing. Tip: Review the documentation for UPDATE in the Transact-SQL Language Reference.
	
    -- 1. Update product prices
		-- The sales manager at Adventure Works has mandated a 10% price increase for all products in the Bells and Horns category. 
        -- Update the rows in the SalesLT.Product table for these products to increase their price by 10%.

UPDATE SalesLT.Product_Copia
SET ListPrice = ListPrice * 1.1
WHERE ProductCategoryID = 42

    
    -- 2. Discontinue products
		-- The new LED lights you inserted in the previous challenge are to replace all previous light products. 
        -- Update the SalesLT.Product table to set the DiscontinuedDate to today’s date for all products in the Lights category (product category ID 37) 
        -- other than the LED Lights product you inserted previously.
UPDATE SalesLT.Product_Copia
SET DiscontinuedDate = GETDATE()
WHERE ProductCategoryID = 37 AND ProductNumber = 'LT-L123'

-- para verificar
SELECT ProductCategoryID, ProductNumber, DiscontinuedDate
FROM SalesLT.Product_Copia
WHERE ProductNumber = 'LT-L123'

-- Challenge 3: Delete products
    --The Bells and Horns category has not been successful, and it must be deleted from the database.
	
    -- 1. Delete a product category and its products
		-- Delete the records for the Bells and Horns category and its products. You must ensure that you delete the records from the tables in the correct order to avoid a foreign-key constraint violation.

DELETE
FROM SalesLT.Product_Copia
WHERE ProductID = 1006

SELECT *
FROM SalesLT.Product_Copia

DELETE
FROM SalesLT.ProductCategoryCopia
WHERE ProductCategoryID = 42

SELECT *
FROM SalesLT.ProductCategoryCopia

-- Borrar tablas de trabajo 
DROP TABLE SalesLT.Product_Copia;
DROP TABLE SalesLT.ProductCategoryCopia;
DROP TABLE SalesLT.Customer_Copia;



