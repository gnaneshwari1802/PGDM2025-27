-- ============================================================================
-- 1. THEORY & CONCEPTS
-- ============================================================================
/*
Round 1 Focus: Database creation, table structure definitions, constraints, 
and basic data retrieval using SQL.

Key Concepts Covered:
1. Data Definition Language (DDL):
   - CREATE TABLE: Defines table structure, columns, and data types.
   - PRIMARY KEY: Uniquely identifies each record in a table (cannot be NULL).
   - FOREIGN KEY: Enforces referential integrity between two tables.
   - Constraints: NOT NULL, DEFAULT, CHECK, UNIQUE.
   - DROP / ALTER: Modifies or removes database objects.

2. Basic Data Query Language (DQL):
   - SELECT: Specifies columns to retrieve.
   - FROM: Specifies the source table.
   - WHERE: Filters individual rows based on conditions (=, <>, <, >, LIKE, IN, BETWEEN).
   - ORDER BY: Sorts the result set (ASC or DESC).
   - TOP: SQL specific clause to limit the number of rows returned.
*/


-- ============================================================================
-- 2. ENVIRONMENT SETUP & SAMPLE DATASET
-- ============================================================================

-- Create Customers Table
CREATE TABLE dbo.Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    City VARCHAR(50) NOT NULL,
    State CHAR(2) NOT NULL,
    CreatedDate DATE DEFAULT GETDATE()
);

-- Create Orders Table
CREATE TABLE dbo.Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATE NOT NULL,
    TotalAmount DECIMAL(10,2) CHECK (TotalAmount >= 0),
    OrderStatus VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (CustomerID) REFERENCES dbo.Customers(CustomerID)
);

-- Populate Customers Dataset
INSERT INTO dbo.Customers (CustomerID, FirstName, LastName, Email, City, State, CreatedDate)
VALUES 
(101, 'Alice', 'Smith', 'alice.smith@email.com', 'New York', 'NY', '2024-01-10'),
(102, 'Bob', 'Johnson', 'bob.j@email.com', 'Chicago', 'IL', '2024-01-15'),
(103, 'Charlie', 'Williams', 'charlie.w@email.com', 'Dallas', 'TX', '2024-02-01'),
(104, 'Diana', 'Brown', 'diana.b@email.com', 'New York', 'NY', '2024-02-10'),
(105, 'Evan', 'Davis', 'evan.d@email.com', 'Houston', 'TX', '2024-03-05');

-- Populate Orders Dataset
INSERT INTO dbo.Orders (OrderID, CustomerID, OrderDate, TotalAmount, OrderStatus)
VALUES 
(1001, 101, '2024-02-15', 250.00, 'Completed'),
(1002, 102, '2024-02-18', 120.50, 'Completed'),
(1003, 101, '2024-03-01', 450.00, 'Processing'),
(1004, 103, '2024-03-05', 85.00, 'Cancelled'),
(1005, 104, '2024-03-10', 310.00, 'Completed'),
(1006, 105, '2024-03-12', 150.00, 'Pending');


-- ============================================================================
-- 3. EXAMPLES & SYNTAX BREAKDOWN
-- ============================================================================

-- Example 3.1: Basic Selection with Filtering
SELECT 
    CustomerID,
    FirstName + ' ' + LastName AS Customer_Full_Name,
    City,
    State
FROM dbo.Customers
WHERE State = 'NY'
ORDER BY LastName ASC;

-- Example 3.2: Filtering Range and In-Lists
SELECT 
    OrderID,
    CustomerID,
    TotalAmount,
    OrderStatus
FROM dbo.Orders
WHERE TotalAmount BETWEEN 100.00 AND 400.00
  AND OrderStatus IN ('Completed', 'Processing')
ORDER BY TotalAmount DESC;


-- ============================================================================
-- 4. EXERCISES & SOLUTIONS
-- ============================================================================

/*
-------------------------------------------------------------------------------
EXERCISE 1 (Easy):
Write a query to retrieve all customers who live in either 'TX' or 'IL'. 
Display CustomerID, Full Name, City, and State, sorted alphabetically by City.
-------------------------------------------------------------------------------
*/
-- SOLUTION 1:
SELECT 
    CustomerID,
    FirstName + ' ' + LastName AS FullName,
    City,
    State
FROM dbo.Customers
WHERE State IN ('TX', 'IL')
ORDER BY City ASC;

