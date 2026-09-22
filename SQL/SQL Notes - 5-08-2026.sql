/* ============================================================================
    Database System: Microsoft SQL Server
   ============================================================================ */
   -- ============================================================================
-- LEVEL 1: DATABASE FOUNDATIONS & DDL COMMANDS
-- ============================================================================

-- MODULE 1: Database Creation & Management
--   - CREATE DATABASE
--   - USE <database_name>
--   - DROP DATABASE

-- MODULE 2: Data Types & Constraints
--   - Data Types: INT, DECIMAL(p,s), VARCHAR(n), DATE
--   - Column Constraints: PRIMARY KEY, NOT NULL, UNIQUE, DEFAULT

-- MODULE 3: Table Creation & Maintenance
--   - CREATE TABLE
--   - DROP TABLE / IF OBJECT_ID() DROP TABLE

-- MODULE 4: Schema Alteration (ALTER TABLE)
--   - ALTER TABLE ... ADD <column_name> <data_type>
--   - ALTER TABLE ... DROP COLUMN / CONSTRAINT
--   - DEFAULT Value definitions

-- MODULE 5: Relational Schema Design & Keys
--   - Primary Keys (PK) vs. Candidate Keys
--   - Foreign Keys (FK) & Referential Integrity
--   - Parent-Child Table Relationships

-- MODULE 6: Database Integrity Rules
--   - Entity Integrity (Primary Keys must be unique & non-null)
--   - Domain Integrity (Data type & CHECK restrictions)
--   - Referential Integrity (Foreign key enforcement)


-- ============================================================================
-- LEVEL 2: DATA MANIPULATION (DML COMMANDS)
-- ============================================================================

-- MODULE 7: Data Insertion Techniques
--   - Single-row INSERT INTO ... VALUES (...)
--   - Bulk / Multi-row INSERT INTO ... VALUES (...), (...)
--   - Handling default & NULL columns during insertion

-- MODULE 8: Data Modification & Deletion
--   - UPDATE ... SET ... WHERE
--   - DELETE FROM ... WHERE
--   - TRUNCATE TABLE vs. DELETE FROM (DDL vs. DML performance & logging differences)


-- ============================================================================
-- LEVEL 3: DATA FILTERING & QUERYING FOUNDATIONS
-- ============================================================================

-- MODULE 9: Basic Querying & Conditional Filtering
--   - SELECT column lists vs. SELECT *
--   - WHERE Clause filtering (=, >, <, >=, <=, !=)
--   - Logical operators: AND, OR, NOT
--   - DISTINCT for unique value extraction
--   - ORDER BY (ASC / DESC)

-- MODULE 10: Advanced Filtering & Pattern Matching
--   - IN / NOT IN Operators (List-based filtering)
--   - BETWEEN / NOT BETWEEN Operators (Inclusive range filtering)
--   - LIKE Operator & Wildcards (%, _, [], [^])
--   - Handling NULL Values (IS NULL, IS NOT NULL, ISNULL() handling)


-- ============================================================================
-- LEVEL 4: INTERMEDIATE & ADVANCED SQL FOR DATA SCIENCE
-- ============================================================================

-- MODULE 11: Aggregations & Grouping
--   - Aggregate Functions: COUNT(), SUM(), AVG(), MIN(), MAX()
--   - GROUP BY Clause (Categorical summaries)
--   - HAVING Clause vs. WHERE Clause filtering

-- MODULE 12: Relational Joins (Combining Datasets)
--   - INNER JOIN (Strict key matching)
--   - LEFT (OUTER) JOIN (Preserving left table records)
--   - RIGHT (OUTER) JOIN (Preserving right table records)
--   - FULL OUTER JOIN (Complete audit matching)
--   - CROSS JOIN (Cartesian product combinations)

-- MODULE 13: Advanced Multi-Table Operations
--   - Multi-key Joins
--   - Multi-table JOIN chaining (3+ tables)
--   - Self-Joins (Hierarchical data)

-- MODULE 14: Foreign Key Cascading Actions
--   - ON UPDATE CASCADE / ON DELETE CASCADE
--   - ON UPDATE SET NULL / ON DELETE SET NULL
--   - Data Science trade-offs: Cascading vs. Preserving audit logs

-- MODULE 15: Subqueries & Common Table Expressions (CTEs)
--   - Scalar Subqueries (Single value returns)
--   - Multi-Row Subqueries (IN, NOT IN)
--   - Correlated Subqueries (Row-by-row comparative evaluation)
--   - Common Table Expressions (WITH clause / CTEs)
--   - Multi-Stage CTE Pipelines for Data Preparation

-- MODULE 16: SQL Window Functions (Advanced Analytical Scoring)
--   - OVER() Clause & PARTITION BY vs. ORDER BY
--   - Ranking Functions: ROW_NUMBER(), RANK(), DENSE_RANK()
--   - Offset Functions: LAG(), LEAD() (Time-Series & sequential analysis)
--   - Aggregate Window Functions: Running Totals (SUM OVER) & Moving Averages
--   - Top-N Per Category analytical pattern (CTE + DENSE_RANK)

-- ============================================================================
-- 1. CREATING & ACTIVATING A DATABASE
-- ============================================================================

-- Syntax: Create Database
CREATE DATABASE database_name;

-- Syntax: Activate / Use Database
USE database_name;

-- Real Example:
CREATE DATABASE data_science_db;
USE data_science_db;


-- ============================================================================
-- 2. CREATING A TABLE WITHOUT CONSTRAINTS
-- ============================================================================

-- Syntax: Table without constraints
CREATE TABLE table_name (
    column1_name DATA_TYPE,
    column2_name DATA_TYPE,
    column3_name DATA_TYPE
);

-- Real Example: Personal library books table
CREATE TABLE ds_books (
    book_id INT,
    title VARCHAR(100),
    author VARCHAR(50),
    price DECIMAL(8, 2),
    published_year INT
);


-- ============================================================================
-- 3. CREATING A TABLE WITH CONSTRAINTS AT CREATION TIME
-- ============================================================================

-- Syntax: Table with Constraints
CREATE TABLE table_name (
    column1_name DATA_TYPE PRIMARY KEY,
    column2_name DATA_TYPE NOT NULL,
    column3_name DATA_TYPE UNIQUE,
    column4_name DATA_TYPE DEFAULT default_value,
    column5_name DATA_TYPE CHECK (condition)
);

-- Real Example: Students Table with Guardrails
CREATE TABLE ds_students (
    student_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    enrollment_date DATE DEFAULT GETDATE(),
    age INT CHECK (age >= 18)
);


-- ============================================================================
-- 4. ADDING CONSTRAINTS TO AN EXISTING TABLE
-- ============================================================================

-- Syntax: Add Named CHECK / UNIQUE / FOREIGN KEY Constraint
ALTER TABLE table_name
ADD CONSTRAINT constraint_name CONSTRAINT_TYPE (column_name);

-- Syntax: Add DEFAULT Constraint
ALTER TABLE table_name
ADD CONSTRAINT constraint_name DEFAULT default_value FOR column_name;

-- Syntax: Alter Column to NOT NULL
ALTER TABLE table_name
ALTER COLUMN column_name DATA_TYPE NOT NULL;

-- Real Examples: Modifying ds_students
ALTER TABLE ds_students
ADD CONSTRAINT chk_student_age CHECK (age >= 18);

