/* Project: The Metropolitan Museum of Art 
Source: codeacademy.com
https://www.metmuseum.org/about-the-met/policies-and-documents/image-resources

Instructions: In this project, you will be working with a table named met that contains the museum’s collection of American Decorative Arts.

It has the following columns:

id - the id of the art piece
department - the department of the art piece
category - the category of the art piece
title - the title name of the art piece
artist - the name of the artist
date - the date(s) of the art piece
medium - the medium of the art piece
country - the country of the artist
*/

-- 1. Preview the data to see the column names
SELECT *
FROM met
LIMIT 10;

-- 2. How many pieces are in the American Decorative Art collection?
SELECT COUNT(*)
FROM met;

-- 3. Celery was considered a luxurious snack in the Victorian era (around the 1800s). 
-- Count the number of pieces where the category includes ‘celery’.
SELECT COUNT(*)
FROM met
WHERE category LIKE '%celery%';

-- 4. Find the title and medium of the oldest piece(s) in the collection.
-- First, I check the oldest date 
SELECT MIN(date)
FROM met;
-- Then, filter all pieces with the date 1600-1700
SELECT date,
  title,
  medium
FROM met
WHERE date LIKE '1600%';

-- 5. Not every American decoration is from the Americas… where are they are coming from? 
-- Find the top 10 countries (excludes USA) with the most pieces in the collection.
SELECT country,
  COUNT(*)
FROM met
WHERE country IS NOT NULL
  AND country NOT LIKE '%United States%' 
GROUP BY country
ORDER BY 2 DESC
LIMIT 10;

-- 6. There are all kinds of American decorative art in the Met’s collection.
-- Find the categories HAVING more than 100 pieces.
SELECT category,
  COUNT(*)
FROM met
GROUP BY 1
HAVING COUNT(*) > 100
ORDER BY 2 DESC;

-- 7. Count the number of pieces where the medium contains ‘gold’ or ‘silver’. And sort in descending order.
SELECT  medium,
  COUNT(*)
FROM met 
WHERE medium LIKE '%gold%'
  OR medium LIKE '%silver%'
GROUP BY 1
ORDER BY 2 DESC;

-- optional: useing CASE statement
SELECT 
  CASE
    WHEN medium LIKE '%gold%' THEN 'Gold'
    WHEN medium LIKE '%silver%' THEN 'Silver'
    ELSE 'Others'
  END,
  COUNT(*) 
FROM met
GROUP BY 1
ORDER BY 2;