/*
-------------------------------------------------------------------------------
EXERCISE 2 (Medium):
Write a query to fetch the TOP 2 orders with a TotalAmount greater than 100, 
where OrderStatus is 'Completed'. Sort the result by OrderDate descending.
-------------------------------------------------------------------------------
*/
-- SOLUTION 2:
SELECT TOP 2
    OrderID,
    CustomerID,
    OrderDate,
    TotalAmount,
    OrderStatus
FROM dbo.Orders
WHERE TotalAmount > 100.00
  AND OrderStatus = 'Completed'
ORDER BY OrderDate DESC;



/*
===============================================================================
PRACTICE ROUND 2
Topic: Data Aggregation (GROUP BY & HAVING)
===============================================================================
*/

-- ============================================================================
-- 1. THEORY & CONCEPTS
-- ============================================================================
/*
Round 2 Focus: Summarizing datasets using aggregate functions, grouping data 
by categorical fields, and filtering aggregated results in SQL.

Key Concepts Covered:
1. Aggregate Functions:
   - COUNT(): Counts rows or non-NULL values.
   - SUM(): Calculates the total sum of a numeric column.
   - AVG(): Calculates the average value of a numeric column.
   - MIN() / MAX(): Returns the lowest and highest values in a group.

2. GROUP BY Clause:
   - Groups individual records into summary rows based on identical column values.
   - Any column in the SELECT statement that is NOT inside an aggregate function 
     MUST be listed in the GROUP BY clause.

3. HAVING Clause vs. WHERE Clause:
   - WHERE: Filters individual rows BEFORE grouping and aggregation occur.
   - HAVING: Filters grouped/aggregated rows AFTER aggregation occurs.
   - Rule of Thumb: Use WHERE for raw column filters; use HAVING for aggregate functions 
     (e.g., HAVING SUM(Amount) > 500).
*/


-- ============================================================================
-- 2. ENVIRONMENT SETUP & SAMPLE DATASET
-- ============================================================================

-- Create Sales Table
CREATE TABLE dbo.Sales (
    SaleID INT PRIMARY KEY,
    Salesperson VARCHAR(50) NOT NULL,
    Region VARCHAR(30) NOT NULL,
    Category VARCHAR(30) NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    SaleDate DATE NOT NULL
);

-- Populate Sales Dataset
INSERT INTO dbo.Sales (SaleID, Salesperson, Region, Category, Amount, SaleDate)
VALUES 
(1, 'Alice', 'North', 'Electronics', 1200.00, '2024-01-05'),
(2, 'Bob', 'South', 'Electronics', 800.00, '2024-01-07'),
(3, 'Charlie', 'East', 'Furniture', 450.00, '2024-01-10'),
(4, 'Alice', 'North', 'Furniture', 300.00, '2024-01-12'),
(5, 'David', 'West', 'Electronics', 1500.00, '2024-01-15'),
(6, 'Bob', 'South', 'Furniture', 650.00, '2024-01-18'),
(7, 'Charlie', 'East', 'Electronics', 900.00, '2024-01-20'),
(8, 'Alice', 'North', 'Electronics', 1100.00, '2024-01-22'),
(9, 'David', 'West', 'Furniture', 200.00, '2024-01-25'),
(10, 'Eve', 'South', 'Electronics', 400.00, '2024-01-28');


-- ============================================================================
-- 3. EXAMPLES & SYNTAX BREAKDOWN
-- ============================================================================

-- Example 3.1: Summarizing Sales per Region using GROUP BY
SELECT 
    Region,
    COUNT(SaleID) AS TotalTransactions,
    SUM(Amount) AS TotalSalesAmount,
    AVG(Amount) AS AvgSaleAmount
FROM dbo.Sales
GROUP BY Region
ORDER BY TotalSalesAmount DESC;

-- Example 3.2: Filtering Groups using WHERE and HAVING together
-- Requirement: Calculate total Electronics sales per Salesperson, 
-- but only return Salespersons whose total Electronics revenue exceeds 1000.
SELECT 
    Salesperson,
    COUNT(SaleID) AS ElectronicSalesCount,
    SUM(Amount) AS TotalRevenue
FROM dbo.Sales
WHERE Category = 'Electronics'              -- 1. Filters raw rows before grouping
GROUP BY Salesperson                        -- 2. Groups remaining rows
HAVING SUM(Amount) > 1000.00                -- 3. Filters aggregate groups
ORDER BY TotalRevenue DESC;


-- ============================================================================
-- 4. STUDENT EXERCISES & SOLUTIONS
-- ============================================================================

