-- Project: Restaurant in SQL
-- Instuction: Create 5 tables and write at least 3 queries using subquery, with (common table expression), join, and aggregate functions.

-- To open the database
.open restaurant.db

.mode column

-- To create tables
CREATE TABLE customers (
  id INT UNIQUE,
  firstname TEXT,
  lastname TEXT,
  city TEXT,
  email TEXT
);
  
CREATE TABLE transactions (
   id INT UNIQUE,
   customer_id INT,
   transaction_date TEXT,
   menu_id INT,
   quantity INT
);
  
CREATE TABLE menus (
  id INT UNIQUE,
  name TEXT,
  price REAL,
  category TEXT
);
    
CREATE TABLE categories (
  id INT UNIQUE,
  name TEXT
);

-- To insert data into the tables
INSERT INTO customers VALUES 
	(1, 'Emma', 'Watson', 'New York', 'emma.w@gmail.com'),
  (2, 'Tommy', 'Smith', 'Boston', 'tommy.s@outlook.com'),
  (3, 'Lily', 'Greens', 'Chicago', 'lily.g@gmail.com'),
  (4, 'Jim', 'Brown', 'New York', 'jim.b@gmail.com'),
  (5, 'Andy', 'Smith', 'Columbia', 'andy.s@outlook.com'),
  (6, 'Oscar', 'Smith', 'Seattle', 'oscar.s@gmail.com')
   
INSERT INTO transactions VALUES
	(1, 6, '2020-01-31', 3, 6),
  (2, 5, '2020-06-15', 2, 1),
  (3, 2, '2021-12-30', 2, 3),
  (4, 1, '2022-01-05', 1, 2),
  (5, 2, '2020-12-29', 5, 1),
  (6, 3, '2021-02-15', 4, 2),
  (7, 1, '2022-02-20', 4, 5);

INSERT INTO menus VALUES	
	(1, 'Salad', 7, 1),
  (2, 'Chips', 5, 1),
  (3, 'Pasta', 18,2),
  (4, 'Steak', 25, 2),
  (5, 'Rice', 14, 2),
  (6, 'Cake', 9, 3),
  (7, 'Icecream', 8, 3);
    
INSERT INTO categories VALUES
	(1, 'Starter'),
  (2, 'Main'),
  (3, 'Dessert');

-- To preview all tables
SELECT *
FROM customers;
SELECT *
FROM transactions;
SELECT *
FROM menus;
SELECT *
FROM categories;

-- Check if there is any customer coming to the restaurant more than 1 time.
SELECT cu.id customer_id,
    cu.firstname || ' ' || cu.lastname fullname,
    COUNT(*) n
FROM customers cu
JOIN transactions t
  ON cu.id = t.customer_id
GROUP BY 1
HAVING n > 1;

-- Join all table and create VIEW from it 
DROP VIEW IF EXISTS res_table;

CREATE VIEW res_table AS
  SELECT t.transaction_date,
      cu.id customer_id,
      cu.firstname,
      cu.lastname,
      m.name AS menu,
      ca.name AS category,
      m.price,
      t.quantity,
      m.price*t.quantity AS total
  FROM menus m
  JOIN categories ca
    ON m.category = ca.id
  JOIN transactions t
    ON m.id = t.menu_id
  JOIN customers cu
    ON t.customer_id = cu.id;

-- Calculate average, min, and max of the transactions 
SELECT ROUND(AVG(total),2) average_transaction,
  MIN(total) min_transaction,
  MAX(total) max_transaction
FROM res_table;

-- Find any customer that is outside New York and ordered Pasta in 2020
WITH non_NY_customer AS (
  SELECT * FROM customers 
  WHERE city <> "New York"),
    order_pasta AS (
  SELECT * FROM menus
  WHERE name = "Pasta"),
    order2020 AS (
  SELECT * FROM transactions
    WHERE STRFTIME("%Y", transaction_date) = "2020")

SELECT non_NY_customer.firstname,
    non_NY_customer.lastname,
    non_NY_customer.city,
    order2020.transaction_date,
    order_pasta.name AS menu
FROM non_NY_customer
JOIN order2020
  ON non_NY_customer.id = order2020.customer_id
JOIN order_pasta
  ON order2020.menu_id = order_pasta.id;