ALTER TABLE ds_students
ADD CONSTRAINT df_enrollment_date DEFAULT GETDATE() FOR enrollment_date;

ALTER TABLE ds_students
ALTER COLUMN full_name VARCHAR(100) NOT NULL;


-- ============================================================================
-- 5. RESTRUCTURING & MODIFYING TABLES (ALTER & RENAME)
-- ============================================================================

-- Syntax: Add a new column
ALTER TABLE table_name
ADD column_name DATA_TYPE;

-- Syntax: Drop a column
ALTER TABLE table_name
DROP COLUMN column_name;

-- Syntax: Rename a column
EXEC sp_rename 'table_name.old_column_name', 'new_column_name', 'COLUMN';

-- Syntax: Rename a table
EXEC sp_rename 'old_table_name', 'new_table_name';

-- Real Examples:
ALTER TABLE ds_students
ADD phone_number VARCHAR(15);

ALTER TABLE ds_students
DROP COLUMN age;

EXEC sp_rename 'ds_students.full_name', 'student_name', 'COLUMN';
EXEC sp_rename 'ds_students', 'course_students';

/* ============================================================================
DATA MANIPULATION (DML) & QUERYING (DQL)
 ============================================================================ */

-- Activate your working database
USE data_science_db;


-- ============================================================================
-- 6. INSERTING DATA INTO TABLES
-- ============================================================================

-- Method A: Column Specification (Recommended Best Practice)
-- Syntax:
INSERT INTO table_name (column1, column2, column3)
VALUES (value1, value2, value3);

-- Real Example: Single Row Insert
INSERT INTO ds_students (student_id, full_name, email, enrollment_date)
VALUES (101, 'Aarav Sharma', 'aarav.sharma@example.com', '2026-01-15');


-- Method B: Column Order (Requires values for ALL columns in exact order)
-- Syntax:
INSERT INTO table_name
VALUES (value1, value2, value3);

-- Real Example:
INSERT INTO ds_students
VALUES (102, 'Priya Patel', 'priya.p@example.com', '2026-02-01', '9876543210');


-- Method C: Multi-Row / Bulk Insert (Multiple Values in one query)
-- Syntax:
INSERT INTO table_name (column1, column2, column3)
VALUES 
    (value1, value2, value3),
    (value4, value5, value6);

-- Real Example:
INSERT INTO ds_students (student_id, full_name, email, enrollment_date)
VALUES 
    (103, 'Rahul Verma', 'rahul.v@example.com', '2026-02-10'),
    (104, 'Ananya Rao',  'ananya.r@example.com', '2026-03-05'),
    (105, 'Kavya Nair',  'kavya.n@example.com',  '2026-03-12');


-- Method D: Insert Using Default Values (Omitted columns take default rule)
-- Real Example:
INSERT INTO ds_students (student_id, full_name, email)
VALUES (106, 'Vikram Singh', 'vikram.s@example.com');


-- ============================================================================
-- 7. UPDATING EXISTING RECORDS (UPDATE)
-- ============================================================================

-- Syntax: Update Specific Rows (ALWAYS USE A WHERE CLAUSE)
UPDATE table_name
SET column1 = new_value1, column2 = new_value2
WHERE condition;

-- Real Example: Update phone number and email for student ID 101
UPDATE ds_students
SET email = 'aarav.official@example.com', phone_number = '9123456789'
WHERE student_id = 101;


-- ============================================================================
-- 8. DELETING DATA (DELETE vs TRUNCATE)
-- ============================================================================

-- METHOD A: DELETE (DML - Selective row removal, slower)
-- Syntax:
DELETE FROM table_name
WHERE condition;

-- Real Example:
DELETE FROM ds_students
WHERE student_id = 106;


-- METHOD B: TRUNCATE (DDL - Deletes ALL rows instantly, resets identity counter)
-- Syntax:
TRUNCATE TABLE table_name;

-- Real Example: (Empties entire table structure, cannot use WHERE clause)
TRUNCATE TABLE ds_students;


/*
  INTERVIEW COMPARISON: DELETE vs TRUNCATE
  -----------------------------------------------------------------------------
  FEATURE             DELETE                           TRUNCATE
  -----------------------------------------------------------------------------
  Type                DML (Data Manipulation)          DDL (Data Definition)
  WHERE Clause        Supported (Selective)            Not Supported (All rows)
  Speed               Slower (Logs each row)           Faster (Deallocates pages)
  Identity Seed       Preserves existing counter       Resets counter to initial
  -----------------------------------------------------------------------------
*/


-- ============================================================================
-- 9. BASIC DATA QUERYING & FILTERING (DQL - SELECT, WHERE, ORDER BY)
-- ============================================================================
-- Syntax: Basic Selection & Filtering
SELECT column1, column2
FROM table_name
WHERE condition
ORDER BY column1 ASC|DESC;

-- Real Examples:

-- Fetch all columns from students table
SELECT * 
FROM ds_students;

-- Fetch unique email domains/names using DISTINCT
SELECT DISTINCT full_name 
FROM ds_students;

-- Filter students enrolled after a specific date and sort alphabetically
SELECT student_id, full_name, email, enrollment_date
FROM ds_students
WHERE enrollment_date >= '2026-02-01'
ORDER BY full_name ASC;



/* ============================================================================
   DATA SCIENCE PRACTICE DATABASE SETUP (20 ROWS)
   ============================================================================ */

-- 1. Create Table
CREATE TABLE ds_employees (
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    department VARCHAR(50),
    salary DECIMAL(10, 2),
    hire_date DATE,
    performance_score INT,
    email VARCHAR(100) UNIQUE,
    project_code VARCHAR(20)
);

-- 2. Insert 20 Records
INSERT INTO ds_employees (emp_id, first_name, last_name, department, salary, hire_date, performance_score, email, project_code)
VALUES 
    (101, 'Ananya', 'Roy', 'Data Science', 85000.00, '2025-01-15', 5, 'ananya.roy@example.com', 'PROJ_AI'),
    (102, 'Rohan', 'Gupta', 'Engineering', 72000.00, '2025-02-01', 3, 'rohan.g@example.com', 'PROJ_WEB'),
    (103, 'Priya', 'Sharma', 'Data Science', 91000.00, '2025-02-10', 4, 'priya.s@example.com', 'PROJ_AI'),
    (104, 'Vikram', 'Mehta', 'HR', 55000.00, '2025-03-01', 2, 'vikram.m@example.com', NULL),
    (105, 'Siddharth', 'Rao', 'Engineering', 78000.00, '2025-03-15', 4, 'siddharth.r@example.com', 'PROJ_WEB'),
    (106, 'Neha', 'Verma', 'Data Science', 95000.00, '2025-04-01', 5, 'neha.v@example.com', 'PROJ_AI'),
    (107, 'Amit', 'Patel', 'Analytics', 68000.00, '2025-05-10', NULL, 'amit.p@example.com', 'PROJ_BI'),
    (108, 'Kavita', 'Reddy', 'Analytics', 71000.00, '2025-06-01', 3, 'kavita.r@example.com', 'PROJ_BI'),
    (109, 'Rajesh', 'Kumar', 'Engineering', 81000.00, '2025-06-15', 4, 'rajesh.k@example.com', 'PROJ_WEB'),
    (110, 'Sneha', 'Nair', 'Data Science', 88000.00, '2025-07-01', 5, 'sneha.n@example.com', 'PROJ_AI'),
    (111, 'Arjun', 'Singh', 'Finance', 64000.00, '2025-07-20', 3, 'arjun.s@example.com', NULL),
    (112, 'Pooja', 'Joshi', 'Finance', 67000.00, '2025-08-05', 4, 'pooja.j@example.com', 'PROJ_FIN'),
    (113, 'Deepak', 'Mishra', 'HR', 52000.00, '2025-08-19', NULL, 'deepak.m@example.com', NULL),
    (114, 'Shweta', 'Deshmukh', 'Analytics', 73000.00, '2025-09-01', 4, 'shweta.d@example.com', 'PROJ_BI'),
    (115, 'Manoj', 'Tiwari', 'Engineering', 76000.00, '2025-09-20', 3, 'manoj.t@example.com', 'PROJ_WEB'),
    (116, 'Divya', 'Kulkarni', 'Data Science', 99000.00, '2025-10-05', 5, 'divya.k@example.com', 'PROJ_AI'),
    (117, 'Suresh', 'Pillai', 'Finance', 61000.00, '2025-10-25', 2, 'suresh.p@example.com', 'PROJ_FIN'),
    (118, 'Meera', 'Iyer', 'Analytics', 75000.00, '2025-11-10', 4, 'meera.i@example.com', 'PROJ_BI'),
    (119, 'Karan', 'Malhotra', 'Engineering', 83000.00, '2025-12-01', 4, 'karan.m@example.com', 'PROJ_WEB'),
    (120, 'Tanvi', 'Chawla', 'HR', 58000.00, '2025-12-15', 3, 'tanvi.c@example.com', NULL);


-- 3. Verify Dataset
SELECT * FROM ds_employees;

/* ============================================================================
   MODULE 10: ADVANCED FILTERING & PATTERN MATCHING
   ============================================================================
   Database Context: ds_analytics_db
   Table Used: ds_employees (20 Rows)
   
   Topics Covered:
   1. IN / NOT IN Operators (Categorical List Filtering)
   2. BETWEEN / NOT BETWEEN Operators (Range Filtering)
   3. LIKE Operator & Wildcards (Text Pattern Search)
   4. IS NULL / IS NOT NULL (Handling Missing Data for Data Science)
   ============================================================================ */

-- ----------------------------------------------------------------------------
-- 1. IN / NOT IN OPERATORS
-- Replaces multiple OR statements. Essential for selecting specific data cohorts.
-- ----------------------------------------------------------------------------

-- Filter employees belonging only to 'Data Science' or 'Analytics':
SELECT emp_id, first_name, department, salary 
FROM ds_employees
WHERE department IN ('Data Science', 'Analytics');

-- Exclude administrative/support departments:
SELECT emp_id, first_name, department 
FROM ds_employees
WHERE department NOT IN ('HR', 'Finance');


-- ----------------------------------------------------------------------------
-- 2. BETWEEN OPERATOR (Inclusive Boundary Filtering)
-- Useful for numerical feature binning or date range slicing.
-- ----------------------------------------------------------------------------

-- Find salaries between $70,000 and $85,000 (Includes $70,000 and $85,000):
SELECT first_name, last_name, salary 
FROM ds_employees
WHERE salary BETWEEN 70000.00 AND 85000.00;

-- Filter employees hired in Q3 2025:
SELECT first_name, hire_date 
FROM ds_employees
WHERE hire_date BETWEEN '2025-07-01' AND '2025-09-30';


-- ----------------------------------------------------------------------------
-- 3. LIKE OPERATOR & WILDCARDS (Text Search)
--   %  = Matches 0 or more characters
--   _  = Matches exactly 1 character
--  []  = Matches any single character within a specified set/range
-- ----------------------------------------------------------------------------

-- Starts with 'S' (e.g., Sneha, Siddharth, Suresh, Shweta):
SELECT first_name, last_name 
FROM ds_employees 
WHERE first_name LIKE 'S%';

-- Ends with 'a':
SELECT first_name, last_name 
FROM ds_employees 
WHERE first_name LIKE '%a';

-- Project codes that start with 'PROJ_' followed by anything:
SELECT emp_id, first_name, project_code 
FROM ds_employees 
WHERE project_code LIKE 'PROJ_%';

-- First name starts with 'A', 'D', or 'K':
SELECT first_name, department 
FROM ds_employees 
WHERE first_name LIKE '[ADK]%';


-- ----------------------------------------------------------------------------
-- 4. HANDLING NULL VALUES (Missing Data Identification)
-- In Data Science, missing values (NULL) represent missing observations.
-- ALWAYS use 'IS NULL' / 'IS NOT NULL'. Never use '= NULL'.
-- ----------------------------------------------------------------------------

-- Identify employees who are NOT assigned to any project (project_code IS NULL):
SELECT emp_id, first_name, department, project_code 
FROM ds_employees
WHERE project_code IS NULL;

-- Identify employees who have a valid performance evaluation:
SELECT emp_id, first_name, performance_score 
FROM ds_employees
WHERE performance_score IS NOT NULL;


/* ============================================================================
   MODULE 11: AGGREGATIONS & GROUPING
   ============================================================================
   Table Used: ds_employees (20 Rows)
   
   Topics Covered:
   1. Aggregate Functions (COUNT, SUM, AVG, MIN, MAX)
   2. GROUP BY Clause (Segmenting Data by Categories)
   3. HAVING Clause vs WHERE Clause (Filtering Grouped Aggregations)
   ============================================================================ */

-- ----------------------------------------------------------------------------
-- 1. AGGREGATE FUNCTIONS
-- Summarize multiple rows into a single metric. 
-- Note: Aggregate functions ignore NULL values (except COUNT(*)).
-- ----------------------------------------------------------------------------
SELECT count(*) FROM ds_employees;
SELECT count(performance_score) FROM ds_employees;
SELECT *  FROM ds_employees;
-- Count total records vs valid non-null evaluations:
SELECT 
    COUNT(*) AS total_employees,
    COUNT(performance_score) AS evaluated_employees
FROM ds_employees;

-- Salary Metrics (Total Payroll, Average, Min, Max):
SELECT 
    SUM(salary) AS total_payroll,
    AVG(salary) AS average_salary,
    MIN(salary) AS lowest_salary,
    MAX(salary) AS highest_salary
FROM ds_employees;


-- ----------------------------------------------------------------------------
-- 2. GROUP BY CLAUSE
-- Groups rows sharing the same summary category to calculate metrics per group.
-- Rule: Every non-aggregated column in the SELECT list MUST be in GROUP BY.
-- ----------------------------------------------------------------------------
SELECT * FROM ds_employees where project_code = PROJ_AI;
SELECT * FROM ds_employees;
SELECT SUM(salary) from ds_employees;

SELECT department, SUM(salary) as Total_Salary,
avg(salary) as average,
count(*) as No_of_EMPs
from ds_employees
GROUP BY department
having count(*) > 3;



SELECT AVG(Salary) as Avg_Salary FROM ds_employees;
SELECT * FROM ds_employees WHERE Salary > (select avg(salary) from ds_employees);








-- Average salary and total headcount per department:
SELECT 
    department,
    COUNT(emp_id) AS head_count,
    AVG(salary) AS avg_salary,
    MAX(performance_score) AS peak_performance
FROM ds_employees
GROUP BY department;

-- Aggregate metrics per project code:
SELECT 
    ISNULL(project_code, 'Unassigned') AS project,
    COUNT(*) AS team_size,
    AVG(salary) AS avg_dept_salary
FROM ds_employees
GROUP BY project_code;


-- ----------------------------------------------------------------------------
-- 3. HAVING CLAUSE (Filtering Aggregated Results)
-- Difference:
--   WHERE filters individual rows BEFORE grouping occurs.
--   HAVING filters groups AFTER aggregation occurs.
-- ----------------------------------------------------------------------------

-- Departments with an average salary greater than $75,000:
SELECT 
    department,
    COUNT(*) AS total_staff,
    AVG(salary) AS avg_salary
FROM ds_employees
GROUP BY department
HAVING AVG(salary) > 75000.00;

-- Combining WHERE and HAVING:
-- Filter for employees hired in 2025, group by department, and keep departments with > 3 staff:
SELECT 
    department,
    COUNT(*) AS hire_count,
    AVG(salary) AS avg_salary
FROM ds_employees
WHERE hire_date >= '2025-01-01'
GROUP BY department
HAVING COUNT(*) > 3;


/* ============================================================================
   MODULE 12: LITERALS & ESSENTIAL SINGLE-ROW FUNCTIONS
   ============================================================================
   Table Used: ds_employees (20 Rows)
   
   Topics Covered:
   1. Literals (Constants) in Queries
   2. String Functions (CONCAT, UPPER, LOWER, SUBSTRING, LEN, REPLACE)
   3. Numeric Functions (ROUND, ABS, CEILING, FLOOR)
   4. Date Functions (GETDATE, DATEDIFF, DATEADD, YEAR, MONTH, DAY)
   5. Conditional & Null-Handling Scalar Functions (ISNULL, COALESCE, CASE)
   ============================================================================ */

-- ----------------------------------------------------------------------------
-- 1. LITERALS (Fixed Values)
-- Fixed hardcoded text, numbers, or dates added directly into output columns.
-- ----------------------------------------------------------------------------

SELECT 
    emp_id, 
    first_name, 
    'Active' AS status_literal,               -- String Literal
    2026 AS current_year_literal,             -- Numeric Literal
    100.00 AS default_bonus_literal           -- Decimal Literal
FROM ds_employees;

SELECT * from ds_employees;
SELECT first_name + ' is working in ' + department from ds_employees;


-- ----------------------------------------------------------------------------
-- 2. STRING FUNCTIONS (Data Cleaning & Feature Engineering)
-- ----------------------------------------------------------------------------

SELECT 
    -- Combine text columns into a single string (e.g., Full Name)
    CONCAT(first_name, ' ', last_name) AS full_name,
    
    -- Case transformations (standardizing category names)
    UPPER(department) AS dept_uppercase,
    LOWER(email) AS email_lowercase,
    
    -- String length (counting characters)
    LEN(first_name) AS first_name_length,
    
    -- Substring (extracting parts of text: SUBSTRING(string, start, length)) (Similar to Excel MID function)
    SUBSTRING(project_code, 6, 2) AS project_short_code, -- Extracts 'AI', 'WE', etc.
    
    -- Text replacement (cleaning bad characters)
    REPLACE(project_code, 'PROJ_', 'P_') AS clean_project_code
FROM ds_employees;


-- ----------------------------------------------------------------------------
-- 3. NUMERIC FUNCTIONS (Feature Scaling & Transformations)
-- ----------------------------------------------------------------------------

SELECT 
    salary,
    ROUND(salary / 12.0, 2) AS monthly_salary_rounded, -- Round to 2 decimals
    CEILING(salary / 12.0) AS monthly_salary_ceiling,   -- Round UP to next integer
    FLOOR(salary / 12.0) AS monthly_salary_floor,       -- Round DOWN to integer
    ABS(-5000.00) AS absolute_value_example             -- Absolute 
FROM ds_employees;


-- ----------------------------------------------------------------------------
-- 4. DATE FUNCTIONS (Creating Time-Based Features)
-- ----------------------------------------------------------------------------

SELECT 
    first_name,
    hire_date,
    GETDATE() AS query_execution_date,                 -- Current system timestamp
    YEAR(hire_date) AS hire_year,                       -- Extract Year
    MONTH(hire_date) AS hire_month,                     -- Extract Month
    DAY(hire_date) AS hire_day,                         -- Extract Day
    
    -- Calculate tenure/age in months between two dates: DATEDIFF(datepart, start, end)
    DATEDIFF(MONTH, hire_date, GETDATE()) AS tenure_in_months,
    
    -- Add intervals to a date: DATEADD(datepart, number, date)
    DATEADD(YEAR, 1, hire_date) AS one_year_review_date
FROM ds_employees;


-- ----------------------------------------------------------------------------
-- 5. NULL-HANDLING & CONDITIONAL FUNCTIONS
-- ----------------------------------------------------------------------------

SELECT 
    first_name,
    salary,
    performance_score,
    project_code,
    
    -- ISNULL: Replaces NULL with a default value
    ISNULL(project_code, 'UNASSIGNED') AS project_imputed,
    
    -- COALESCE: Evaluates values in order and returns the first non-null
    COALESCE(project_code, department, 'N/A') AS first_available_label,
    
    -- CASE WHEN: Conditional logic (creating categorical features)
    CASE 
        WHEN salary >= 85000.00 THEN 'High Earner'
        WHEN salary >= 70000.00 THEN 'Mid Earner'
        ELSE 'Entry Level'
    END AS salary_tier
FROM ds_employees;

/* ============================================================================
   MODULE 13 PREP: RELATIONAL TABLES SETUP (PRIMARY & FOREIGN KEYS)
   ============================================================================ */

-- 1. Create Parent Table: Departments
CREATE TABLE ds_departments (
    dept_id INT PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL,
    location VARCHAR(50) NOT NULL
);


-- 2. Create Child Table: Employees with Foreign Key link
CREATE TABLE ds_relational_employees (
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    salary DECIMAL(10, 2),
    dept_id INT, -- Foreign Key referencing ds_departments
    CONSTRAINT fk_employee_department 
        FOREIGN KEY (dept_id) 
        REFERENCES ds_departments(dept_id)
);


-- 3. Populate Parent Table (Departments)
INSERT INTO ds_departments (dept_id, department_name, location)
VALUES 
    (1, 'Data Science', 'Building A'),
    (2, 'Engineering',  'Building B'),
    (3, 'Analytics',    'Building A'),
    (4, 'HR',           'Building C'),
    (5, 'Marketing',    'Building D'); -- Department with no employees yet


-- 4. Populate Child Table (Employees)
INSERT INTO ds_relational_employees (emp_id, first_name, last_name, salary, dept_id)
VALUES 
    (101, 'Ananya', 'Roy',      85000.00, 1),    -- Data Science
    (102, 'Rohan',  'Gupta',    72000.00, 2),    -- Engineering
    (103, 'Priya',  'Sharma',   91000.00, 1),    -- Data Science
    (104, 'Amit',   'Patel',    68000.00, 3),    -- Analytics
    (105, 'Vikram', 'Mehta',    55000.00, 4),    -- HR
    (106, 'Suresh', 'Raina',    60000.00, NULL); -- Unassigned employee (NULL Foreign Key)


