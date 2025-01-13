USE RENTAL;

SELECT * FROM DBO.car_rental_transactions;

--CREATED A NEW TABLE "RENTAL_COPY" WITH MODIFIED UNIX TIMESTAMP
SELECT *, DATEADD(SECOND,CREATED,'1970-01-01') AS DATE
INTO RENTAL_COPY
FROM DBO.car_rental_transactions;


select * from RENTAL_COPY;

--FILTERING THE DATA FROM 2024-10-01 TO 2024-10-31
SELECT * FROM RENTAL_COPY
WHERE DATE BETWEEN '2024-10-01' AND '2024-10-31';

--ALTERNATIVE WAY OF FILTERING LAST 30 DAYS DATA
SELECT * FROM RENTAL_COPY
WHERE DATE >= DATEADD(DAY,-30, GETDATE()) AND DATE < GETDATE();

SELECT * FROM RENTAL_COPY
WHERE DATE >= DATEADD(DAY,-30, GETDATE()) AND DATE < GETDATE()
order by DATE;

--Grouping the data week-wise
WITH WeeklyTransactions AS (
    SELECT *,
           DATEPART(WEEK, DATE) - DATEPART(WEEK, '2024-09-25') + 1 AS Week_Number,
           DATEADD(DAY, -1 * (DATEPART(WEEKDAY, DATE) - 1), DATE) AS Week_Start,
           DATEADD(DAY, 6 - (DATEPART(WEEKDAY, DATE) - 1), DATE) AS Week_End
    FROM RENTAL_COPY
    WHERE DATE >= '2024-09-25'
)

SELECT Week_Number,
       MIN(Week_Start) AS Week_Start_Date,
       MAX(Week_End) AS Week_End_Date,
       COUNT(*) AS Transaction_Count
FROM WeeklyTransactions
GROUP BY Week_Number
ORDER BY Week_Number;

--Average Transaction Amount Week-wise
WITH WeeklyTransactions AS (
    SELECT *,
           DATEPART(WEEK, DATE) - DATEPART(WEEK, '2024-09-25') + 1 AS Week_Number,
           DATEADD(DAY, -1 * (DATEPART(WEEKDAY, DATE) - 1), DATE) AS Week_Start,
           DATEADD(DAY, 6 - (DATEPART(WEEKDAY, DATE) - 1), DATE) AS Week_End
    FROM RENTAL_COPY
    WHERE DATE >= '2024-09-25'
)
SELECT WEEK_NUMBER, AVG(AMOUNT) AS AVERAGE_TRANSACTION_AMOUNT
FROM WeeklyTransactions
GROUP BY Week_Number
ORDER BY Week_Number;

--AVERAGE TRANSACTION IN DESCENDING ORDER
WITH WeeklyTransactions AS (
    SELECT *,
           DATEPART(WEEK, DATE) - DATEPART(WEEK, '2024-09-25') + 1 AS Week_Number,
           DATEADD(DAY, -1 * (DATEPART(WEEKDAY, DATE) - 1), DATE) AS Week_Start,
           DATEADD(DAY, 6 - (DATEPART(WEEKDAY, DATE) - 1), DATE) AS Week_End
    FROM RENTAL_COPY
    WHERE DATE >= '2024-09-25'
)
SELECT WEEK_NUMBER, AVG(AMOUNT) AS AVERAGE_TRANSACTION_AMOUNT
FROM WeeklyTransactions
GROUP BY Week_Number
ORDER BY AVERAGE_TRANSACTION_AMOUNT DESC;

--Average Transaction Amount VS Transaction Count
WITH WeeklyTransactions AS (
    SELECT *,
           DATEPART(WEEK, DATE) - DATEPART(WEEK, '2024-09-25') + 1 AS Week_Number,
           DATEADD(DAY, -1 * (DATEPART(WEEKDAY, DATE) - 1), DATE) AS Week_Start,
           DATEADD(DAY, 6 - (DATEPART(WEEKDAY, DATE) - 1), DATE) AS Week_End
    FROM RENTAL_COPY
    WHERE DATE >= '2024-09-25'
)
SELECT WEEK_NUMBER, AVG(AMOUNT) AS AVERAGE_TRANSACTION_AMOUNT, COUNT(*) AS TRANSACTION_COUNT
FROM WeeklyTransactions
GROUP BY Week_Number
ORDER BY AVERAGE_TRANSACTION_AMOUNT DESC;

