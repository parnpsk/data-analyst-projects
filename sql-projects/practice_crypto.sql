/* Project: Cryptocurrency Exchange
Source: codecademy.com

Fiddy Cent is a digital currency exchange headquartered in Neo Tokyo. They broker exchanges of Bitcoin, Bitcoin Cash, Ethereum, and Litecoin with fiat currencies in around 50 countries.

Help them analyze their January ledger data using SQL aggregate functions! You are given the transactions table, which contains both money-in and money-out transactions.
*/

-- Preview the table
SELECT * 
FROM transactions
LIMIT 10;

-- What are the total money_in and money_out in the table
SELECT SUM(money_in) 'Total Money In',
  SUM(money_out) 'Total Money Out'
FROM transactions;

-- It was reported that Bitcoin dominates Fiddy Cent’s exchange. Let’s see if it is true within these dates by answering two questions:
-- How many money_in transactions are in this table?
SELECT COUNT(*)
FROM transactions
WHERE money_in IS NOT NULL;

-- How many money_in transactions are in this table where ‘BIT’ is the currency?
SELECT COUNT(*)
FROM transactions
WHERE money_in IS NOT NULL
  AND currency = 'BIT';

-- Calculate the percentage
SELECT ROUND((21.0/43.0)*100, 2);
-- BIT has almost 50% of the total money_in transactions.

-- What was the largest transaction in this whole table?
-- Was it money_in or money_out?
SELECT MAX(money_in),
  MAX(money_out)
FROM transactions;
-- The largest transaction is the money_out (15,047 USD)

-- What is the average money_in in the table for the currency Ethereum (‘ETH’)?
SELECT currency,
  ROUND(AVG(money_in),2) 
FROM transactions
WHERE currency = 'ETH';

-- Select date, average money_in, and average money_out from the table. And group everything by date.
SELECT date,
  ROUND(AVG(money_in),2) 'Average Money In',
  ROUND(AVG(money_out),2) 'Average Money Out'
FROM transactions
GROUP BY 1;