/* ============================================================================
   MODULE 13: SQL JOINS (COMBINING RELATIONAL TABLES)
   ============================================================================
   Database Context: ds_analytics_db
   Tables Used: 
     - Parent: ds_departments (dept_id PK)
     - Child:  ds_relational_employees (emp_id PK, dept_id FK)
   
   Topics Covered:
   1. INNER JOIN (Matching records in both tables)
   2. LEFT (OUTER) JOIN (All records from left + matches from right)
   3. RIGHT (OUTER) JOIN (All records from right + matches from left)
   4. FULL (OUTER) JOIN (All records from both tables)
   5. CROSS JOIN (Cartesian Product)
   ============================================================================ */

-- ============================================================================
-- PART 1: LECTURE NOTES & EXAMPLES
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. INNER JOIN
-- Returns ONLY rows where the join condition matches in BOTH tables.
-- Excludes: Unassigned employees (dept_id IS NULL) and departments with no staff.
-- ----------------------------------------------------------------------------
SELECT 
    e.emp_id,
    e.first_name,
    e.last_name,
    d.department_name,
    d.location
FROM ds_relational_employees AS e
INNER JOIN ds_departments AS d
    ON e.dept_id = d.dept_id;


-- ----------------------------------------------------------------------------
-- 2. LEFT JOIN (LEFT OUTER JOIN)
-- Returns ALL rows from the LEFT table (employees), and matching rows from the
-- RIGHT table (departments). Unmatched right values return NULL.
-- Ideal for finding unassigned entities or keeping complete employee lists.
-- ----------------------------------------------------------------------------
SELECT 
    e.emp_id,
    e.first_name,
    d.department_name,
    ISNULL(d.location, 'No Office Assigned') AS office_location
FROM ds_relational_employees AS e
LEFT JOIN ds_departments AS d
    ON e.dept_id = d.dept_id;


-- ----------------------------------------------------------------------------
-- 3. RIGHT JOIN (RIGHT OUTER JOIN)
-- Returns ALL rows from the RIGHT table (departments), and matching rows from 
-- the LEFT table (employees).
-- Reveals empty departments (e.g., Marketing has no employees assigned).
-- ----------------------------------------------------------------------------
SELECT 
    d.dept_id,
    d.department_name,
    e.first_name,
    e.last_name
FROM ds_relational_employees AS e
RIGHT JOIN ds_departments AS d
    ON e.dept_id = d.dept_id;


-- ----------------------------------------------------------------------------
-- 4. FULL OUTER JOIN
-- Returns ALL rows from BOTH tables. If there is no match, NULLs fill the gaps.
-- Useful for complete dataset auditing and detecting orphan records.
-- ----------------------------------------------------------------------------
SELECT 
    e.emp_id,
    e.first_name,
    d.department_name,
    d.location
FROM ds_relational_employees AS e
FULL OUTER JOIN ds_departments AS d
    ON e.dept_id = d.dept_id;


-- ----------------------------------------------------------------------------
-- 5. CROSS JOIN (Cartesian Product)
-- Combines every single row of the first table with every row of the second table.
-- Output rows = (Rows in Table A) * (Rows in Table B).
-- Common in Data Science for generating feature grids or grid search combinations.
-- ----------------------------------------------------------------------------
SELECT 
    e.first_name,
    d.department_name
FROM ds_relational_employees AS e
CROSS JOIN ds_departments AS d;





/* ============================================================================
   MODULE 14: FOREIGN KEY CASCADING ACTIONS
   ============================================================================
     
   Topics Covered:
   1. Understanding Referential Integrity & Foreign Key Behavior
   2. Default Foreign Key Behavior (NO ACTION / RESTRICT)
   3. ON DELETE CASCADE & ON UPDATE CASCADE
   4. ON DELETE SET NULL & ON UPDATE SET NULL
   5. Modifying Foreign Key Constraints via ALTER TABLE
   ============================================================================ */

-- ============================================================================
-- PART 1: LECTURE NOTES & CODE EXAMPLES
-- ============================================================================

/*
   WHAT ARE CASCADING ACTIONS?
   -----------------------------------------------------------------------------
   When parent table records change (e.g., a department ID is updated or deleted),
   Foreign Key cascading rules define what happens automatically to matching child
   records in dependent tables.

   FOUR MAIN CASCADING RULES:
   1. NO ACTION / RESTRICT (Default): Prevents parent modification if child records exist.
   2. CASCADE                      : Automatically updates or deletes matching child rows.
   3. SET NULL                     : Sets the child foreign key column to NULL.
   4. SET DEFAULT                  : Sets the child foreign key column to its DEFAULT value.
*/

-- ----------------------------------------------------------------------------
-- 1. CREATING TABLES WITH CASCADING CONSTRAINTS
-- ----------------------------------------------------------------------------

-- Parent Table: Projects
CREATE TABLE ds_projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    lead_domain VARCHAR(50) NOT NULL
);


-- Child Table: Project Assignments with ON DELETE CASCADE and ON UPDATE CASCADE
CREATE TABLE ds_project_assignments (
    assignment_id INT PRIMARY KEY,
    emp_id INT NOT NULL,
    project_id INT,
    assigned_hours INT DEFAULT 40,
    
    -- Foreign Key Definition with Cascading Options:
    CONSTRAINT fk_assignment_project 
        FOREIGN KEY (project_id) 
        REFERENCES ds_projects(project_id)
        ON UPDATE CASCADE   -- Primary Key change in parent auto-updates child
        ON DELETE CASCADE   -- Parent record deletion auto-deletes child rows
);


-- Insert Sample Parent Data
INSERT INTO ds_projects (project_id, project_name, lead_domain)
VALUES 
    (10, 'Customer Churn Prediction', 'Machine Learning'),
    (20, 'ETL Data Pipeline V2',     'Data Engineering'),
    (30, 'Executive KPI Dashboard',  'Business Intelligence');

-- Insert Sample Child Data
INSERT INTO ds_project_assignments (assignment_id, emp_id, project_id, assigned_hours)
VALUES 
    (1, 101, 10, 20),
    (2, 102, 10, 40),
    (3, 103, 20, 30),
    (4, 104, 30, 15);



-- ----------------------------------------------------------------------------
-- 2. UPDATE CASCADE
-- ----------------------------------------------------------------------------
-- Updating Project ID 10 to 100 in parent table:
UPDATE ds_projects
SET project_id = 100
WHERE project_id = 10;

-- Verify child table: project_id for employees 101 and 102 automatically changed to 100!
SELECT * FROM ds_project_assignments WHERE project_id = 100;


-- ----------------------------------------------------------------------------
-- 3. DELETE CASCADE
-- ----------------------------------------------------------------------------
-- Deleting Project ID 20 from parent table:
DELETE FROM ds_projects
WHERE project_id = 20;

-- Verify child table: assignment row #3 for Project 20 was automatically purged!
SELECT * FROM ds_project_assignments;


