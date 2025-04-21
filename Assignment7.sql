-- Step 1: Create normalized table in 1NF format
-- Each product gets its own row

-- We'll simulate 1NF using a UNION of values
WITH ProductDetail_1NF AS (
    SELECT 101 AS OrderID, 'John Doe' AS CustomerName, 'Laptop' AS Product
    UNION
    SELECT 101, 'John Doe', 'Mouse'
    UNION
    SELECT 102, 'Jane Smith', 'Tablet'
    UNION
    SELECT 102, 'Jane Smith', 'Keyboard'
    UNION
    SELECT 102, 'Jane Smith', 'Mouse'
    UNION
    SELECT 103, 'Emily Clark', 'Phone'
),

-- Step 2: Add quantities (optional if not known, using sample values here)
OrderDetails AS (
    SELECT OrderID, CustomerName, Product,
           CASE Product
                WHEN 'Laptop' THEN 2
                WHEN 'Mouse' THEN 1
                WHEN 'Tablet' THEN 3
                WHEN 'Keyboard' THEN 1
                WHEN 'Phone' THEN 1
            END AS Quantity
    FROM ProductDetail_1NF
)

-- Step 3: Create final 2NF structure
-- a) Orders table (removes partial dependency)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- b) OrderItems table (fully functionally dependent on full primary key)
SELECT OrderID, Product, Quantity
FROM OrderDetails;