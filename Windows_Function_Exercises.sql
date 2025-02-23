CREATE TABLE VendorData (
GroupID INT,
Year INT,
VendorID INT,
FirstName NVARCHAR(50),
LastName NVARCHAR(50),
Job NVARCHAR(50),
ExternalID INT,
Region NVARCHAR(50)
);
INSERT INTO VendorData (GroupID, Year, VendorID, FirstName, LastName, Job, ExternalID, Region)
VALUES
(35, 2018, 102, 'Daniel', 'Knolle', 'Manager', 39765, 'West'),
(35, 2018, 1988, 'Arnold', 'Sully', 'Manager', 48507, 'West'),
(35, 2018, 1988, 'Arnold', 'Sully', 'Manager', 48507, 'East'),
(36, 2018, 102, 'Daniel', 'Knolle', 'Manager', 8219, 'West'),
(36, 2018, 1988, 'Arnold', 'Sully', 'Manager', 48507, 'West'),
(39, 2018, 102, 'Daniel', 'Knolle', 'Manager', 8219, 'West'),
(39, 2018, 102, 'Daniel', 'Knolle', 'Manager', 39765, 'West'),
(39, 2018, 650, 'Lisa', 'Roberts', 'Manager', 1860, 'West'),
(39, 2018, 650, 'Lisa', 'Roberts', 'Manager', 5397, 'Central'),
(39, 2018, 1988, 'Arnold', 'Sully', 'Manager', 48507, 'West'),
(39, 2018, 12, 'Mary', 'Dial', 'Manager', 1860, 'East'),
(40, 2019, 102, 'Daniel', 'Knolle', 'Manager', 8219, 'East'),
(40, 2019, 102, 'Daniel', 'Knolle', 'Manager', 39765, 'West'),
(40, 2019, 650, 'Lisa', 'Roberts', 'Manager', 1860, 'West'),
(40, 2019, 1988, 'Arnold', 'Sully', 'Manager', 39765, 'West'),
(40, 2019, 1988, 'Arnold', 'Sully', 'Manager', 48507, 'West'),
(5, 2012, 478, 'Dennis', 'S', 'Contractor', 24122, 'North'),
(6, 2012, 478, 'Dennis', 'S', 'Contractor', 10272, 'North'),
(6, 2012, 478, 'Larry', 'Weis', 'Contractor', 4219, 'North'),
(6, 2012, 478, 'Larry', 'Weis', 'Contractor', 10272, 'North'),
(27, 2009, 12, 'Mary', 'Dial', 'Manager', 1860, 'East');

CREATE TABLE VendorGroupData (
GroupID INT,
CompanyName VARCHAR(255),
VendorCount INT
);
INSERT INTO VendorGroupData (GroupID, CompanyName, VendorCount) VALUES
(27, 'Machinx', 1),
(35, 'Shipping&Co.', 3),
(36, 'Johnson and Sons', 2),
(40, 'News Corp.', 6),
(40, 'FireConsulting', 5),
(5, 'WaterBus Enterprise', 1),
(6, 'Alloy LLC', 3);

--Q.1)Determine the distribution of vendors across different regions for each year. The output should display the Year, Region, and the number of 
--unique VendorID's in that region for that year. Additionally, your query should append a column that shows the percentage change in the number of 
--unique VendorID's compared to the previous year for the same region. The format should be "X.00%". If there's no data for the previous year, 
--this column should display "N/A".The result should be ordered by Year in ascending order, then by the number of unique VendorID's in descending order, 
--and finally by Region in alphabetical order .The expected columns in the output are: Year, Region, UniqueVendors, and PercentageChangeFromLastYear.

with cte as ( 
select Year, Region, count(distinct vendorID) as UniqueVendors 
from VendorData 
GROUP BY YEAR, REGION)

select Year, Region , UniqueVendors , 
CASE WHEN LAG(UniqueVendors) over (partition by Region order by year) is NULL then 'N/A' ELSE
CAST(
ROUND(
(CAST(UniqueVendors AS FLOAT) - CAST(LAG(UniqueVendors) over (partition by region order by year) as FLOAT)) *100.00 / 
LAG(UniqueVendors) over (partition by region order by year),2) as VARCHAR(10)) + '%' END AS PercentageChangeFromLastYear
FROM CTE
order by YEAR,
UniqueVendors DESC,
REGION ASC;

--Q.2)How to compute the average score for each student (and have the average shown as a separate column)?
CREATE TABLE students (
    student_id INT,
    subject VARCHAR(20),
    score INT
);

INSERT INTO students (student_id, subject, score) VALUES
(1, 'Math', 85),
(1, 'English', 92),
(1, 'Science', 87),
(2, 'Math', 91),
(2, 'English', 88),
(2, 'Science', 93),
(3, 'Math', 78),
(3, 'English', 85),
(3, 'Science', 90),
(4, 'Math', 92),
(4, 'English', 86),
(4, 'Science', 89),
(5, 'Math', 90),
(5, 'English', 88),
(5, 'Science', 85),
(6, 'Math', 93),
(6, 'English', 82),
(6, 'Science', 90);

SELECT * FROM STUDENTS;

SELECT STUDENT_ID , SUBJECT,ROUND(AVG(cast(SCORE as float)) OVER (PARTITION BY STUDENT_ID ORDER BY STUDENT_ID),2) * 1.0 AS AVG_SCORE
FROM STUDENTS;

--Q.3)How to rank the students in descending order of their Total Score?. Where, Total score is the sum of scores in all three subjects ?

with cte as (Select *, round(avg(cast(score as float)) over (partition by student_id order by student_id),2) *1.0 as avg_score,
sum(score) over (partition by student_id) as total_score
from students)

select * , rank() over (order by total_score desc) as rn 
from cte
order by rn;

--Q.4)Represent a Table that ranks students based on their total scores & scores in desc order
with cte as (Select *, round(avg(cast(score as float)) over (partition by student_id order by student_id),2) *1.0 as avg_score,
sum(score) over (partition by student_id) as total_score
from students)

select *, row_number() over (order by total_score desc ,score desc) as i_rank
from cte;

--Q.5)find the percentage diff increase in salaries of neighbours?
CREATE TABLE salaries (
    id INT,
    name VARCHAR(20),
    city VARCHAR(20),
    dept VARCHAR(20),
    salary FLOAT
);

INSERT INTO SALARIES (id, name, city, dept, salary) VALUES
(21, 'Dhanya', 'Chennai', 'hr', 75),
(22, 'Bob', 'London', 'hr', 71),
(31, 'Akira', 'Chennai', 'it', 89),
(32, 'Grace', 'Berlin', 'it', 60),
(33, 'Steven', 'London', 'it', 103),
(34, 'Ramesh', 'Chennai', 'it', 103),
(35, 'Frank', 'Berlin', 'it', 120),
(41, 'Cindy', 'Berlin', 'sales', 95),
(42, 'Yetunde', 'London', 'sales', 95),
(43, 'Alice', 'Berlin', 'sales', 100);

Select * from salaries;

--WAY-1
select id,name , city , dept , salary,
cast(
round(
((cast(salary - lag(salary) over (order by id asc) as float) / lag(salary) over (order by id))) *100.00 ,4) as varchar ) + '%'
as diff
from salaries;

--WAY-2
with cte as (
select *,
lag(salary) over ( order by id) as prev_sal
from salaries)

select *,  cast (round((cast((salary - prev_sal) as float) / prev_sal) * 100.00 , 2) as varchar) + '%' as diff
from cte;

--Q.6)How to compute the perc difference between the min and max values of salary in each department, 
--while keeping the entries ordered by salary? That is, you want to compute the 
--percentage difference between the first (min) and last (max) values in each department.


select *, max(salary) over (partition by dept ) as max_salary,
min(salary) over (partition by dept) as min_salary
from salaries;

--Q.7) How to find running sum 

select *, sum(salary) over (order by id) as run_sum
from salaries;

select *, sum(salary) over (order by id rows between unbounded preceding and current row) as run_sum
from salaries;

--Q.8) Show min_salary, max_salary , count for salaries Table & find the 2nd highest salary
--WAY-1
with cte as(
select *,
min(salary) over (partition by dept) as min_salary,
max(salary) over (partition by dept) as max_salary,
count(*) over (partition by dept) as count, 
dense_rank() over(partition by dept order by salary desc) as rn
from salaries)
select * from cte
where rn = 2;

--WAY-2
with cte as(
select *,
min(salary) over (partition by dept) as min_salary,
max(salary) over (partition by dept) as max_salary,
count(*) over (partition by dept) as count, 
rank() over(partition by dept order by salary desc) as rn
from salaries)
select * from cte
where rn = 2;

--Q.9) Find the difference b/w 2nd highest & minium salary
with cte as(
select *,
min(salary) over (partition by dept) as min_salary,
max(salary) over (partition by dept) as max_salary,
row_number() over(partition by dept order by salary desc) as rn
from salaries),

cte_2 as (
select e.id, e.name, e.city,e.dept,e.salary,e.min_salary , r.second_highest  
from cte e
left join 
(select dept, salary as second_highest from cte where rn = 2) r
on e.dept = r.dept)

select *, (second_highest - min_salary) as diff_min_second from cte_2;