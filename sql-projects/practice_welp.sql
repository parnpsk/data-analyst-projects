/* Project: Welp
Source: codeacademy.com

Instruction: To practice what you’ve learned about joining multiple tables, you are going to use data from an exciting app called Welp. Users love Welp because it allows them to leave reviews of businesses in their city and see how other people reviewed the businesses.

For this project, you will be working with two tables:
places
reviews
*/

-- Preview the data
SELECT * 
FROM places;
 
SELECT * 
FROM reviews;

-- each dollar sign ($) represents $10, how could you find all places that cost $20 or less?
SELECT *
FROM places
WHERE price_point <= '$$';
-- There are 14 places that cost $20 or less

-- Find average rating of each types of places
SELECT type,
  COUNT(*) 'number_of_places',
  AVG(average_rating) 'average_rating'
FROM places
GROUP BY 1
ORDER BY 2 DESC;

-- JOIN the tables and select only the most important columns
SELECT places.name,
  places.average_rating,
  reviews.username,
  reviews.rating,
  reviews.review_date,
  reviews.note
FROM places
JOIN reviews
   ON places.id = reviews.place_id;

-- Find the places without reviews in our dataset
SELECT places.id, 
  places.name
FROM places
LEFT JOIN reviews
   ON places.id = reviews.place_id
WHERE review_date IS NULL;
-- There are 2 places that do not have any reviews: Thai Tanic and Silent Gas

-- Write a query using the WITH clause to select all the reviews that happened in 2020. JOIN the places to your WITH query to see a log of all reviews from 2020.
WITH reviews_2020 AS (
  SELECT *
  FROM reviews
  WHERE strftime('%Y', review_date) ='2020'
)
SELECT *
FROM places
JOIN reviews_2020
  ON places.id = reviews_2020.place_id
ORDER BY average_rating DESC;

-- Write a query that finds the reviewer with the most reviews that are BELOW the average rating for places.
SELECT places.id,
  places.name,
  places.average_rating,
  reviews.username,
  reviews.rating,
  COUNT(*)
FROM places
JOIN reviews
  ON places.id = reviews.place_id
WHERE reviews.rating < places.average_rating
GROUP BY 4
ORDER BY 6 DESC
LIMIT 1;
-- The reviewer with the most reviews that are BELOW the average rating for places is @pinkdeb 

-- Find the reviewers writing ! on their note and rate the place higher that the average
SELECT *
FROM places
JOIN reviews
  ON places.id = reviews.place_id
WHERE reviews.note LIKE '%!%'
  AND reviews.rating > places.average_rating;