/* ============================================================================
   MODULE 15: SUBQUERIES & COMMON TABLE EXPRESSIONS (CTEs)
   ============================================================================
      
   Topics Covered:
   1. Scalar Subqueries (Single Value Output)
   2. Multi-Row Subqueries (IN, ANY, ALL)
   3. Correlated Subqueries (Row-by-Row Execution)
   4. Common Table Expressions (CTEs using WITH Clause)
   5. Chaining Multiple CTEs for Data Science Pipelines
   ============================================================================ */

-- ============================================================================
-- PART 1: LECTURE NOTES & EXAMPLES
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. SCALAR SUBQUERIES (Returns exactly ONE row and ONE column)
-- Useful for benchmark comparisons (e.g., comparing individual salary vs avg salary).
-- ----------------------------------------------------------------------------

-- Real DS Example: Find all employees earning ABOVE the overall company average salary
SELECT 
    emp_id,
    first_name,
    salary,
    (SELECT AVG(salary) FROM ds_employees) AS company_avg_salary,
    ROUND(salary - (SELECT AVG(salary) FROM ds_employees), 2) AS salary_variance
FROM ds_employees
WHERE salary > (SELECT AVG(salary) FROM ds_employees);


-- ----------------------------------------------------------------------------
-- 2. MULTI-ROW SUBQUERIES (Returns a single column with multiple rows)
-- Combines with IN / NOT IN operators for filtering dynamic sets.
-- ----------------------------------------------------------------------------

-- Real DS Example: Find employees working in top-performing departments 
-- (departments where at least one person has a performance score of 5)
SELECT 
    emp_id, 
    first_name, 
    department, 
    salary
FROM ds_employees
WHERE department IN (
    SELECT DISTINCT department 
    FROM ds_employees 
    WHERE performance_score = 5
);


-- ----------------------------------------------------------------------------
-- 3. CORRELATED SUBQUERIES (Inner query references columns from outer query)
-- Executes row-by-row. Essential for group-relative  analysis.
-- ----------------------------------------------------------------------------

-- Real DS Example: Find employees who earn MORE than their specific department's average
SELECT 
    e.emp_id,
    e.first_name,
    e.department,
    e.salary
FROM ds_employees AS e
WHERE e.salary > (
    SELECT AVG(e_sub.salary)
    FROM ds_employees AS e_sub
    WHERE e_sub.department = e.department
);


-- ----------------------------------------------------------------------------
-- 4. COMMON TABLE EXPRESSIONS (CTEs - WITH CLAUSE)
-- A CTE creates a temporary, readable result set referenced within a main query.
-- Best practice in Data Engineering and Data Science over nested subqueries!
-- ----------------------------------------------------------------------------

-- Real DS Example: Calculate department summary metrics and filter high-budget departments
WITH DeptSalaryMetrics AS (
    SELECT 
        department,
        COUNT(emp_id) AS total_staff,
        AVG(salary) AS avg_dept_salary,
        SUM(salary) AS total_dept_budget
    FROM ds_employees
    GROUP BY department
)
SELECT 
    department,
    total_staff,
    ROUND(avg_dept_salary, 2) AS avg_dept_salary,
    total_dept_budget
FROM DeptSalaryMetrics
WHERE total_dept_budget > 250000.00
ORDER BY total_dept_budget DESC;


/* ============================================================================
   MODULE 16: SQL WINDOW FUNCTIONS (ADVANCED ANALYTICAL SCORING)
   ============================================================================
    
   Topics Covered:
   1. Introduction to OVER() and PARTITION BY Clauses
   2. Ranking Functions: ROW_NUMBER(), RANK(), DENSE_RANK()
   3. Value / Offset Functions: LAG(), LEAD() for Time-Series Analysis
   4. Aggregate Window Functions: Running Totals (SUM OVER) & Moving Averages
   5. Advanced Use Case: Deduplication & Top-N Per Category Pattern
   ============================================================================ */


-- ============================================================================
-- PART 1: LECTURE NOTES & EXAMPLES
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. RANKING FUNCTIONS: ROW_NUMBER() vs. RANK() vs. DENSE_RANK()
--
-- Syntax Overview:
--   <Function>() OVER (
--       PARTITION BY <group_column> 
--       ORDER BY <sort_column> [ASC|DESC]
--   )
--
-- Differences:
--   - ROW_NUMBER() : Assigns a sequential integer (1, 2, 3, 4...). No ties.
--   - RANK()       : Assigns same rank to ties, then SKIPS next ranks (1, 2, 2, 4...).
--   - DENSE_RANK() : Assigns same rank to ties, NO rank skipping (1, 2, 2, 3...).
-- ----------------------------------------------------------------------------

-- Real DS Example: Rank employees by salary across the entire company AND within each department
SELECT 
    emp_id,
    first_name,
    department,
    salary,
    ROW_NUMBER() OVER (ORDER BY salary DESC) AS overall_row_num,
    ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS dept_row_num,
    RANK()       OVER (PARTITION BY department ORDER BY salary DESC) AS dept_rank,
    DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dept_dense_rank
FROM ds_employees;
SELECT * FROM ds_employees;
INSERT INTO ds_employees VALUES (121,'Arun','Kumar','Data Science',85000.00,
'2025-01-15',5,'arun.kumar@example.com','PROJ_AI');
INSERT INTO ds_employees VALUES (122,'Kusuma','Kumari','Data Science',84000.00,
'2025-01-15',5,'kusuma.kumari@example.com','PROJ_AI');

SELECT * FROM 
( SELECT 
    emp_id,
    first_name,
    department,
    salary,    
    RANK()       OVER (PARTITION BY department ORDER BY salary DESC) AS dept_rank    
FROM ds_employees ) as Sub_Query
WHERE dept_rank = 1;




-- ----------------------------------------------------------------------------
-- 2. AGGREGATE WINDOW FUNCTIONS (RUNNING TOTALS & DEPT AVERAGES)
-- Computes aggregations without collapsing rows.
-- ----------------------------------------------------------------------------

-- Real DS Example: Calculate company running salary total and compare individual 
-- salary against department average and percentage of department total.
SELECT 
    emp_id,
    first_name,
    department,
    salary,
    -- Dept Average alongside individual records
    AVG(salary) OVER (PARTITION BY department) AS dept_avg_salary,
    
    -- Variance from Dept Avg
    ROUND(salary - AVG(salary) OVER (PARTITION BY department), 2) AS salary_diff_from_avg,
    
    -- Cumulative / Running Total ordered by hire date
    SUM(salary) OVER (ORDER BY hire_date ASC) AS cumulative_salary_spend
FROM ds_employees;



-- ----------------------------------------------------------------------------
-- 3. OFFSET FUNCTIONS: LAG() AND LEAD()
-- Used extensively in time-series analysis to access prior or subsequent row values.
--   - LAG(col, n)  : Looks back 'n' rows.
--   - LEAD(col, n) : Looks forward 'n' rows.
-- ----------------------------------------------------------------------------
SELECT * FROM ds_employees;
-- Real DS Example: Compare each employee's salary to the employee hired immediately before them
SELECT 
    emp_id,
    first_name,
    hire_date,
    salary,
    Lag(salary) OVER (ORDER BY hire_date ASC) AS previous_hire_salary,
    ROUND(salary - LAG(salary, 1) OVER (ORDER BY hire_date ASC), 2) AS diff_from_previous_hire
FROM ds_employees;

-- Create a table with columns Year, Sales
-- Find the difference with last year sales