/*
-------------------------------------------------------------------------------
EXERCISE 1:
Write a query to calculate the total sales amount and total number of transactions 
for each Category. Order the output by total sales amount in descending order.
-------------------------------------------------------------------------------
*/
-- SOLUTION 1:
SELECT 
    Category,
    COUNT(SaleID) AS TotalTransactions,
    SUM(Amount) AS TotalSalesAmount
FROM dbo.Sales
GROUP BY Category
ORDER BY TotalSalesAmount DESC;

/*
-------------------------------------------------------------------------------
EXERCISE 2:
Write a query to find all regions that have an average sale amount greater 
than 700.00 across all product categories. Display the Region name, average 
sale amount (rounded/formatted), and total transaction count.
-------------------------------------------------------------------------------
*/
-- SOLUTION 2:
SELECT 
    Region,
    AVG(Amount) AS AverageSaleAmount,
    COUNT(SaleID) AS TotalTransactions
FROM dbo.Sales
GROUP BY Region
HAVING AVG(Amount) > 700.00
ORDER BY AverageSaleAmount DESC;


-- Round 3: Multi-Table Integration (Joins & Subqueries)
-- 1. THEORY & CONCEPTS
/*
Joins combine columns from one or more tables based on a related column between them.
- INNER JOIN: Returns records that have matching values in both tables.
- LEFT JOIN: Returns all records from the left table, and matched records from the right table.
- RIGHT JOIN: Returns all records from the right table, and matched records from the left table.
- FULL OUTER JOIN: Returns all records when there is a match in either left or right table.
- Subqueries: A query nested inside another query (Scalar, Multi-row, or Correlated).
*/

-- 2. ENVIRONMENT SETUP & SAMPLE DATASET

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50) NOT NULL
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DepartmentID INT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

INSERT INTO Departments (DepartmentID, DepartmentName)
VALUES 
(1, 'Engineering'),
(2, 'Sales'),
(3, 'Marketing'),
(4, 'Human Resources');

INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID, Salary)
VALUES 
(101, 'John', 'Doe', 1, 85000.00),
(102, 'Jane', 'Smith', 2, 62000.00),
(103, 'Robert', 'Johnson', 1, 95000.00),
(104, 'Emily', 'Davis', NULL, 50000.00),
(105, 'Michael', 'Brown', 3, 58000.00);


-- 3. EXAMPLES & SYNTAX BREAKDOWN

-- Example 3.1: INNER JOIN vs LEFT JOIN
SELECT 
    E.EmployeeID,
    E.FirstName + ' ' + E.LastName AS EmployeeName,
    D.DepartmentName
FROM Employees E
INNER JOIN Departments D ON E.DepartmentID = D.DepartmentID;

SELECT 
    E.EmployeeID,
    E.FirstName + ' ' + E.LastName AS EmployeeName,
    D.DepartmentName
FROM Employees E
LEFT JOIN Departments D ON E.DepartmentID = D.DepartmentID;

-- Example 3.2: Subquery to find employees earning above average salary
SELECT 
    EmployeeID,
    FirstName,
    LastName,
    Salary
FROM Employees
WHERE Salary > (SELECT AVG(Salary) FROM Employees);


-- 4. EXERCISES & SOLUTIONS

/*
EXERCISE 1:
Write a query to display all departments and the count of employees in each department, 
including departments that currently have no employees assigned.
*/
-- SOLUTION 1:
SELECT 
    D.DepartmentName,
    COUNT(E.EmployeeID) AS EmployeeCount
FROM Departments D
LEFT JOIN Employees E ON D.DepartmentID = E.DepartmentID
GROUP BY D.DepartmentName;

/*
EXERCISE 2:
Write a query to retrieve the details of employees who belong to the department 
that has the highest average salary.
*/
-- SOLUTION 2:
SELECT 
    EmployeeID,
    FirstName,
    LastName,
    Salary,
    DepartmentID
FROM Employees
WHERE DepartmentID = (
    SELECT TOP 1 DepartmentID
    FROM Employees
    WHERE DepartmentID IS NOT NULL
    GROUP BY DepartmentID
    ORDER BY AVG(Salary) DESC
);

-- Round 4: Advanced Analytical Querying (Window Functions & CTEs)
-- 1. THEORY & CONCEPTS
/*
Window functions perform calculations across a set of table rows that are related to the current row without collapsing rows into a single summary output.
- OVER(): Defines the partitioning and ordering of rows for the window function.
- ROW_NUMBER(): Assigns a unique sequential integer to rows.
- RANK(): Assigns a rank with gaps in case of duplicate values.
- DENSE_RANK(): Assigns a rank without gaps for duplicate values.
- LAG() / LEAD(): Accesses data from a previous or subsequent row in the result set.
- CTE (Common Table Expression): A temporary, named result set defined using the WITH clause for cleaner code structure and recursion.
*/


