-- Assuming your original table for Question 1 is named 'OrdersNot1NF'
-- and has columns 'OrderID' and 'OrderDetails'

-- SQL Query for Question 1 (Achieving 1NF):
CREATE TABLE Orders1NF (
    OrderID INT,
    Product VARCHAR(255)
);

INSERT INTO Orders1NF (OrderID, Product)
SELECT OrderID, TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OrderDetails, ',', n), ',', -1)) AS Product
FROM OrdersNot1NF
CROSS JOIN (
    SELECT 1 AS n UNION ALL
    SELECT 2 UNION ALL
    SELECT 3 UNION ALL
    SELECT 4 UNION ALL
    SELECT 5 -- Adjust the number based on the maximum expected products
) AS numbers
ON LENGTH(OrderDetails) - LENGTH(REPLACE(OrderDetails, ',', '')) >= numbers.n - 1;

-- SQL Query for Question 2 (Achieving 2NF from a table already in 1NF):
-- Assuming the table from Question 2 is named 'OrderDetails1NF'
-- and has columns 'OrderID', 'CustomerName', 'Product', and 'Quantity'

-- Create the Customers table (for 2NF)
CREATE TABLE Customers (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(255)
);

-- Insert data into the Customers table
INSERT INTO Customers (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails1NF;

-- Create the OrderItems table (for 2NF)
CREATE TABLE OrderItems (
    OrderID INT,
    Product VARCHAR(255),
    Quantity INT,
    PRIMARY KEY (OrderID, Product)
);

-- Insert data into the OrderItems table
INSERT INTO OrderItems (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails1NF;

-- Combining the queries:
-- You would typically execute these sets of queries sequentially in your database.
-- The first set transforms the initial 'OrdersNot1NF' table into 'Orders1NF'.
-- The second set (assuming you have a table like 'OrderDetails1NF' which resembles the 1NF structure but with CustomerName)
-- then transforms 'OrderDetails1NF' into the 'Customers' and 'OrderItems' tables, achieving 2NF.

-- If the 'OrderDetails' table from Question 2 is the direct output of Question 1 (Orders1NF)
-- and also contains 'CustomerName', then the second set of queries would be adjusted as follows:

-- Assuming 'Orders1NF' now has 'CustomerName' as well:
-- (This scenario implies the initial table for Question 1 also had customer names
-- associated with the comma-separated order details)

-- CREATE TABLE Customers2NF (
--     OrderID INT PRIMARY KEY,
--     CustomerName VARCHAR(255)
-- );

-- INSERT INTO Customers2NF (OrderID, CustomerName)
-- SELECT DISTINCT OrderID, CustomerName
-- FROM Orders1NF;

-- CREATE TABLE OrderItems2NF (
--     OrderID INT,
--     Product VARCHAR(255),
--     PRIMARY KEY (OrderID, Product)
-- );

-- INSERT INTO OrderItems2NF (OrderID, Product)
-- SELECT OrderID, Product
-- FROM Orders1NF;

-- Note: The structure of the combined query depends on the exact starting table for Question 2.
-- The first block of queries will always transform the initial denormalized 'OrdersNot1NF' table into 1NF.
-- The second block then takes a table that is already in 1NF (like 'OrderDetails1NF' as in your Question 2 example)
-- and further normalizes it to 2NF by separating customer information.

-- If your intention was to apply both normalizations to the very first denormalized table,
-- the process would involve an intermediate 'Orders1NF' table.

-- Let me know if the table structure for Question 2 is directly derived from the result of Question 1
-- and if it includes the 'CustomerName'. Based on that, I can provide a more precise combined query.