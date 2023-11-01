-- Data Bootcamp Playlist with Alex The Analyst 

CREATE TABLE EmployeeDemographics
(EmployeeID int,
FirstName varchar(50),
LastName varchar(50),
Age int,
Gender varchar(50)
)

CREATE TABLE EmployeeSalary
(EmployeeID int,
JobTitle varchar(50),
Salary int)

CREATE TABLE WareHouseEmployeeDemographics
(EmployeeID int,
FirstName varchar(50),
LastName varchar(50),
Age int,
Gender varchar(50)
)

SELECT *
FROM EmployeeSalary

INSERT INTO EmployeeDemographics VALUES
(1001, 'Jim', 'Halpert', 30, 'Male'),
(1002, 'Pam', 'Beasley', 30, 'Female'),
(1003, 'Dwight', 'Schrute', 29, 'Male'),
(1004, 'Angelo', 'Martin', 31, 'Female'),
(1005, 'Toby', 'Flenderson', 32, 'Female'),
(1006, 'Michael', 'Scott', 35, 'Male'),
(1007, 'Meredith', 'Palmer', 32, 'Female'),
(1008, 'Stanley', 'Hudson', 38, 'Male'),
(1009, 'Kevin,', 'Malone', 31, 'Male')

INSERT INTO EmployeeSalary VALUES
(1001, 'Salesman', 45000),
(1002, 'Receptionist', 36000),
(1003, 'Salesman', 63000),
(1004, 'Accountant', 47000),
(1005, 'HR', 50000),
(1006, 'Reginal Manager', 65000),
(1007, 'Supplier Relations', 41000),
(1008, 'Salesman', 48000),
(1009, 'Accountant', 42000)

INSERT INTO WareHouseEmployeeDemographics VALUES
(1011, 'Ryan', 'Howard', 26, 'Male'),
(1013, 'Darryl', 'Philbin', NULL, 'Male'),
(1050, 'Ray', 'Anderison', 31, 'Male'),
(1052, 'Val', 'Johnson', 31, 'Female')

/* 
Select Statement
*, TOP, DISTINCT, COUNT, AS, MAX, MIN, AVG
*/

SELECT COUNT(LastName) AS LastNameCount
FROM EmployeeDemographics

SELECT MAX(Salary) AS MaxSalary
FROM EmployeeSalary

/*
Where Statement
=, <>, <, >, AND, OR, LIKE, NULL, NOT NULL, IN
*/

SELECT *
FROM EmployeeDemographics
WHERE FirstName <> 'JIM' OR Gender = 'Male'

-- LIKE tends to be used with 'character': LastName starts with 'S'
-- % is a wild card
SELECT *
FROM EmployeeDemographics
WHERE LastName LIKE 'S%'

-- IN is like = statement with multiple things
SELECT *
FROM EmployeeDemographics
WHERE FirstName IN ('Jim', 'Michael')

/*
GROUP BY, ORDER BY - DESC & ASC (Default)
*/
SELECT *
FROM EmployeeDemographics
ORDER BY Age DESC, Gender DESC

-- Same as
SELECT *
FROM EmployeeDemographics
ORDER BY 4 DESC, 5 DESC

/*
INNER JOINS, FULL/LEFT/RIGHT OUTER JOINS
*/

SELECT *
FROM EmployeeDemographics
INNER JOIN EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
WHERE FirstName <> 'Michael'
ORDER BY Salary DESC

SELECT JobTitle, AVG(Salary) AS AverageSalary
FROM EmployeeDemographics
INNER JOIN EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
WHERE JobTitle = 'Salesman'
GROUP BY JobTitle

/*
UNION, UNION ALL (Will include duplicate)

Can select all data from both tables and put them into one table where all data in each column.
Make sure that the data you select is the same/ have the same collumns.
*/

SELECT *
FROM EmployeeDemographics
UNION
SELECT * 
FROM WareHouseEmployeeDemographics

/*
Case Statement
*/