-- 2. ENVIRONMENT SETUP & SAMPLE DATASET

CREATE TABLE EmployeeSalaries (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(50) NOT NULL,
    Department VARCHAR(50) NOT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    HireDate DATE NOT NULL
);

INSERT INTO EmployeeSalaries (EmployeeID, EmployeeName, Department, Salary, HireDate)
VALUES 
(1, 'Alice', 'IT', 90000.00, '2020-01-15'),
(2, 'Bob', 'IT', 90000.00, '2021-03-22'),
(3, 'Charlie', 'IT', 75000.00, '2019-07-10'),
(4, 'Diana', 'Sales', 65000.00, '2018-11-05'),
(5, 'Evan', 'Sales', 80000.00, '2022-02-01'),
(6, 'Fiona', 'Sales', 80000.00, '2023-05-12');


-- 3. EXAMPLES & SYNTAX BREAKDOWN

-- Example 3.1: Ranking Functions Comparison
SELECT 
    EmployeeID,
    EmployeeName,
    Department,
    Salary,
    ROW_NUMBER() OVER (PARTITION BY Department ORDER BY Salary DESC) AS RowNum,
    RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS RankNum,
    DENSE_RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS DenseRankNum
FROM EmployeeSalaries;

-- Example 3.2: Common Table Expression (CTE) to filter ranked results
WITH RankedEmployees AS (
    SELECT 
        EmployeeID,
        EmployeeName,
        Department,
        Salary,
        DENSE_RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS SalaryRank
    FROM EmployeeSalaries
)
SELECT 
    EmployeeID,
    EmployeeName,
    Department,
    Salary
FROM RankedEmployees
WHERE SalaryRank = 1;


-- 4. EXERCISES & SOLUTIONS

/*
EXERCISE 1:
Write a query using a Window Function to calculate the running total of salaries for each department ordered by HireDate.
*/
-- SOLUTION 1:
SELECT 
    EmployeeID,
    EmployeeName,
    Department,
    Salary,
    HireDate,
    SUM(Salary) OVER (PARTITION BY Department ORDER BY HireDate) AS RunningTotalSalary
FROM EmployeeSalaries;

/*
EXERCISE 2:
Write a query using a CTE and a Window Function to find the second highest paid employee in each department.
*/
-- SOLUTION 2:
WITH RankedSalaryCTE AS (
    SELECT 
        EmployeeID,
        EmployeeName,
        Department,
        Salary,
        DENSE_RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS SalaryRank
    FROM EmployeeSalaries
)
SELECT 
    EmployeeID,
    EmployeeName,
    Department,
    Salary
FROM RankedSalaryCTE
WHERE SalaryRank = 2;

-- Round 5: Built-in Functions & Set Operations
-- 1. THEORY & CONCEPTS
/*
Core Data Operations & Set Manipulations:
- Set Operators:
  * UNION: Combines results from multiple SELECT queries and removes duplicates.
  * UNION ALL: Combines results from multiple SELECT queries including all duplicates.
  * INTERSECT: Returns only rows that appear in both SELECT query results.
  * EXCEPT: Returns rows from the first query that are not in the second query.

- String Functions:
  * UPPER(str) / LOWER(str): Converts characters to uppercase or lowercase.
  * CONCAT(str1, str2, ...): Joins two or more string values together.
  * LEN(str): Returns the character length of a string.
  * LEFT(str, n) / RIGHT(str, n): Extracts 'n' characters from the left or right side of a string.
  * REPLACE(str, find_str, replace_str): Replaces occurrences of a substring within a string.

- Date Functions:
  * GETDATE(): Returns the current system date and time.
  * YEAR(date) / MONTH(date) / DAY(date): Extracts individual date components.
  * DATEDIFF(unit, start, end): Calculates the difference between two dates.
  * DATEADD(unit, number, date): Adds or subtracts a specified time interval from a date.

- Conditional Expressions:
  * CASE WHEN condition THEN result ELSE default END: Evaluates list of conditions and returns value.
*/


-- 2. ENVIRONMENT SETUP & SAMPLE DATASET
CREATE TABLE OnlineOrders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    CustomerEmail VARCHAR(100) NOT NULL,
    OrderDate DATE NOT NULL,
    TotalAmount DECIMAL(10,2) NOT NULL,
    OrderStatus VARCHAR(20) NOT NULL
);

