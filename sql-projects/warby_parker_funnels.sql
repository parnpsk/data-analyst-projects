/* Project Assignment: Usage Funnels Warby Parker
Source: codeacademy.com

Warby Parker is a transformative lifestyle brand with a lofty objective: to offer designer eyewear at a revolutionary price while leading the way for socially conscious businesses. Founded in 2010 and named after two characters in an early Jack Kerouac journal, Warby Parker believes in creative thinking, smart design, and doing good in the world — for every pair of eyeglasses and sunglasses sold, a pair is distributed to someone in need.

In this project, you will analyze different Warby Parker’s marketing funnels in order to calculate conversion rates. Here are the funnels and the tables that you are given:
*/
-- Preview the data sets
SELECT *
FROM survey
LIMIT 10;

SELECT *
FROM quiz
LIMIT 5;

SELECT *
FROM home_try_on
LIMIT 5;

SELECT *
FROM purchase
LIMIT 5;

 -- There are 5 questions and users will “give up” at different points in the survey. Let’s analyze how many users move from Question 1 to Question 2, etc.
SELECT question,
  COUNT(DISTINCT user_id) num_users 
FROM survey
GROUP BY 1;

-- Using a spreadsheet program like Excel or Google Sheets, calculate the percentage of users who answer each question.
-- Which question(s) of the quiz have a lower completion rates? What do you think is the reason?

-- The last question had the lowest completion rates because it is the most complex question to answer. Other questions are more about their preferences. 

-- Find some insights from the original tables
-- First, will forcus on the quiz table
SELECT style,
  COUNT(*) num_users
FROM quiz
GROUP BY 1
ORDER BY 2 DESC;
-- Women's styles are slightly more popular than Men's styles. 

SELECT shape,
  COUNT(*) num_users,
FROM quiz
GROUP BY 1
ORDER BY 2 DESC;
-- Rectangular shape is the most popular shape, follow by square and round shape. 

SELECT color,
  COUNT(*)
FROM quiz
GROUP BY 1
ORDER BY 2 DESC;
-- Tortoise and Black are the most popular colors. 

-- Also, check the purchase table 
SELECT model_name,
  COUNT(*) num_purchases
FROM purchase
GROUP BY 1
ORDER BY 2 DESC;
-- The Eugene Narrow is the most popular model purchased by our customer, follow by Dawes, Brady, and Lucy. 

/*  Warby Parker’s purchase funnel is:

Take the Style Quiz → Home Try-On → Purchase the Perfect Pair of Glasses

During the Home Try-On stage, we will be conducting an A/B Test:

50% of the users will get 3 pairs to try on
50% of the users will get 5 pairs to try on
*/
-- use LEFT JOIN to join the quiz, home_try_on, and purchase tables
SELECT DISTINCT q.user_id,
  h.user_id IS NOT NULL AS 'is_home_try_on',
  h.number_of_pairs,
  p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
  ON q.user_id = h.user_id
LEFT JOIN purchase p
  ON p.user_id = q.user_id; 

-- Calculate conversion rates
WITH funnels AS (
  SELECT DISTINCT q.user_id,
  h.user_id IS NOT NULL AS 'is_home_try_on',
  h.number_of_pairs,
  p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
  ON q.user_id = h.user_id
LEFT JOIN purchase p
  ON p.user_id = q.user_id)
SELECT COUNT(*) num_users,
  SUM(is_home_try_on) num_try_on,
  SUM(is_purchase) num_purchase,
  ROUND(1.0 * SUM(is_home_try_on) / COUNT(user_id), 2) quiz_to_try,
  ROUND(1.0 * SUM(is_purchase) / SUM(is_home_try_on), 2) try_to_purchase
FROM funnels;
-- From quiz to home_try_on, the conversion rate is 75%, then, from home_try_on to purchase, the conversion rate decreased to 66%. 

-- Calculate the difference in purchase rates between customers who had 3 number_of_pairs with ones who had 5.
WITH funnels AS (
  SELECT DISTINCT q.user_id,
  h.user_id IS NOT NULL AS 'is_home_try_on',
  h.number_of_pairs,
  p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
  ON q.user_id = h.user_id
LEFT JOIN purchase p
  ON p.user_id = q.user_id)
SELECT number_of_pairs,
  COUNT(*) num_users,
  SUM(is_home_try_on) num_try_on,
  SUM(is_purchase) num_purchase,
  ROUND(1.0 * SUM(is_home_try_on) / COUNT(user_id), 2) quiz_to_try,
  ROUND(1.0 * SUM(is_purchase) / SUM(is_home_try_on), 2) try_to_purchase
FROM funnels
WHERE number_of_pairs IS NOT NULL
GROUP BY 1
ORDER BY 1;
-- The purchase rate of customers who has 5 number_of_pairs is 79% which is higher than those who had 3 (53%). This means that the more samples customers can try on, the more likely they make a purchase. 

-- Calculate the difference in conversion rates between customers who had preference shapes and those who had not. 
WITH funnels AS (
  SELECT DISTINCT q.user_id,
  h.user_id IS NOT NULL AS 'is_home_try_on',
  h.number_of_pairs,
  q.shape,
  p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
  ON q.user_id = h.user_id
LEFT JOIN purchase p
  ON p.user_id = q.user_id)
SELECT shape,
  COUNT(*) num_users,
  SUM(is_home_try_on) num_try_on,
  SUM(is_purchase) num_purchase,
  ROUND(1.0 * SUM(is_home_try_on) / COUNT(user_id), 2) quiz_to_try,
  ROUND(1.0 * SUM(is_purchase) / SUM(is_home_try_on), 2) try_to_purchase
FROM funnels
WHERE shape IS NOT NULL
GROUP BY 1
ORDER BY 1;
-- Customers who did not have preference seem to have higher conversion rates that customers who had preferences. Also, for customers without preferences, the conversion rate of try_to_perchase is slightly higher than the coversion rate of quiz_to_try. This means they tend to be more open to try out new styles than the custom.    

-- For future references, it might be a good idea to find out which shape these customer chose to try and which shapes they purchased. 