-- ----------------------------------------------------------------------------
-- 4. TOP-N PER CATEGORY PATTERN (USING CTE + DENSE_RANK)
-- Common Data Science Interview Question & Feature Engineering Task.
-- ----------------------------------------------------------------------------

-- Real DS Example: Fetch the Top 1 highest earner per department
WITH RankedSalaries AS (
    SELECT 
        emp_id,
        first_name,
        department,
        salary,
        DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rnk
    FROM ds_employees
)
SELECT 
    emp_id,
    first_name,
    department,
    salary
FROM RankedSalaries
WHERE rnk = 1;



/* ============================================================================
   MODULE 17: CONDITIONAL LOGIC & FEATURE ENGINEERING (CASE WHEN)
   ============================================================================
     
   Topics Covered:
   1. Standard CASE WHEN Syntax (Simple vs. Searched)
   2. Numerical Binning & Categorical Bucket Creation
   3. Binary & Indicator Flags (0/1 Coding for ML Inputs)
   4. Conditional Aggregations (SUM/COUNT with CASE WHEN)
   5. Handling NULLs & Data Cleaning with CASE WHEN
   ============================================================================ */
-- ============================================================================
-- PART 1:  NOTES & EXAMPLES
-- ============================================================================

-- ----------------------------------------------------------------------------
-- NUMERICAL BINNING & CATEGORICAL BUCKETS (FEATURE ENGINEERING)
-- Useful for transforming continuous numerical features into discrete bins.
-- ----------------------------------------------------------------------------

-- Real DS Example: Segment employees into salary tiers for compensation modeling
SELECT 
    emp_id,
    first_name,
    salary,
    CASE 
        WHEN salary >= 100000 THEN 'High Tier'
        WHEN salary >= 70000  THEN 'Mid Tier'
        ELSE 'Entry Tier'
    END AS salary_bracket
FROM ds_employees;



-- ----------------------------------------------------------------------------
-- COMBINING CASE WHEN WITH WINDOW FUNCTIONS
-- Useful for group-relative conditional flagging.
-- ----------------------------------------------------------------------------

-- Real DS Example: Flag employees earning above their department average
WITH DeptSalaryStats AS (
    SELECT 
        emp_id,
        first_name,
        department,
        salary,
        AVG(salary) OVER (PARTITION BY department) AS dept_avg_salary
    FROM ds_employees
)
SELECT 
    emp_id,
    first_name,
    department,
    salary,
    ROUND(dept_avg_salary, 2) AS dept_avg_salary,
    CASE 
        WHEN salary > dept_avg_salary THEN 'Above Dept Avg'
        WHEN salary = dept_avg_salary THEN 'At Dept Avg'
        ELSE 'Below Dept Avg'
    END AS salary_position
FROM DeptSalaryStats;


/* ============================================================================
   PRACTICE DATASET SETUP FOR SET OPERATIONS
   ============================================================================ */

CREATE TABLE ds_employees_active (
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    department VARCHAR(50),
    salary DECIMAL(10, 2),
    location VARCHAR(50)
);

INSERT INTO ds_employees_active VALUES
(101, 'Ananya', 'Data Science', 85000.00, 'Bengaluru'),
(102, 'Rohan', 'Engineering', 72000.00, 'Hyderabad'),
(103, 'Priya', 'Data Science', 91000.00, 'Bengaluru'),
(105, 'Siddharth', 'Engineering', 78000.00, 'Pune'),
(106, 'Neha', 'Data Science', 95000.00, 'Bengaluru'),
(107, 'Amit', 'Analytics', 68000.00, 'Mumbai');

CREATE TABLE ds_employees_regional (
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    department VARCHAR(50),
    salary DECIMAL(10, 2),
    location VARCHAR(50)
);

INSERT INTO ds_employees_regional VALUES
(101, 'Ananya', 'Data Science', 85000.00, 'Bengaluru'), -- Duplicate in both
(102, 'Rohan', 'Engineering', 72000.00, 'Hyderabad'), -- Duplicate in both
(201, 'Kavya', 'Analytics', 71000.00, 'Chennai'),     -- Regional only
(202, 'Manish', 'Data Science', 88000.00, 'Delhi'),    -- Regional only
(203, 'Suresh', 'Finance', 61000.00, 'Mumbai');        -- Regional only



/* ============================================================================
   NEW MASTER DATASET: E-COMMERCE & CUSTOMER ANALYTICS
   ============================================================================ */

 /* Set operators allow you to combine rows from two or more SELECT queries vertically
 (stacking datasets on top of each other), unlike JOINs which combine columns horizontally.
 
The 3 Rules:
Both queries must select the exact same number of columns.
Corresponding columns must have compatible data types.
Place ORDER BY only once at the very bottom of the final query.


UNION	    Combines rows + removes duplicates
UNION ALL	Combines rows + keeps duplicates
INTERSECT	Returns only shared records
EXCEPT	    Returns rows in Set A missing from Set B

*/


-- Main Active Customers Table (20 Records)
CREATE TABLE customer_orders (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL,
    category VARCHAR(50),
    total_orders INT,
    total_spend DECIMAL(10, 2),
    signup_date DATE,
    acquisition_channel VARCHAR(30),
    churn_risk_score INT, -- 1 (Low) to 5 (High)
    account_status VARCHAR(20)
);

INSERT INTO customer_orders (customer_id, customer_name, category, total_orders, total_spend, signup_date, acquisition_channel, churn_risk_score, account_status)
VALUES 
    (1001, 'Aarav Sharma', 'Electronics', 12, 145000.00, '2025-01-10', 'Google Search', 1, 'Active'),
    (1002, 'Diya Patel', 'Fashion', 3, 12500.00, '2025-01-18', 'Instagram Ads', 4, 'Active'),
    (1003, 'Kabir Mehta', 'Electronics', 8, 89000.00, '2025-02-05', 'Organic Direct', 2, 'Active'),
    (1004, 'Ananya Rao', 'Home & Living', 1, 3400.00, '2025-02-12', 'Instagram Ads', 5, 'Churned'),
    (1005, 'Rohan Verma', 'Electronics', 15, 210000.00, '2025-03-01', 'Google Search', 1, 'Active'),
    (1006, 'Isha Nair', 'Beauty', 6, 24500.00, '2025-03-15', 'Influencer', 2, 'Active'),
    (1007, 'Aditya Joshi', 'Fashion', 2, 8100.00, '2025-04-02', 'Facebook Ads', 4, 'Active'),
    (1008, 'Meera Iyer', 'Home & Living', 9, 67000.00, '2025-04-20', 'Google Search', 2, 'Active'),
    (1009, 'Siddharth Sen', 'Electronics', 4, 45000.00, '2025-05-04', 'Organic Direct', 3, 'Active'),
    (1010, 'Pooja Reddy', 'Beauty', 11, 38000.00, '2025-05-19', 'Influencer', 1, 'Active'),
    (1011, 'Vikram Malhotra', 'Fashion', 0, 0.00, '2025-06-01', 'Facebook Ads', 5, 'Inactive'),
    (1012, 'Tanvi Kapoor', 'Beauty', 5, 19200.00, '2025-06-15', 'Instagram Ads', 2, 'Active'),
    (1013, 'Arjun Das', 'Home & Living', 7, 52000.00, '2025-07-01', 'Google Search', 3, 'Active'),
    (1014, 'Neha Deshmukh', 'Electronics', 14, 185000.00, '2025-07-18', 'Google Search', 1, 'Active'),
    (1015, 'Karan Bhatia', 'Fashion', 2, 6500.00, '2025-08-02', 'Facebook Ads', 4, 'Churned'),
    (1016, 'Sanya Pillai', 'Beauty', 8, 31000.00, '2025-08-20', 'Influencer', 2, 'Active'),
    (1017, 'Varun Saxena', 'Home & Living', 3, 14800.00, '2025-09-05', 'Organic Direct', 4, 'Active'),
    (1018, 'Riya Choudhury', 'Fashion', 10, 48000.00, '2025-09-22', 'Instagram Ads', 1, 'Active'),
    (1019, 'Gaurav Kulkarni', 'Electronics', 1, 15000.00, '2025-10-10', 'Google Search', 5, 'Inactive'),
    (1020, 'Kavya Singh', 'Beauty', 13, 56000.00, '2025-10-28', 'Influencer', 1, 'Active');

