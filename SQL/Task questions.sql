-- ============================================================================
-- Tasks
-- ============================================================================

-- ----------------------------------------------------------------------------
-- ENVIRONMENT SETUP & DATASET
-- ----------------------------------------------------------------------------

CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    CategoryID INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    StockQuantity INT NOT NULL,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

CREATE TABLE OnlineSales (
    SaleID INT PRIMARY KEY,
    ProductID INT NOT NULL,
    CustomerEmail VARCHAR(100) NOT NULL,
    SaleDate DATE NOT NULL,
    Quantity INT NOT NULL,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE StoreSales (
    SaleID INT PRIMARY KEY,
    ProductID INT NOT NULL,
    CustomerEmail VARCHAR(100) NOT NULL,
    SaleDate DATE NOT NULL,
    Quantity INT NOT NULL,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Populate Categories
INSERT INTO Categories (CategoryID, CategoryName) VALUES 
(1, 'Laptops'),
(2, 'Smartphones'),
(3, 'Accessories'),
(4, 'Audio');

-- Populate Products
INSERT INTO Products (ProductID, ProductName, CategoryID, Price, StockQuantity) VALUES 
(101, 'ProBook 15', 1, 1200.00, 15),
(102, 'UltraPhone X', 2, 999.50, 30),
(103, 'Wireless Mouse', 3, 25.00, 100),
(104, 'Noise Cancel Headphones', 4, 199.99, 45),
(105, 'USB-C Cable', 3, 12.50, 200);

-- Populate OnlineSales
INSERT INTO OnlineSales (SaleID, ProductID, CustomerEmail, SaleDate, Quantity) VALUES 
(1, 101, 'john.doe@email.com', '2024-01-10', 1),
(2, 102, 'sara.connor@email.com', '2024-01-15', 2),
(3, 103, 'john.doe@email.com', '2024-02-01', 3),
(4, 104, 'mike.ross@email.com', '2024-02-14', 1),
(5, 105, 'sara.connor@email.com', '2024-03-01', 5);

-- Populate StoreSales
INSERT INTO StoreSales (SaleID, ProductID, CustomerEmail, SaleDate, Quantity) VALUES 
(101, 102, 'sara.connor@email.com', '2024-01-18', 1),
(102, 103, 'rachel.zane@email.com', '2024-02-05', 2),
(103, 105, 'john.doe@email.com', '2024-02-20', 10);


-- ============================================================================
-- TASKS & EXERCISES
-- ============================================================================

/*
-------------------------------------------------------------------------------
TASK 1 (Basic Selection & Filtering)
-------------------------------------------------------------------------------
Write a query to retrieve all products from the 'Products' table that have a 
Price between 20.00 and 1000.00 and have at least 30 units in StockQuantity.
Display ProductID, ProductName, Price, and StockQuantity, ordered by Price 
descending.
*/

-- SOLUTION:




/*
-------------------------------------------------------------------------------
TASK 2 (Aggregations & Grouping)
-------------------------------------------------------------------------------
Write a query to aggregate total units sold from the 'OnlineSales' table per 
ProductID. Display ProductID, total units sold (as TotalUnitsSold), and total 
sales count (as TransactionCount). Only show products where the total units 
sold is greater than or equal to 2.
*/

-- SOLUTION:



/*
-------------------------------------------------------------------------------
TASK 3 (Multi-Table Joins & Subqueries)
-------------------------------------------------------------------------------
Write a query to list all Categories along with the number of unique products 
listed in each category. Include categories that currently have no products 
assigned. Sort the results by total product count descending.
*/

-- SOLUTION:



/*
-------------------------------------------------------------------------------
TASK 4 (Window Functions & CTEs)
-------------------------------------------------------------------------------
Using a CTE and the ROW_NUMBER() window function, write a query to find the 
most recent online sale (based on SaleDate) for each customer. 
Display CustomerEmail, ProductID, SaleDate, and Quantity.
*/

-- SOLUTION:



/*
-------------------------------------------------------------------------------
TASK 5 (Built-in Functions)
-------------------------------------------------------------------------------
/*
Question:
Write a query to display all customer emails from 'OnlineSales' in LOWERCASE, 
along with a new column named 'DaysAgo' that calculates how many days have 
passed between the SaleDate and today's date (GETDATE()).
*/

-- SOLUTION:

*/



-- ============================================================================
-- HOSPITAL MANAGEMENT SYSTEM
-- ============================================================================

-- ----------------------------------------------------------------------------
-- ENVIRONMENT SETUP & DATASET
-- ----------------------------------------------------------------------------
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50) NOT NULL,
    Location VARCHAR(50) NOT NULL
);

CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY,
    DoctorName VARCHAR(100) NOT NULL,
    DepartmentID INT NOT NULL,
    ConsultationFee DECIMAL(10,2) NOT NULL,
    HireDate DATE NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY,
    DoctorID INT NOT NULL,
    PatientEmail VARCHAR(100) NOT NULL,
    AppointmentDate DATE NOT NULL,
    Status VARCHAR(20) NOT NULL, -- 'Completed', 'Cancelled', 'Pending'
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

CREATE TABLE EmergencyVisits (
    VisitID INT PRIMARY KEY,
    PatientEmail VARCHAR(100) NOT NULL,
    VisitDate DATE NOT NULL,
    Severity VARCHAR(20) NOT NULL
);

-- Populate Departments
INSERT INTO Departments (DepartmentID, DepartmentName, Location) VALUES 
(1, 'Cardiology', 'Building A - Floor 2'),
(2, 'Neurology', 'Building B - Floor 1'),
(3, 'Pediatrics', 'Building A - Floor 1'),
(4, 'Orthopedics', 'Building C - Floor 3');

-- Populate Doctors
INSERT INTO Doctors (DoctorID, DoctorName, DepartmentID, ConsultationFee, HireDate) VALUES 
(101, 'Dr. Sarah Connor', 1, 200.00, '2019-03-15'),
(102, 'Dr. Gregory House', 2, 350.00, '2015-08-01'),
(103, 'Dr. John Watson', 3, 120.00, '2021-01-10'),
(104, 'Dr. Meredith Grey', 1, 180.00, '2020-06-20'),
(105, 'Dr. Leonard McCoy', 4, 150.00, '2018-11-05');

-- Populate Appointments
INSERT INTO Appointments (AppointmentID, DoctorID, PatientEmail, AppointmentDate, Status) VALUES 
(1, 101, 'bruce.wayne@email.com', '2024-02-01', 'Completed'),
(2, 102, 'clark.kent@email.com', '2024-02-03', 'Completed'),
(3, 101, 'diana.prince@email.com', '2024-02-10', 'Cancelled'),
(4, 103, 'bruce.wayne@email.com', '2024-02-15', 'Completed'),
(5, 104, 'peter.parker@email.com', '2024-03-01', 'Pending'),
(6, 102, 'bruce.wayne@email.com', '2024-03-05', 'Completed');

-- Populate EmergencyVisits
INSERT INTO EmergencyVisits (VisitID, PatientEmail, VisitDate, Severity) VALUES 
(501, 'clark.kent@email.com', '2024-01-20', 'High'),
(502, 'tony.stark@email.com', '2024-02-12', 'Critical'),
(503, 'bruce.wayne@email.com', '2024-03-02', 'Medium');


-- ============================================================================
-- TASKS
-- ============================================================================

/*
-------------------------------------------------------------------------------
TASK 6 (Basic Selection & Filtering)
-------------------------------------------------------------------------------
Question:
Write a query to retrieve all doctors hired after January 1st, 2018 with a 
ConsultationFee of 180.00 or higher. Display DoctorName, ConsultationFee, 
and HireDate, ordered by ConsultationFee descending.
*/

-- SOLUTION:



/*
-------------------------------------------------------------------------------
TASK 7 (Aggregations & Grouping)
-------------------------------------------------------------------------------
Question:
Write a query to aggregate the Appointments table by DoctorID. Display 
DoctorID, total completed appointments (as TotalCompleted), and total 
appointments overall (as TotalAppointments). Only show doctors who have 
at least 1 completed appointment.
*/

-- SOLUTION:



/*
-------------------------------------------------------------------------------
TASK 8 (Multi-Table Joins & Subqueries)
-------------------------------------------------------------------------------
Question:
Write a query to display all Departments alongside the total number of doctors 
assigned to each department and the average ConsultationFee. Include departments 
that currently have no doctors assigned.
*/

-- SOLUTION:



/*
-------------------------------------------------------------------------------
TASK 9 (Window Functions & CTEs)
-------------------------------------------------------------------------------
Question:
Write a query using DENSE_RANK() to rank doctors within each DepartmentID based 
on their ConsultationFee in descending order. Display DepartmentID, DoctorName, 
ConsultationFee, and the FeeRank.
*/

-- SOLUTION:


/*
-------------------------------------------------------------------------------
TASK 10 (Built-in Functions & Set Operations)
-------------------------------------------------------------------------------
Question:
Write a query using INTERSECT to find all PatientEmails that have booked a 
scheduled appointment in 'Appointments' AND have also had an 'EmergencyVisit'.
Display the email in UPPERCASE.
*/

-- SOLUTION:



-- ============================================================================
-- UNIVERSITY REGISTRATION SYSTEM
-- ============================================================================