SELECT FirstName, LastName, Salary,
CASE
	WHEN JobTitle = 'Salesman' THEN Salary + (Salary * .05)
	WHEN JobTitle = 'HR' THEN Salary + (Salary * .03)
	WHEN JobTitle = 'Accountant' THEN Salary + (Salary * .03)
	ELSE Salary + (Salary * .02)
END AS SalaryAfterRaise
FROM EmployeeDemographics
JOIN EmployeeSalary
ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

/* 
Having Clause - Have to go right after 'GROUP BY' Statement and before 'ORDER BY' Statement
*/
SELECT JobTitle, AVG(Salary)
FROM EmployeeDemographics
JOIN EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
GROUP BY JobTitle
HAVING AVG(Salary) > 45000
ORDER BY AVG(Salary)

/*
Updating/Deleting Date

INSERT = creating a new data
UPDATE = amend the pre-existing data
DELETE = specify what raws you would like to delete **CANNOT BE REVERSED!!

Use 'SET' & 'WHERE' to specify what column you would like to insert into. 
*/
SELECT *
FROM EmployeeDemographics

UPDATE EmployeeDemographics
SET EmployeeID = 1010, Age = 30, Gender = 'Male'
WHERE FirstName = 'Angelo' AND LastName = 'Martin'

DELETE FROM EmployeeDemographics
WHERE EmployeeID = 1010

-- Use SELECT * to see what you would delete first to see if you really need to delete it. 
SELECT *
FROM EmployeeDemographics
WHERE EmployeeID = 1010

/*
Alising - to make the code more clean and easier to read 
It is helpful to use it for the name of the table as you do not have to refer the full table's name.
*/
SELECT FirstName + ' ' + LastName AS FullName
FROM EmployeeDemographics

SELECT Demo.EmployeeID, Sal.Salary
FROM EmployeeDemographics AS Demo
JOIN EmployeeSalary AS Sal
	ON Demo.EmployeeID = Sal.EmployeeID

/*
Partition By
Often combine with GROUP BY 

GROUP BY - reducing the number of rows and rolling the column into a group
PARTITION BY - divind into a partition function and calulate it. Does not reduce the number of rows 
*/
SELECT FirstName, LastName, Gender, Salary,
	COUNT(Gender) OVER (PARTITION BY Gender) AS TotalGender
FROM EmployeeDemographics
JOIN EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

/*
CTEs - use to manipulate subqueries data (temporary). 
The CTE is not saved, so you have to run the whole thing when you run the code. 
Use WITH statement
*/

WITH CTE_Employee as
(SELECT FirstName, LastName, Gender, Salary,
	COUNT(Gender) OVER (PARTITION BY Gender) AS TotalGender,
	AVG(Salary) OVER (PARTITION BY Salary) AS AvgSalary
FROM EmployeeDemographics emp
JOIN EmployeeSalary sal
	ON emp.EmployeeID = sal.EmployeeID
WHERE Salary > '45000'
)
SELECT FirstName, AvgSalary
FROM CTE_Employee

/*
Temp Tables

** Helpful when insert a table into another table. 
*/

CREATE TABLE #temp_Employee
(EmployeeID int,
JobTitle varchar(100),
Salary int
)

SELECT *
FROM #temp_Employee

INSERT INTO #temp_Employee VALUES (
'1001', 'HR', '45000'
)
INSERT INTO #temp_Employee
SELECT *
FROM EmployeeSalary

DROP TABLE IF EXISTS #Temp_Employee2
CREATE TABLE #Temp_Employee2 
(JobTitle varchar(100),
EmployeePerJob int,
AvgAge int,
AvgSalary int)

INSERT INTO #Temp_Employee2
SELECT JobTitle, COUNT(JobTitle), AVG(Age), AVG(Salary)
FROM EmployeeDemographics emp
JOIN EmployeeSalary sal
	ON emp.EmployeeID = sal.EmployeeID
GROUP BY JobTitle

SELECT *
FROM #Temp_Employee2

-- If you have to run the temp table over and over, it is better to add 'DROP TABLE IF EXISTS' before the query.
-- Otherwise, you will come acrooss the error as the temp table might already be stored somewhere. 