-- Secondary Regional Campaign Table (For Set Operations: UNION / INTERSECT / EXCEPT)
CREATE TABLE regional_promo_leads (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    category VARCHAR(50),
    signup_date DATE,
    acquisition_channel VARCHAR(30)
);

INSERT INTO regional_promo_leads (customer_id, customer_name, category, signup_date, acquisition_channel)
VALUES
    (1001, 'Aarav Sharma', 'Electronics', '2025-01-10', 'Google Search'),  -- Shared in main DB
    (1002, 'Diya Patel', 'Fashion', '2025-01-18', 'Instagram Ads'),        -- Shared in main DB
    (2001, 'Yash Gupta', 'Electronics', '2025-11-01', 'Festival Promo'),    -- Unique to Regional
    (2002, 'Sneha Agarwal', 'Fashion', '2025-11-05', 'Festival Promo'),    -- Unique to Regional
    (2003, 'Manish Pandey', 'Beauty', '2025-11-12', 'Affiliate Network');   -- Unique to Regional



-- Sample Examples

-- 1. UNION: Unique customer list across main and regional datasets
SELECT customer_id, customer_name, category FROM customer_orders
UNION
SELECT customer_id, customer_name, category FROM regional_promo_leads;

-- 2. UNION ALL: Fast merge of all user registrations (preserves duplicates)
SELECT customer_id, customer_name, 'Main Platform' AS source FROM customer_orders
UNION ALL
SELECT customer_id, customer_name, 'Regional Campaign' AS source FROM regional_promo_leads;

-- 3. INTERSECT: Users existing in BOTH main orders and promo campaign
SELECT customer_id, customer_name FROM customer_orders
INTERSECT
SELECT customer_id, customer_name FROM regional_promo_leads;

-- 4. EXCEPT: Promo campaign leads who have NOT ordered on main platform yet
SELECT customer_id, customer_name FROM regional_promo_leads
EXCEPT
SELECT customer_id, customer_name FROM customer_orders;

/* ============================================================================
   MODULE 18: SET OPERATORS
   ============================================================================
    
   Topics Covered:
   1. Rules for Set Operations (Column Compatibility)
   2. UNION (Consolidating Lists with Automatic Deduplication)
   3. UNION ALL (High-Performance Dataset Combining)
   4. INTERSECT (Finding Customer Overlap Across Channels)
   5. EXCEPT (Auditing Missing Leads & Lead Leakage)
   ============================================================================ */

-- ----------------------------------------------------------------------------
-- 1. UNION OPERATOR (Combine + Deduplicate)
-- Combines records from main database and regional promo leads, removing duplicate rows.
-- ----------------------------------------------------------------------------

-- Real DS Example: Generate a master unique email list from main database and regional leads
SELECT customer_id, customer_name, category, acquisition_channel
FROM customer_orders

UNION

SELECT customer_id, customer_name, category, acquisition_channel
FROM regional_promo_leads;


-- ----------------------------------------------------------------------------
-- 2. UNION ALL OPERATOR (Fast Stacking)
-- Stacks datasets while keeping duplicates. Far faster for big data pipelines.
-- ----------------------------------------------------------------------------

-- Real DS Example: Append festival promo traffic directly into main user activity stream
SELECT customer_id, customer_name, acquisition_channel, 'Main Platform' AS lead_source
FROM customer_orders

UNION ALL

SELECT customer_id, customer_name, acquisition_channel, 'Regional Campaign' AS lead_source
FROM regional_promo_leads;


-- ----------------------------------------------------------------------------
-- 3. INTERSECT OPERATOR (Identify Overlap)
-- Finds customers who exist in BOTH the primary database and the regional leads.
-- ----------------------------------------------------------------------------

-- Real DS Example: Identify main platform users who also registered through festival promo
SELECT customer_id, customer_name, category
FROM customer_orders

INTERSECT

SELECT customer_id, customer_name, category
FROM regional_promo_leads;


-- ----------------------------------------------------------------------------
-- 4. EXCEPT OPERATOR (Dataset Reconciliation)
-- Returns records in the first table that are missing from the second table.
-- ----------------------------------------------------------------------------

-- Real DS Example A: Identify regional promo leads who have NOT yet converted to main platform
SELECT customer_id, customer_name, category
FROM regional_promo_leads

EXCEPT

SELECT customer_id, customer_name, category
FROM customer_orders;


-- Real DS Example B: Main platform customers who were NOT part of the regional promo
SELECT customer_id, customer_name, category
FROM customer_orders

EXCEPT

SELECT customer_id, customer_name, category
FROM regional_promo_leads;




/* ============================================================================
   DATA SCIENCE PIPELINE SCHEMA: EMPLOYEES & DEPARTMENTS
   Database Engine: SQL Server (T-SQL) / PostgreSQL Compatible
   ============================================================================ */

-- 1. Create Departments Table (Parent Table)
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL UNIQUE,
    location VARCHAR(50) NOT NULL
);

-- 2. Create Employees Table (Child Table with Foreign Key & Referential Integrity)
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50) NOT NULL,
    salary DECIMAL(10, 2) CHECK (salary > 0),
    dept_id INT,
    
    -- Foreign Key Constraint with Cascade Rules
    CONSTRAINT fk_employee_department 
        FOREIGN KEY (dept_id) 
        REFERENCES departments(dept_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 3. Populate Parent Table (Departments)
INSERT INTO departments (dept_id, dept_name, location) VALUES
(10, 'Data Science', 'Bengaluru'),
(20, 'Engineering', 'Hyderabad'),
(30, 'Analytics', 'Mumbai');

-- 4. Populate Child Table (Employees)
INSERT INTO employees (emp_id, emp_name, salary, dept_id) VALUES
(101, 'Ananya Sharma', 95000.00, 10),
(102, 'Rohan Verma', 72000.00, 20),
(103, 'Priya Nair', 88000.00, 10),
(104, 'Siddharth Rao', 65000.00, 30);

UPDATE departments 
SET dept_id = 100 
WHERE dept_id = 10;

DELETE FROM departments 
WHERE dept_id = 30;

SELECT 
    e.emp_id, 
    e.emp_name, 
    e.salary, 
    d.dept_id, 
    d.dept_name, 
    d.location
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id;