-- ----------------------------------------------------------------------------
-- ENVIRONMENT SETUP & DATASET
-- ----------------------------------------------------------------------------

CREATE TABLE Professors (
    ProfessorID INT PRIMARY KEY,
    ProfessorName VARCHAR(100) NOT NULL,
    Department VARCHAR(50) NOT NULL,
    BaseSalary DECIMAL(10,2) NOT NULL
);

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100) NOT NULL,
    ProfessorID INT NULL,
    Credits INT NOT NULL,
    FOREIGN KEY (ProfessorID) REFERENCES Professors(ProfessorID)
);

CREATE TABLE Enrolments (
    EnrolmentID INT PRIMARY KEY,
    StudentID INT NOT NULL,
    CourseID INT NOT NULL,
    EnrolmentDate DATE NOT NULL,
    Grade CHAR(2) NULL, -- 'A', 'B', 'C', 'D', 'F'
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

CREATE TABLE StudentWorkshops (
    WorkshopID INT PRIMARY KEY,
    StudentID INT NOT NULL,
    WorkshopName VARCHAR(100) NOT NULL,
    AttendedDate DATE NOT NULL
);

-- Populate Professors
INSERT INTO Professors (ProfessorID, ProfessorName, Department, BaseSalary) VALUES 
(1, 'Dr. Alan Turing', 'Computer Science', 95000.00),
(2, 'Dr. Ada Lovelace', 'Computer Science', 98000.00),
(3, 'Dr. Isaac Newton', 'Physics', 88000.00),
(4, 'Dr. Marie Curie', 'Chemistry', 92000.00);

-- Populate Courses
INSERT INTO Courses (CourseID, CourseName, ProfessorID, Credits) VALUES 
(101, 'Data Structures', 1, 4),
(102, 'Algorithms', 2, 4),
(103, 'Quantum Mechanics', 3, 3),
(104, 'Organic Chemistry', 4, 3),
(105, 'Artificial Intelligence', NULL, 4);

-- Populate Enrolments
INSERT INTO Enrolments (EnrolmentID, StudentID, CourseID, EnrolmentDate, Grade) VALUES 
(1, 501, 101, '2024-01-10', 'A'),
(2, 502, 101, '2024-01-11', 'B'),
(3, 501, 102, '2024-01-15', 'A'),
(4, 503, 103, '2024-01-20', 'C'),
(5, 504, 104, '2024-02-01', NULL),
(6, 502, 102, '2024-02-05', 'B');

-- Populate StudentWorkshops
INSERT INTO StudentWorkshops (WorkshopID, StudentID, WorkshopName, AttendedDate) VALUES 
(1001, 501, 'Git & GitHub Basics', '2024-01-25'),
(1002, 505, 'Resume Building', '2024-02-10'),
(1003, 502, 'Python for Data Science', '2024-02-15');


-- ============================================================================
-- TASKS & ANSWERS
-- ============================================================================

/*
-------------------------------------------------------------------------------
TASK 11 (Basic Selection & Filtering)
-------------------------------------------------------------------------------
Question:
Write a query to retrieve all 4-credit courses from the 'Courses' table. 
Display CourseID, CourseName, and Credits, ordered by CourseName alphabetically.
*/

-- SOLUTION:



/*
-------------------------------------------------------------------------------
TASK 12 (Aggregations & Grouping)
-------------------------------------------------------------------------------
Question:
Write a query to aggregate the total number of enrolments per CourseID from 
the 'Enrolments' table. Display CourseID and TotalEnrolments, but only show 
courses that have 2 or more student enrolments.
*/

-- SOLUTION:


/*
-------------------------------------------------------------------------------
TASK 13 (Multi-Table Joins & Subqueries)
-------------------------------------------------------------------------------
Question:
Write a query using a LEFT JOIN to display all Courses along with the 
assigned ProfessorName. Include courses that currently do not have a professor 
assigned (display NULL or 'Unassigned' using ISNULL/COALESCE).
*/

-- SOLUTION:



/*
-------------------------------------------------------------------------------
TASK 14 (Window Functions & CTEs)
-------------------------------------------------------------------------------
Question:
Using a CTE and the ROW_NUMBER() window function, write a query to find the 
earliest course enrolment (based on EnrolmentDate) for each StudentID. 
Display StudentID, CourseID, and EnrolmentDate.
*/

-- SOLUTION:



/*
-------------------------------------------------------------------------------
TASK 15 (Built-in Functions & Set Operations)
-------------------------------------------------------------------------------
Question:
Write a query using EXCEPT to find all StudentIDs present in 'StudentWorkshops' 
that are NOT currently enrolled in any courses in the 'Enrolments' table.
*/

-- SOLUTION:

