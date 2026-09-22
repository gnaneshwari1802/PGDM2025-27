/* ============================================================================
   SQL SERVER PRACTICAL EXAMINATION
   Total Marks : 100          Duration : 3 Hours
   ============================================================================
   INSTRUCTIONS TO STUDENTS:
   1. Run the "ENVIRONMENT SETUP & DATASET" section first to create and 
      populate all tables before attempting any question.
   2. Write your answer directly below the "-- SOLUTION:" comment for each 
      question. Do not modify the question text.
   3. Every query must be executed and returning correct output to receive 
      marks. Marks are shown next to each Section and each Question.
   4. Each question tells you which table(s) to use — you do not need to 
      touch any other table for that question unless stated.
   
   ============================================================================
   MARKS DISTRIBUTION
   ----------------------------------------------------------------------------
   Section A - DDL & Constraints                 3 Questions x 4  = 12 Marks
   Section B - Filtering Fundamentals            6 Questions x 4  = 24 Marks
   Section C - Aggregation & Grouping            4 Questions x 5  = 20 Marks
   Section D - Joins                             4 Questions x 6  = 24 Marks
   Section E - Window Functions                  3 Questions x 6  = 18 Marks
   Section F - Built-in Functions & CASE         1 Question  x 2  =  2 Marks
   ----------------------------------------------------------------------------
   TOTAL                                        21 Questions        100 Marks
   ============================================================================
*/

/*
============================================================================
ABOUT THE DATASET
============================================================================
This exam is based on a Gym Management System with four related tables:

1. Trainers        - Gym trainers, their specialization, salary, and hire 
                      date. Includes a self-referencing column 
                      (SeniorTrainerID) showing which senior trainer each 
                      trainer reports to (some trainers have no senior).

2. MembershipPlans  - The plans offered by the gym (Basic, Standard, 
                      Premium, Student) along with duration and price.

3. Members          - Gym members, the plan they've subscribed to, the 
                      trainer assigned to them (if any), and their city. 
                      Some members have no recorded city, and some have 
                      no trainer assigned.

4. CheckIns         - A log of gym visits made by members, with the date 
                      and duration of each visit. A couple of members 
                      have no check-ins at all.

Note: Some data is intentionally incomplete (missing cities, unassigned 
trainers, members with zero visits) so that filtering, join, and NULL-
handling questions have realistic, meaningful results — not just 
theoretical ones.
============================================================================ */

-- ============================================================================
-- ENVIRONMENT SETUP & DATASET  (Do not modify — run this first)
-- ============================================================================

-- Trainers Table (includes a self-referencing column for mentorship hierarchy)
CREATE TABLE Trainers (
    TrainerID       INT PRIMARY KEY,
    TrainerName     VARCHAR(50) NOT NULL,
    Specialization  VARCHAR(50) NOT NULL,
    MonthlySalary   DECIMAL(10,2) NOT NULL CHECK (MonthlySalary >= 0),
    HireDate        DATE NOT NULL,
    SeniorTrainerID INT NULL,
    FOREIGN KEY (SeniorTrainerID) REFERENCES Trainers(TrainerID)
);

-- Membership Plans Table
CREATE TABLE MembershipPlans (
    PlanID          INT PRIMARY KEY,
    PlanName        VARCHAR(50) NOT NULL,
    DurationMonths  INT NOT NULL CHECK (DurationMonths > 0),
    Price           DECIMAL(10,2) NOT NULL CHECK (Price >= 0)
);

-- Members Table
CREATE TABLE Members (
    MemberID           INT PRIMARY KEY,
    MemberName         VARCHAR(50) NOT NULL,
    Email               VARCHAR(100) UNIQUE NOT NULL,
    City                VARCHAR(50) NULL,
    PlanID              INT NOT NULL,
    JoinDate            DATE NOT NULL DEFAULT GETDATE(),
    AssignedTrainerID   INT NULL,
    FOREIGN KEY (PlanID) REFERENCES MembershipPlans(PlanID),
    FOREIGN KEY (AssignedTrainerID) REFERENCES Trainers(TrainerID)
);

-- CheckIns Table (gym visit log)
CREATE TABLE CheckIns (
    CheckInID       INT PRIMARY KEY,
    MemberID        INT NOT NULL,
    CheckInDate     DATE NOT NULL,
    DurationMinutes INT NOT NULL CHECK (DurationMinutes > 0),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);


-- Populate Trainers (Note: 3001 and 3002 have NULL SeniorTrainerID = senior-most)
INSERT INTO Trainers (TrainerID, TrainerName, Specialization, MonthlySalary, HireDate, SeniorTrainerID) VALUES
(3001, 'Ramesh Kumar',   'Strength',    65000.00, '2018-04-10', NULL),
(3002, 'Anita Rao',      'Cardio',      62000.00, '2018-09-15', NULL),
(3003, 'Suresh Babu',    'Strength',    48000.00, '2020-01-20', 3001),
(3004, 'Divya Menon',    'Yoga',        45000.00, '2021-03-05', NULL),
(3005, 'Kiran Patel',    'Cardio',      41000.00, '2022-06-18', 3002),
(3006, 'Vikram Shah',    'CrossFit',    52000.00, '2021-11-01', 3001);

-- Populate Membership Plans
INSERT INTO MembershipPlans (PlanID, PlanName, DurationMonths, Price) VALUES
(1, 'Basic',    1,  1200.00),
(2, 'Standard', 6,  1800.00),
(3, 'Premium',  12, 3500.00),
(4, 'Student',  3,  900.00);

-- Populate Members (Note: some AssignedTrainerID and City are NULL intentionally)
INSERT INTO Members (MemberID, MemberName, Email, City, PlanID, JoinDate, AssignedTrainerID) VALUES
(101, 'Arjun Reddy',    'arjun.reddy@email.com',   'Hyderabad', 3, '2024-01-05', 3001),
(102, 'Meena Iyer',     'meena.iyer@email.com',    'Chennai',   2, '2024-01-12', 3002),
(103, 'Farhan Ali',     'farhan.ali@email.com',    'Hyderabad', 1, '2024-01-20', NULL),
(104, 'Ananya Das',     'ananya.das@email.com',    NULL,        3, '2024-02-02', 3004),
(105, 'Rohit Bansal',   'rohit.bansal@email.com',  'Bangalore', 2, '2024-02-10', 3005),
(106, 'Sandeep Nair',   'sandeep.nair@email.com',  'Chennai',   4, '2024-02-15', NULL),
(107, 'Priya Chandran', 'priya.chandran@email.com','Hyderabad', 3, '2024-03-01', 3001),
(108, 'Karthik Iyengar','karthik.i@email.com',     NULL,        1, '2024-03-08', 3006),
(109, 'Lavanya Rao',    'lavanya.rao@email.com',   'Bangalore', 2, '2024-03-15', 3005),
(110, 'Naveen Kumar',   'naveen.kumar@email.com',  'Chennai',   4, '2024-03-22', NULL);

-- Populate CheckIns (Note: Member 106 and 110 have NO check-ins at all)
INSERT INTO CheckIns (CheckInID, MemberID, CheckInDate, DurationMinutes) VALUES
(9001, 101, '2024-04-01', 45),
(9002, 101, '2024-04-03', 60),
(9003, 101, '2024-04-06', 30),
(9004, 102, '2024-04-01', 50),
(9005, 102, '2024-04-05', 20),
(9006, 103, '2024-04-02', 90),
(9007, 104, '2024-04-02', 40),
(9008, 104, '2024-04-08', 55),
(9009, 104, '2024-04-10', 15),
(9010, 105, '2024-04-03', 35),
(9011, 107, '2024-04-04', 65),
(9012, 107, '2024-04-09', 25),
(9013, 108, '2024-04-05', 70),
(9014, 109, '2024-04-06', 45),
(9015, 109, '2024-04-11', 45);



-- ============================================================================
-- SECTION A: DDL & CONSTRAINTS                                    [12 Marks]
-- ============================================================================