--Transaction Count with start and end date of Week
WITH WeeklyTransactions AS (
    SELECT *,
           DATEPART(WEEK, DATE) - DATEPART(WEEK, '2024-09-25') + 1 AS Week_Number,
           DATEADD(DAY, -1 * (DATEPART(WEEKDAY, DATE) - 1), DATE) AS Week_Start,
           DATEADD(DAY, 6 - (DATEPART(WEEKDAY, DATE) - 1), DATE) AS Week_End
    FROM RENTAL_COPY
    WHERE DATE >= '2024-09-25'
)

SELECT Week_Number,
       MIN(Week_Start) AS Week_Start_Date,
       MAX(Week_End) AS Week_End_Date,
       COUNT(*) AS Transaction_Count
FROM WeeklyTransactions
GROUP BY Week_Number
ORDER BY Transaction_Count DESC;

--WEEK 2 HAS Maximum nos of Transactions 
--WEEK 3 & 5 have lesser nos of Transactions

--FILTERING AMOUNT, CUSTOMER_EARNING, STRIPE_FEE  & NET_AMOUNT FROM LAST 1 MONTH TRANSACTIONS
SELECT AMOUNT, (CUSTOMER_TRANSACTION) AS CUSTOMER_EARNING , MERCHANT_AMOUNT, (FEE) AS STRIPE_FEE , NET_AMOUNT
FROM RENTAL_COPY;


--ANALYZING THE DATA ON WEEKLY BASIS OF TOTAL AMOUNT OF TRANSACTION DONE, TOTAL AMOUNT EARNED BY CUSTOMER, TOTAL AMOUNT
--CHARGED BY STRIPE AND TOTAL PROFIT EARNED BY THE COMPANY
WITH WeeklyTransactions AS (
    SELECT *,
           DATEPART(WEEK, DATE) - DATEPART(WEEK, '2024-09-25') + 1 AS Week_Number,
           DATEADD(DAY, -1 * (DATEPART(WEEKDAY, DATE) - 1), DATE) AS Week_Start,
           DATEADD(DAY, 6 - (DATEPART(WEEKDAY, DATE) - 1), DATE) AS Week_End
    FROM RENTAL_COPY
    WHERE DATE >= '2024-09-25'
)
SELECT WEEK_NUMBER, 
MIN(WEEK_START) AS Week_Start_Date,
MAX(WEEK_END) AS Week_End_Date,
SUM(AMOUNT) as Total_Amount, 
SUM(CUSTOMER_TRANSACTION) as Total_Customer_Earning, 
SUM(FEE) as Total_Stripe_Fee, 
SUM(NET_AMOUNT) as Total_Profit
FROM WeeklyTransactions
GROUP BY Week_Number
ORDER BY Week_Number;

--Analyzing the Data on Weekly basis for Total Amount of Transactions done
WITH WeeklyTransactions AS (
    SELECT DATE,
           AMOUNT,
           DATEPART(WEEK, DATE) - DATEPART(WEEK, '2024-09-25') + 1 AS Week_Number,
           DATEADD(DAY, -1 * (DATEPART(WEEKDAY, DATE) - 1), DATE) AS Week_Start,
           DATEADD(DAY, 6 - (DATEPART(WEEKDAY, DATE) - 1), DATE) AS Week_End
    FROM RENTAL_COPY
    WHERE DATE >= '2024-09-25'
)
SELECT Week_Number, 
       MIN(Week_Start) AS Week_Start_Date,
       MAX(Week_End) AS Week_End_Date,
       SUM(AMOUNT) as Total_Amount
FROM WeeklyTransactions
GROUP BY Week_Number
ORDER BY Total_Amount DESC;

--ANALYZING THE DATA ON WEEKLY BASIS for Total_Amount VS Transaction_Count
WITH WeeklyTransactions AS (
    SELECT DATE,
           AMOUNT,
           DATEPART(WEEK, DATE) - DATEPART(WEEK, '2024-09-25') + 1 AS Week_Number,
           DATEADD(DAY, -1 * (DATEPART(WEEKDAY, DATE) - 1), DATE) AS Week_Start,
           DATEADD(DAY, 6 - (DATEPART(WEEKDAY, DATE) - 1), DATE) AS Week_End
    FROM RENTAL_COPY
    WHERE DATE >= '2024-09-25'
)
SELECT Week_Number, 
       MIN(Week_Start) AS Week_Start_Date,
       MAX(Week_End) AS Week_End_Date,
       SUM(AMOUNT) as Total_Amount,
	   COUNT(*) AS Transaction_Count
FROM WeeklyTransactions
GROUP BY Week_Number
ORDER BY Total_Amount DESC;

SELECT * FROM RENTAL_COPY;

----ANALYZING THE DATA ON WEEKLY BASIS for Total_Customer_Earning VS Transaction_Count
WITH WeeklyTransactions AS (
    SELECT DATE,
	       CUSTOMER_TRANSACTION,
           DATEPART(WEEK, DATE) - DATEPART(WEEK, '2024-09-25') + 1 AS Week_Number,
           DATEADD(DAY, -1 * (DATEPART(WEEKDAY, DATE) - 1), DATE) AS Week_Start,
           DATEADD(DAY, 6 - (DATEPART(WEEKDAY, DATE) - 1), DATE) AS Week_End
    FROM RENTAL_COPY
    WHERE DATE >= '2024-09-25'
)
SELECT WEEK_NUMBER, 
MIN(WEEK_START) AS Week_Start_Date,
MAX(WEEK_END) AS Week_End_Date, 
SUM(CUSTOMER_TRANSACTION) as Total_Customer_Earning,
COUNT(*) AS Transaction_Count
FROM WeeklyTransactions
GROUP BY Week_Number
ORDER BY Total_Customer_Earning DESC;

--ANALYZING THE DATA ON WEEKLY BASIS for Total_Stripe_Fee VS Transaction_Count
WITH WeeklyTransactions AS (
    SELECT DATE,
	       FEE,
           DATEPART(WEEK, DATE) - DATEPART(WEEK, '2024-09-25') + 1 AS Week_Number,
           DATEADD(DAY, -1 * (DATEPART(WEEKDAY, DATE) - 1), DATE) AS Week_Start,
           DATEADD(DAY, 6 - (DATEPART(WEEKDAY, DATE) - 1), DATE) AS Week_End
    FROM RENTAL_COPY
    WHERE DATE >= '2024-09-25'
)
SELECT WEEK_NUMBER, 
MIN(WEEK_START) AS Week_Start_Date,
MAX(WEEK_END) AS Week_End_Date,
SUM(FEE) as Total_Stripe_Fee,
COUNT(*) AS Transaction_Count
FROM WeeklyTransactions
GROUP BY Week_Number
ORDER BY Total_Stripe_Fee DESC;

--ANALYZING THE DATA ON WEEKLY BASIS for Total_Profit VS Transaction_Count
WITH WeeklyTransactions AS (
    SELECT DATE,
	       NET_AMOUNT,
           DATEPART(WEEK, DATE) - DATEPART(WEEK, '2024-09-25') + 1 AS Week_Number,
           DATEADD(DAY, -1 * (DATEPART(WEEKDAY, DATE) - 1), DATE) AS Week_Start,
           DATEADD(DAY, 6 - (DATEPART(WEEKDAY, DATE) - 1), DATE) AS Week_End
    FROM RENTAL_COPY
    WHERE DATE >= '2024-09-25'
)
SELECT WEEK_NUMBER, 
MIN(WEEK_START) AS Week_Start_Date,
MAX(WEEK_END) AS Week_End_Date, 
SUM(NET_AMOUNT) as Total_Profit,
COUNT(*) AS Transaction_Count
FROM WeeklyTransactions
GROUP BY Week_Number
ORDER BY Total_Profit DESC;

WITH WeeklyTransactions AS (
    SELECT DATE,
	       NET_AMOUNT,
           DATEPART(WEEK, DATE) - DATEPART(WEEK, '2024-09-25') + 1 AS Week_Number,
           DATEADD(DAY, -1 * (DATEPART(WEEKDAY, DATE) - 1), DATE) AS Week_Start,
           DATEADD(DAY, 6 - (DATEPART(WEEKDAY, DATE) - 1), DATE) AS Week_End
    FROM RENTAL_COPY
    WHERE DATE >= '2024-09-25'
)
SELECT WEEK_NUMBER, 
MIN(WEEK_START) AS Week_Start_Date,
MAX(WEEK_END) AS Week_End_Date, 
SUM(NET_AMOUNT) as Total_Profit,
COUNT(*) AS Transaction_Count
FROM WeeklyTransactions
GROUP BY Week_Number
ORDER BY Week_Number;

--Filtering Refund Data
SELECT * FROM RENTAL_COPY
WHERE TYPE = 'REFUND';

--FILTERING DISTINCT CUSTOMER_CITY & CUSTOMER_COUNTRY
SELECT DISTINCT CUSTOMER_CITY, customer_country FROM RENTAL_COPY;

--Analyzing the Data for each country with respect to Total Profit, Total Amount, Total Amount of Customer Transaction &
--Total Stripe Fee
with WeeklyTransactions as (
select *, 
        DATEPART(WEEK, DATE) - DATEPART(WEEK, '2024-09-25') + 1 AS Week_Number,
		DATEADD(DAY,-1 * (DATEPART(WEEKDAY,DATE) -1) ,DATE) AS Week_Start,
		DATEADD(DAY,6 - (DATEPART(WEEKDAY,DATE) -1) ,DATE) AS Week_End
		FROM RENTAL_COPY
		WHERE DATE >= '2024-09-25')

SELECT 
       CUSTOMER_COUNTRY,
       SUM(NET_AMOUNT) AS TOTAL_PROFIT,
       SUM(AMOUNT) AS TOTAL_AMOUNT,
       SUM(CUSTOMER_TRANSACTION) AS TOTAL_CUSTOMER_TRANSACTION,
       SUM(FEE) AS TOTAL_STRIPE_FEE
       FROM WeeklyTransactions
       GROUP BY CUSTOMER_COUNTRY
       ORDER BY CUSTOMER_COUNTRY;
SELECT * FROM RENTAL_COPY;

--Listing down all the columns of the Table
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'RENTAL_COPY';

--Creating a new Table with specific columns and concatenated City & Country Column
SELECT ID, AMOUNT, (CUSTOMER_CITY + ' '+ CUSTOMER_COUNTRY) AS CITY_COUNTRY , CUSTOMER_TRANSACTION, FEE, PAYOUT, DATE
INTO RENTAL_TABLE_1
FROM RENTAL_COPY;

DROP TABLE RENTAL_TABLE_1;

SELECT * FROM RENTAL_TABLE_1;

--Analyzing the Financial data City_Country wise
Select CITY_COUNTRY, 
       SUM(AMOUNT) AS TOTAL_AMOUNT, 
	   SUM(CUSTOMER_TRANSACTION) AS TOTAL_CUSTOMER_TRANSACTION, 
	   SUM(FEE) AS TOTAL_FEE, 
	   SUM(PAYOUT) AS TOTAL_PAYOUT
FROM RENTAL_TABLE_1
GROUP BY CITY_COUNTRY
ORDER BY CITY_COUNTRY;

--Ordering according to Total Amount 
Select CITY_COUNTRY, 
       SUM(AMOUNT) AS TOTAL_AMOUNT, 
	   SUM(CUSTOMER_TRANSACTION) AS TOTAL_CUSTOMER_TRANSACTION, 
	   SUM(FEE) AS TOTAL_FEE, 
	   SUM(PAYOUT) AS TOTAL_PAYOUT
FROM RENTAL_TABLE_1
GROUP BY CITY_COUNTRY
ORDER BY TOTAL_AMOUNT DESC;

--Ordering according to Total_Customer_Transaction
Select CITY_COUNTRY, 
       SUM(AMOUNT) AS TOTAL_AMOUNT, 
	   SUM(CUSTOMER_TRANSACTION) AS TOTAL_CUSTOMER_TRANSACTION, 
	   SUM(FEE) AS TOTAL_FEE, 
	   SUM(PAYOUT) AS TOTAL_PAYOUT
FROM RENTAL_TABLE_1
GROUP BY CITY_COUNTRY
ORDER BY TOTAL_CUSTOMER_TRANSACTION DESC;

----Ordering according to Total_Fee
Select CITY_COUNTRY, 
       SUM(AMOUNT) AS TOTAL_AMOUNT, 
	   SUM(CUSTOMER_TRANSACTION) AS TOTAL_CUSTOMER_TRANSACTION, 
	   SUM(FEE) AS TOTAL_FEE, 
	   SUM(PAYOUT) AS TOTAL_PAYOUT
FROM RENTAL_TABLE_1
GROUP BY CITY_COUNTRY
ORDER BY TOTAL_FEE DESC;

--Ordering according to Total_Payout
Select CITY_COUNTRY, 
       SUM(AMOUNT) AS TOTAL_AMOUNT, 
	   SUM(CUSTOMER_TRANSACTION) AS TOTAL_CUSTOMER_TRANSACTION, 
	   SUM(FEE) AS TOTAL_FEE, 
	   SUM(PAYOUT) AS TOTAL_PAYOUT
FROM RENTAL_TABLE_1
GROUP BY CITY_COUNTRY
ORDER BY TOTAL_PAYOUT DESC;


Select Distinct CITY_COUNTRY from RENTAL_TABLE_1;

--ANALYZING WEEKLY AVERAGE TRANSACTIONS FOR Brisbane Australia
With WeeklyTransactions as (
SELECT *,
        DATEPART(WEEK, DATE) - DATEPART( WEEK,'2024-09-25') + 1 AS Week_Number,
		DATEADD(DAY, -1 * DATEPART(WEEKDAY,DATE) -1, DATE) AS Week_Start,
		DATEADD(DAY, 6 - DATEPART(WEEKDAY, DATE) -1, DATE) AS Week_End
		FROM RENTAL_COPY
		WHERE DATE >= '2024-09-25')
SELECT T1.Week_Number,
       MIN(T1.Week_Start) As Week_Start_Date,
	   MAX(T1.Week_End) as Week_End_Date, 
	   T2.CITY_COUNTRY,
	   AVG(T2.CUSTOMER_TRANSACTION) AS 'AVERAGE_CUSTOMER_TRANSACTION',
	   AVG(T2.FEE) AS 'AVERAGE_FEE',
	   AVG(T2.PAYOUT) AS 'AVERAGE_PAYOUT'
	   FROM WeeklyTransactions AS T1
	   JOIN RENTAL_TABLE_1 T2
	   ON T1.DATE =  T2.DATE
	   WHERE CITY_COUNTRY = 'Brisbane Australia'
	   GROUP BY Week_Number, CITY_COUNTRY
	   ORDER BY Week_Number;

--ANALYZING WEEKLY AVERAGE TRANSACTIONS FOR Jurong Singapore
With WeeklyTransactions as (
SELECT *,
        DATEPART(WEEK, DATE) - DATEPART( WEEK,'2024-09-25') + 1 AS Week_Number,
		DATEADD(DAY, -1 * DATEPART(WEEKDAY,DATE) -1, DATE) AS Week_Start,
		DATEADD(DAY, 6 - DATEPART(WEEKDAY, DATE) -1, DATE) AS Week_End
		FROM RENTAL_COPY
		WHERE DATE >= '2024-09-25')
SELECT T1.Week_Number,
       MIN(T1.Week_Start) As Week_Start_Date,
	   MAX(T1.Week_End) as Week_End_Date, 
	   T2.CITY_COUNTRY,
	   AVG(T2.CUSTOMER_TRANSACTION) AS 'AVERAGE_CUSTOMER_TRANSACTION',
	   AVG(T2.FEE) AS 'AVERAGE_FEE',
	   AVG(T2.PAYOUT) AS 'AVERAGE_PAYOUT'
	   FROM WeeklyTransactions AS T1
	   JOIN RENTAL_TABLE_1 T2
	   ON T1.DATE =  T2.DATE
	   WHERE CITY_COUNTRY = 'Jurong Singapore'
	   GROUP BY Week_Number, CITY_COUNTRY
	   ORDER BY Week_Number;

----ANALYZING WEEKLY AVERAGE TRANSACTIONS FOR Melbourne Australia
With WeeklyTransactions as (
SELECT *,
        DATEPART(WEEK, DATE) - DATEPART( WEEK,'2024-09-25') + 1 AS Week_Number,
		DATEADD(DAY, -1 * DATEPART(WEEKDAY,DATE) -1, DATE) AS Week_Start,
		DATEADD(DAY, 6 - DATEPART(WEEKDAY, DATE) -1, DATE) AS Week_End
		FROM RENTAL_COPY
		WHERE DATE >= '2024-09-25')
SELECT T1.Week_Number,
       MIN(T1.Week_Start) As Week_Start_Date,
	   MAX(T1.Week_End) as Week_End_Date, 
	   T2.CITY_COUNTRY,
	   AVG(T2.CUSTOMER_TRANSACTION) AS 'AVERAGE_CUSTOMER_TRANSACTION',
	   AVG(T2.FEE) AS 'AVERAGE_FEE',
	   AVG(T2.PAYOUT) AS 'AVERAGE_PAYOUT'
	   FROM WeeklyTransactions AS T1
	   JOIN RENTAL_TABLE_1 T2
	   ON T1.DATE =  T2.DATE
	   WHERE CITY_COUNTRY = 'Melbourne Australia'
	   GROUP BY Week_Number, CITY_COUNTRY
	   ORDER BY Week_Number;
--This also shows that there was no transactions made during week 1 & week 3 

----ANALYZING WEEKLY AVERAGE TRANSACTIONS FOR Perth Australia
With WeeklyTransactions as (
SELECT *,
        DATEPART(WEEK, DATE) - DATEPART( WEEK,'2024-09-25') + 1 AS Week_Number,
		DATEADD(DAY, -1 * DATEPART(WEEKDAY,DATE) -1, DATE) AS Week_Start,
		DATEADD(DAY, 6 - DATEPART(WEEKDAY, DATE) -1, DATE) AS Week_End
		FROM RENTAL_COPY
		WHERE DATE >= '2024-09-25')
SELECT T1.Week_Number,
       MIN(T1.Week_Start) As Week_Start_Date,
	   MAX(T1.Week_End) as Week_End_Date, 
	   T2.CITY_COUNTRY,
	   AVG(T2.CUSTOMER_TRANSACTION) AS 'AVERAGE_TRANSACTION',
	   AVG(T2.FEE) AS 'AVERAGE_FEE',
	   AVG(T2.PAYOUT) AS 'AVERAGE_PAYOUT'
	   FROM WeeklyTransactions AS T1
	   JOIN RENTAL_TABLE_1 T2
	   ON T1.DATE =  T2.DATE
	   WHERE CITY_COUNTRY = 'Perth Australia'
	   GROUP BY Week_Number, CITY_COUNTRY
	   ORDER BY Week_Number;

----ANALYZING WEEKLY AVERAGE TRANSACTIONS FOR Singapore Singapore
With WeeklyTransactions as (
SELECT *,
        DATEPART(WEEK, DATE) - DATEPART( WEEK,'2024-09-25') + 1 AS Week_Number,
		DATEADD(DAY, -1 * DATEPART(WEEKDAY,DATE) -1, DATE) AS Week_Start,
		DATEADD(DAY, 6 - DATEPART(WEEKDAY, DATE) -1, DATE) AS Week_End
		FROM RENTAL_COPY
		WHERE DATE >= '2024-09-25')
SELECT T1.Week_Number,
       MIN(T1.Week_Start) As Week_Start_Date,
	   MAX(T1.Week_End) as Week_End_Date, 
	   T2.CITY_COUNTRY,
	   AVG(T2.CUSTOMER_TRANSACTION) AS 'AVERAGE_CUSTOMER_TRANSACTION',
	   AVG(T2.FEE) AS 'AVERAGE_FEE',
	   AVG(T2.PAYOUT) AS 'AVERAGE_PAYOUT'
	   FROM WeeklyTransactions AS T1
	   JOIN RENTAL_TABLE_1 T2
	   ON T1.DATE =  T2.DATE
	   WHERE CITY_COUNTRY = 'Singapore Singapore'
	   GROUP BY Week_Number, CITY_COUNTRY
	   ORDER BY Week_Number;