/*

String Functions - TRIM, LTRIM, RTRIM, REPLACE, SUBSTRING, UPPER, LOWER
Use for the cleaning process.
*/
--Drop Table EmployeeErrors;


CREATE TABLE EmployeeErrors (
EmployeeID varchar(50)
,FirstName varchar(50)
,LastName varchar(50)
)

Insert into EmployeeErrors Values 
('1001  ', 'Jimbo', 'Halbert')
,('  1002', 'Pamela', 'Beasely')
,('1005', 'TOby', 'Flenderson - Fired')

Select *
From EmployeeErrors

-- use TRIM, LTRIM, RTRIM to get rid off all space. 
SELECT EmployeeID, TRIM(EmployeeID) AS IDTRIM
FROM EmployeeErrors

SELECT EmployeeID, LTRIM(EmployeeID) AS IDTRIM
FROM EmployeeErrors

SELECT EmployeeID, RTRIM(EmployeeID) AS IDTRIM
FROM EmployeeErrors

-- use REPLACE
SELECT LastName, REPLACE(LastName, '- Fired', ' ') AS LastNameFixed
FROM EmployeeErrors

-- use SUBSTRING
-- select the first 3 letters of the first name. 
SELECT SUBSTRING(FirstName,1,3) AS NickName
FROM EmployeeErrors

-- Use to match the name of columns when joinging tables as the names can be stored different like ALEX and ALEXANDER.
SELECT SUBSTRING(err.FirstName,1,3), SUBSTRING(dem.FirstName,1,3)
FROM EmployeeErrors err
JOIN EmployeeDemographics dem
	ON SUBSTRING(err.FirstName,1,3) = SUBSTRING(dem.FirstName,1,3)

-- use UPPER, LOWER
SELECT FirstName, UPPER(FirstName), LOWER(FirstName)
FROM EmployeeErrors

/*
Stored Procedures: a group of statements that have been stored tgt in the database.
Can be used by different userers who us the same network. Can also be modified.
Use CREATE PROCEDURE statement
To reduce network traffic and increase the proformance. 
*/
CREATE PROCEDURE TEST
AS
SELECT * 
FROM EmployeeDemographics

-- To use a procedure, use Execute statement
EXEC TEST

CREATE PROCEDURE Temp_Employee
AS
CREATE TABLE #Temp_Employee2 
(JobTitle varchar(100),
EmployeePerJob int,
AvgAge int,
AvgSalary int)

INSERT INTO #Temp_Employee2
SELECT JobTitle, COUNT(JobTitle), AVG(Age), AVG(Salary)
FROM EmployeeDemographics emp
JOIN EmployeeSalary sal
	ON emp.EmployeeID = sal.EmployeeID
GROUP BY JobTitle

SELECT *
FROM #Temp_Employee2

EXEC Temp_Employee

/*
Subqueries in the SELECT, FROM, and WHERE statement
*/
-- Subquery winith SELECT
SELECT EmployeeID, Salary, (SELECT AVG(Salary) FROM EmployeeSalary) AS AverageSalary,
	(SELECT MAX(Salary) FROM EmployeeSalary) AS MaxSalary,
	(SELECT MIN(Salary) FROM EmployeeSalary) AS MinSalary 
FROM EmployeeSalary

-- Can use with PARTITION BY as well
SELECT EmployeeID, Salary, AVG(Salary) OVER () AS AllAvgSalary
FROM EmployeeSalary

-- Subquery in FROM
SELECT atable.EmployeeID, AllAvgSalary
FROM (SELECT EmployeeID, Salary, AVG(Salary) OVER () AS AllAvgSalary
	FROM EmployeeSalary) AS atable

-- Subquery in WHERE
-- Can only pick one column in a subquery
SELECT EmployeeID, JobTitle, Salary
FROM EmployeeSalary
WHERE EmployeeID IN (
		SELECT EmployeeID	
		FROM EmployeeDemographics
		WHERE Age > 30)