/*
-------------------------------------------------------------------------------
Q1. (4 Marks)
Tables to be used: None (you are creating a new table)

Write a CREATE TABLE statement for a new table named 'Equipment' with the 
following columns:
  - EquipmentID   : Integer, Primary Key
  - EquipmentName : Text up to 50 characters, cannot be NULL
  - Category      : Text up to 30 characters, cannot be NULL
  - PurchaseCost  : Decimal (10,2), must never be a negative value
  - WarrantyMonths: Integer, defaults to 12 if not specified
-------------------------------------------------------------------------------
*/
-- SOLUTION:
CREATE TABLE Equipment (
EquipmentID   INT PRIMARY KEY,
  EquipmentName VARCHAR(50) NOT NULL,
  Category     VARCHAR(30) NOT NULL,
  PurchaseCost  DECIMAL(10,2), CHECK (PurchaseCost > 0),
  WarrantyMonths INT DEFAULT(12));
/*
-------------------------------------------------------------------------------
Q2. (4 Marks)
Tables to be used: Members (referenced as a Foreign Key only — you are 
creating a new table named 'Payments')

Write a CREATE TABLE statement for a new table named 'Payments' with the 
following columns:
  - PaymentID     : Integer, Primary Key
  - MemberID      : Integer, cannot be NULL, must reference Members(MemberID) 
                     as a Foreign Key
  - PaymentDate   : Date, defaults to the current date if not specified
  - Amount        : Decimal (10,2), must always be greater than 0
  - PaymentStatus : Text up to 20 characters, defaults to 'Pending'
-------------------------------------------------------------------------------
*/
-- SOLUTION:

CREATE TABLE Payments (
PaymentID  INT PRIMARY KEY,
  MemberID  INT NOT NULL FOREIGN KEY (MemberID) REFERENCES Members(MemberID), 

  PaymentDate  DATE DEFAULT(GETDATE()),
  Amount  DECIMAL(10,2) , CHECK (Amount >= 0),
  PaymentStatus VARCHAR(20) DEFAULT('Pending'));
/*
-------------------------------------------------------------------------------
Q3. (4 Marks)
Tables to be used: None (conceptual question — no query required)

In one or two lines, explain the difference between DELETE, TRUNCATE, and 
DROP  ?
-------------------------------------------------------------------------------
*/
-- ANSWER (explanation):

/* DELETE    

it removes only the specific rows from the table in which it is specified

TRUNCATE     

it removes all the rows from the table keeping the table structure

DROP

it removes all the rows from the table along with the table structure

*/

-- ============================================================================
-- SECTION B: FILTERING FUNDAMENTALS                               [24 Marks]
-- ============================================================================

/*
-------------------------------------------------------------------------------
Q4. (4 Marks)
Tables to be used: Members

Write a query to retrieve all members who live in either 'Hyderabad' or 
'Chennai' (use the IN operator). Display MemberName, City, and JoinDate, 
ordered by JoinDate ascending.
-------------------------------------------------------------------------------
*/
-- SOLUTION:

SELECT MemberName,City,JoinDate FROM Members WHERE City IN ('Hyderabad',
'Chennai' ) ORDER BY JoinDate ASC;


/*
-------------------------------------------------------------------------------
Q5. (4 Marks)
Tables to be used: Trainers

Write a query to retrieve all trainers whose MonthlySalary is BETWEEN 
45000 and 65000. Display TrainerName, Specialization, and MonthlySalary, 
ordered by MonthlySalary descending.
-------------------------------------------------------------------------------
*/
-- SOLUTION:

SELECT TrainerName, Specialization, MonthlySalary FROM Trainers 
WHERE MonthlySalary BETWEEN 45000 AND 65000
ORDER BY MonthlySalary DESC;

/*
-------------------------------------------------------------------------------
Q6. (4 Marks)
Tables to be used: Members

Write a query using the LIKE operator to find all members whose MemberName 
contains the substring 'an' anywhere in the name. Display MemberName and 
Email.
-------------------------------------------------------------------------------
*/
-- SOLUTION:

SELECT MemberName,Email FROM Members WHERE MemberName LIKE '%an%';