CREATE TABLE InStoreOrders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    CustomerEmail VARCHAR(100) NOT NULL,
    OrderDate DATE NOT NULL,
    TotalAmount DECIMAL(10,2) NOT NULL,
    OrderStatus VARCHAR(20) NOT NULL
);

INSERT INTO OnlineOrders (OrderID, CustomerName, CustomerEmail, OrderDate, TotalAmount, OrderStatus)
VALUES 
(101, 'Alice Smith', 'alice.smith@email.com', '2024-01-15', 150.00, 'Completed'),
(102, 'Bob Johnson', 'bob.j@email.com', '2024-02-10', 85.50, 'Pending'),
(103, 'Charlie Williams', 'charlie.w@email.com', '2024-03-01', 220.00, 'Completed'),
(104, 'David Lee', 'david.lee@email.com', '2024-03-12', 45.00, 'Cancelled');

INSERT INTO InStoreOrders (OrderID, CustomerName, CustomerEmail, OrderDate, TotalAmount, OrderStatus)
VALUES 
(201, 'Bob Johnson', 'bob.j@email.com', '2024-02-10', 85.50, 'Completed'),
(202, 'Charlie Williams', 'charlie.w@email.com', '2024-03-01', 220.00, 'Completed'),
(203, 'Emma Watson', 'emma.w@email.com', '2024-03-15', 310.00, 'Completed');


-- 3. EXAMPLES & SYNTAX BREAKDOWN

-- Example 3.1: Combining Datasets with Set Operators
SELECT CustomerName, CustomerEmail FROM OnlineOrders
UNION ALL
SELECT CustomerName, CustomerEmail FROM InStoreOrders;

SELECT CustomerEmail FROM OnlineOrders
INTERSECT
SELECT CustomerEmail FROM InStoreOrders;

-- Example 3.2: String Manipulation Techniques
SELECT 
    CustomerName,
    UPPER(CustomerName) AS NameInCaps,
    LEFT(CustomerName, 3) AS FirstThreeChars,
    CONCAT(CustomerName, ' - ', CustomerEmail) AS CustomerContactInfo
FROM OnlineOrders;

-- Example 3.3: Basic Date Calculations
SELECT 
    OrderID,
    OrderDate,
    YEAR(OrderDate) AS OrderYear,
    MONTH(OrderDate) AS OrderMonth,
    DATEDIFF(DAY, OrderDate, GETDATE()) AS DaysAgo
FROM OnlineOrders;

-- Example 3.4: Conditional Value Mapping
SELECT 
    OrderID,
    TotalAmount,
    CASE 
        WHEN TotalAmount >= 200 THEN 'High Value'
        WHEN TotalAmount >= 100 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS OrderCategory
FROM OnlineOrders;


-- 4. EXERCISES & SOLUTIONS
/*
EXERCISE 1:
Write a query to display all customer names from OnlineOrders in lowercase along with the total character length of their email addresses.
*/
-- SOLUTION 1:
SELECT 
    LOWER(CustomerName) AS LowerCustomerName,
    LEN(CustomerEmail) AS EmailLength
FROM OnlineOrders;

/*
EXERCISE 2:
Write a query to display OrderID, OrderDate, and a new calculated column that adds 7 days to the OrderDate (named EstimatedDeliveryDate) for all OnlineOrders.
*/
-- SOLUTION 2:
SELECT 
    OrderID,
    OrderDate,
    DATEADD(DAY, 7, OrderDate) AS EstimatedDeliveryDate
FROM OnlineOrders;

/*
EXERCISE 3:
Write a query using UNION to list all distinct customer emails from both OnlineOrders and InStoreOrders.
*/
-- SOLUTION 3:
SELECT CustomerEmail FROM OnlineOrders
UNION
SELECT CustomerEmail FROM InStoreOrders;

/*
EXERCISE 4:
Write a query using a CASE statement on OnlineOrders to label orders as 'Shipped' if OrderStatus is 'Completed', and 'Processing' for any other status.
*/
-- SOLUTION 4:
SELECT 
    OrderID,
    OrderStatus,
    CASE 
        WHEN OrderStatus = 'Completed' THEN 'Shipped'
        ELSE 'Processing'
    END AS SimpleStatus
FROM OnlineOrders;

/*
EXERCISE 5:
Write a query to find all customer emails that are present in OnlineOrders but are NOT present in InStoreOrders using EXCEPT.
*/
-- SOLUTION 5:
SELECT CustomerEmail FROM OnlineOrders
EXCEPT
SELECT CustomerEmail FROM InStoreOrders;