/*
-------------------------------------------------------------------------------
Q7. (4 Marks)
Tables to be used: Members

Write a query to find all members whose City has not been recorded 
(i.e. is missing). Display MemberID, MemberName, and Email.
-------------------------------------------------------------------------------
*/
-- SOLUTION:

SELECT MemberID, MemberName, Email FROM Members WHERE City IS NULL;

/*
-------------------------------------------------------------------------------
Q8. (4 Marks) -- DEBUG / FIX THE QUERY
Tables to be used: Members

A developer wrote the following query to find members whose City has 
not been recorded. It runs without error but always returns ZERO rows, even 
though you already found matching rows.

    SELECT MemberID, MemberName
    FROM Members
    WHERE City = NULL;

(a) In one line, explain WHY this query is wrong.
(b) Rewrite the query correctly.
-------------------------------------------------------------------------------
*/
-- ANSWER (a):

/*
Its because the NULL values are the values which are neither zero '0' nor any definitive value (i.e missing value ) 
so it dosent have a data type as its an empty value it cannot be comprehended , used and understood by the sql like any other data type
as it dosent have any value so it cannot be equated with '=' which is used to give definitive values to the variable.
So it is represented by giving any variable with IS key word instead of '=' operator. 
*/

-- SOLUTION (b):
  SELECT MemberID, MemberName
    FROM Members
    WHERE City IS NULL;


/*
-------------------------------------------------------------------------------
Q9. (4 Marks)
Tables to be used: CheckIns

Write a query to display the TOP 5 most recent check-ins from the CheckIns 
table. Display MemberID, CheckInDate, and DurationMinutes, ordered by 
CheckInDate descending, and DurationMinutes descending as a tiebreaker.
-------------------------------------------------------------------------------
*/
-- SOLUTION:

SELECT TOP 5 MemberID , CheckInDate ,DurationMinutes FROM CheckIns
ORDER BY CheckInDate DESC, DurationMinutes DESC;
 


-- ============================================================================
-- SECTION C: AGGREGATION & GROUPING                                [20 Marks]
-- ============================================================================

/*
-------------------------------------------------------------------------------
Q10. (5 Marks)
Tables to be used: Members

Write a query to count the number of members per City. Display City and 
MemberCount, but only include cities that have 2 or more members. Ignore 
members with no recorded City. Sort by MemberCount descending.
-------------------------------------------------------------------------------
*/
-- SOLUTION:
WITH cter AS
(
SELECT City , COUNT(MemberID) AS MemberCount  FROM Members 

GROUP BY City 
HAVING COUNT(MemberID)>=2

)

SELECT * FROM cter WHERE City IS NOT NULL 
ORDER BY MemberCount DESC, City DESC;



/*
-------------------------------------------------------------------------------
Q11. (5 Marks)
Tables to be used: CheckIns

Write a query to calculate, per MemberID, the total check-in duration (as 
TotalDuration), the average duration (as AvgDuration), and the number of 
check-ins (as VisitCount) from the CheckIns table. Only include members with 
MORE THAN 2 check-ins.
-------------------------------------------------------------------------------
CheckInID, MemberID, CheckInDate, DurationMinutes*/
-- SOLUTION:

WITH cte2 AS(
SELECT MemberID, SUM(DurationMinutes) AS TotalDuration  ,AVG(DurationMinutes) AS AvgDuration, COUNT(CheckInID) AS VisitCount  
FROM CheckIns
GROUP BY MemberID
HAVING COUNT(CheckInID)>2
)

SELECT * FROM cte2 WHERE VisitCount>2 ;


/*
-------------------------------------------------------------------------------
Q12. (5 Marks)
Tables to be used: Members, MembershipPlans

Write a query, joining Members with MembershipPlans, to display each 
PlanName along with the total number of members subscribed to it (as 
MemberCount) and the total revenue collected (as TotalRevenue = number of 
members x plan Price). Sort by TotalRevenue descending.
-------------------------------------------------------------------------------
*/
-- SOLUTION:

SELECT p.PlanName, COUNT(m.MemberID) AS MemberCount, SUM(p.Price) AS TotalRevenue
FROM Members AS m JOIN MembershipPlans AS p ON m.PlanID=p.PlanID
GROUP BY p.PlanName
ORDER BY TotalRevenue DESC;


/*
-------------------------------------------------------------------------------
Q13. (5 Marks)
Tables to be used: Members, CheckIns

Write a query to find the total check-in duration handled per assigned 
trainer (join Members to CheckIns via MemberID, then group by the member's 
AssignedTrainerID). Display AssignedTrainerID and TotalDurationHandled. Only 
show trainers who have handled at least one check-in. Sort descending by 
TotalDurationHandled.
-------------------------------------------------------------------------------
*/
-- SOLUTION:
SELECT m.AssignedTrainerID , SUM(c.DurationMinutes) AS TotalDurationHandled
FROM Members AS m JOIN CheckINS AS c
ON m.MemberID=c.MemberID
WHERE c.CheckInID>=1 AND m.AssignedTrainerID IS NOT NULL
GROUP BY m.AssignedTrainerID
ORDER BY TotalDurationHandled DESC;


-- ============================================================================
-- SECTION D: JOINS                                                 [24 Marks]
-- ============================================================================

/*
-------------------------------------------------------------------------------
Q14. (6 Marks) -- INNER JOIN
Tables to be used: Members, MembershipPlans

Write a query using INNER JOIN to display MemberName, PlanName, and Price 
for every member, showing only members who have a valid, matching plan.
-------------------------------------------------------------------------------
*/
-- SOLUTION:
SELECT m.MemberName, p.PlanName, p.Price
FROM Members AS m INNER JOIN MembershipPlans AS p ON m.PlanID=p.PlanID;

/*
-------------------------------------------------------------------------------
Q15. (6 Marks) -- LEFT JOIN
Tables to be used: Members, Trainers

Write a query using LEFT JOIN to display every member's MemberName along 
with their assigned trainer's TrainerName. Members who do NOT have an 
assigned trainer must still appear in the results (with NULL for 
TrainerName).
-------------------------------------------------------------------------------
*/
-- SOLUTION:
SELECT m.MemberName, t.TrainerName
FROM Members AS m LEFT JOIN Trainers AS t ON m.AssignedTrainerID=t.TrainerID

/*
-------------------------------------------------------------------------------
Q16. (6 Marks) -- RIGHT JOIN
Tables to be used: Trainers, Members

Write a query using RIGHT JOIN to display every trainer's TrainerName along 
with the names of members assigned to them. Trainers who currently have NO 
members assigned must still appear in the results (with NULL for 
MemberName).
-------------------------------------------------------------------------------
*/
-- SOLUTION:
SELECT t.TrainerName, m.MemberName
FROM Members AS m RIGHT JOIN Trainers AS t ON m.AssignedTrainerID=t.TrainerID;

/*
-------------------------------------------------------------------------------
Q17. (6 Marks) -- SELF JOIN
Tables to be used: Trainers

Write a self-join query on the Trainers table to display each trainer's 
TrainerName alongside their senior trainer's name (as SeniorTrainerName). 
Trainers who have no senior assigned should show NULL for SeniorTrainerName.
-------------------------------------------------------------------------------
*/
-- SOLUTION:
SELECT t2.TrainerName AS SeniorTrainerName, t1.TrainerName
FROM Trainers as t1 RIGHT JOIN Trainers as t2 ON t1.TrainerID=t2.SeniorTrainerID;


-- ============================================================================
-- SECTION E: WINDOW FUNCTIONS                                      [18 Marks]
-- ============================================================================

/*
-------------------------------------------------------------------------------
Q18. (6 Marks)
Tables to be used: CheckIns

Using ROW_NUMBER(), write a query to number each member's check-ins in the 
order they occurred (partition by MemberID, order by CheckInDate ascending). 
Display MemberID, CheckInDate, DurationMinutes, and VisitNumber.
-------------------------------------------------------------------------------
*/
-- SOLUTION:

SELECT MemberID, CheckInDate, DurationMinutes,
ROW_NUMBER() OVER(
PARTITION BY MemberID
ORDER BY CheckINDate
) AS VisitNumber
FROM CheckIns;

/*
-------------------------------------------------------------------------------
Q19. (6 Marks)
Tables to be used: Trainers

Part 1 (4 Marks) — Write a query using both RANK() and DENSE_RANK() to rank 
trainers by MonthlySalary (descending) within each Specialization. Display 
Specialization, TrainerName, MonthlySalary, SalaryRank (RANK), and 
SalaryDenseRank (DENSE_RANK).

Part 2 (2 Marks) — Written answer, no query required. In this dataset, no two 
trainers within the same Specialization share the same salary, so SalaryRank 
and SalaryDenseRank will be identical for every row here. Suppose instead two 
trainers in the same Specialization were tied for the HIGHEST salary in their 
group. In 2-3 lines, explain what SalaryRank and SalaryDenseRank would show 
for (i) the two tied trainers, and (ii) the trainer with the next-highest 
salary in that same group.
-------------------------------------------------------------------------------
*/
-- Solution Part 1
SELECT Specialization, TrainerName, MonthlySalary,
RANK() OVER(
PARTITION BY Specialization
ORDER BY MonthlySalary DESC
) AS SalaryRank,
DENSE_RANK() OVER(
PARTITION BY Specialization
ORDER BY MonthlySalary DESC
) AS SalaryDenseRank

FROM Trainers;

-- Solution Part 2
/*
In this dataset, no two 
trainers within the same Specialization share the same salary, so SalaryRank 
and SalaryDenseRank will be identical for every row here. Suppose instead two 
trainers in the same Specialization were tied for the HIGHEST salary in their 
group. In 2-3 lines, explain what SalaryRank and SalaryDenseRank would show 
for (i) the two tied trainers
In this case there will be rank differences for the trainers in the salaryrank i.e with the rank() function there will be gaps/missing/un sequential in the ranks
there will be rank differences for the trainers in the salarydenserank i.e with the dense rank() function there will be no gaps/no missing/sequential in the ranks, and 
(ii) the trainer with the next-highest 
In this case there will be rank differences for the trainers in the salaryrank i.e with the rank() function there will be gaps/missing/un sequential in the ranks
there will be rank differences for the trainers in the salarydenserank i.e with the dense rank() function there will be no gaps/no missing/sequential in the ranks, and 
salary in that same group.

*/
/*
-------------------------------------------------------------------------------
Q20. (6 Marks)
Tables to be used: CheckIns

Write a query using SUM() OVER (PARTITION BY ... ORDER BY ...) to calculate 
a running total of DurationMinutes for each member, ordered by CheckInDate. 
Display MemberID, CheckInDate, DurationMinutes, and RunningTotalDuration.
CheckInID, MemberID, CheckInDate, DurationMinutes
-------------------------------------------------------------------------------
*/
-- SOLUTION:
SELECT MemberID, CheckInDate, DurationMinutes,
SUM(DurationMinutes) OVER (PARTITION BY MemberID ORDER BY CheckInDate ) AS RunningTotalDuration
FROM CheckIns;

-- ============================================================================
-- SECTION F: BUILT-IN FUNCTIONS & CASE                              [2 Marks]
-- ============================================================================

/*
-------------------------------------------------------------------------------
Q21. (2 Marks)
Tables to be used: Members, MembershipPlans

Write a query using a CASE expression to categorize each member's plan by 
Price: 'Premium' if Price >= 3000, 'Standard' if Price >= 1500, otherwise 
'Budget'. Display MemberName, PlanName, Price, and PriceCategory.
-------------------------------------------------------------------------------
*/
-- SOLUTION:

SELECT MemberName, PlanName, Price, 
CASE 
WHEN Price >= 3000 THEN 'Premium'
WHEN Price >= 1500 THEN 'Standard'
ELSE 'Budget'
END AS PriceCategory
FROM Members AS m JOIN MembershipPlans AS p
ON m.PlanID=p.PlanID;

-- ============================================================================
-- END OF QUESTION PAPER
-- ============================================================================