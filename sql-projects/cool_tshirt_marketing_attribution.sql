/* Project: Marketing Attribution > First- and Last-Touch Attribution
Source: codeacademy.com

CoolTShirts, an innovative apparel shop, is running a bunch of marketing campaigns to increase website visits and purchases. 

In this project, you’ll be helping them answer these questions about their campaigns:

1. Get familiar with the company.

How many campaigns and sources do CoolTShirts use and how are they related? Be sure to explain the difference between utm_campaign and utm_source.
What pages are on their website?
2. What is the user journey?

How many first touches is each campaign responsible for?
How many last touches is each campaign responsible for?
How many visitors make a purchase?
How many last touches on the purchase page is each campaign responsible for?
What is the typical user journey?
3. Optimize the campaign budget.

CoolTShirts can re-invest in 5 campaigns. Which should they pick and why?

*/
-- Preview the page_visits table
SELECT *
FROM page_visits
LIMIT 10;

-- How many campaigns and sources does CoolTShirts use? Which source is used for each campaign?
SELECT COUNT(DISTINCT utm_campaign),
  COUNT(DISTINCT utm_source)
FROM page_visits;
-- CoolTShirts has 8 campaigns and use 6 sources. 

-- Find out how they are related
SELECT DISTINCT utm_campaign,
  utm_source
FROM page_visits;

/* 
1. Google is used for any search-related campaigns: paid-search and cool-tshirts-search
2. Facebook is used for advertising campaigns: retargetting-ad
3. Nytime is used for brand recognition campaign: getting-to-know-cool-tshirts
4. BuzzFeed is used for fun & entertainment contents: ten-crazy-cool-tshirts-facts
5. Medium is used for business insights: interview-with-cool-tshirts-founder
6. Email is used for updating news: weekly newsletter and retargetting-campaign
*/

-- What pages are on the CoolTShirts website?
SELECT DISTINCT page_name,
  COUNT(*)
FROM page_visits
GROUP BY 1;
-- There are 4 pages on the website, including landing_page, shopping_cart, checkout, and purchase. 

-- How many first touches is each campaign responsible for?
-- First, create a first_touch temporary table for the first touch of each user_id. 
WITH first_touch AS (
  SELECT user_id,
    MIN(timestamp) 'first_touch'
  FROM page_visits
  GROUP BY 1
),
-- Then INNER JOIN the first_touch table with the page_visits table to see first_touch of each campaign and source. Create another temporal table named all_ft.
all_ft AS (
  SELECT  ft.user_id,
    ft.first_touch,
    pv.utm_source,
    pv.utm_campaign
  FROM first_touch ft
  JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch = pv.timestamp
)
-- Finally, count total first_touch of each campaign and source using COUNT(*) and GROUP BY. 
SELECT all_ft.utm_source,
  all_ft.utm_campaign,
  COUNT(*) num_first_touch
FROM all_ft
GROUP BY 1, 2
ORDER BY 3 DESC;

-- How many last touches is each campaign responsible for?
-- Same process as the first_touch, but change MIN(timestamp) to MAX(timestamp).
WITH last_touch AS (
  SELECT user_id,
    MAX(timestamp) 'last_touch'
  FROM page_visits
  GROUP BY 1
),
all_lt AS (
  SELECT lt.user_id,
    lt.last_touch,
    pv.utm_source,
    pv.utm_campaign
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch = pv.timestamp
)
SELECT all_lt.utm_source,
  all_lt.utm_campaign,
  COUNT(*) num_last_touch
FROM all_lt
GROUP BY 1, 2
ORDER BY 3 DESC;

-- How many visitors make a purchase?
SELECT page_name, 
  COUNT(*) num_users
FROM page_visits
WHERE page_name LIKE '%purchase%'
GROUP BY 1;
-- 361 visitors make a purchase.

-- How many last touches on the purchase page is each campaign responsible for?
-- Filter the last touch query using WHERE clause.
WITH last_touch AS (
  SELECT user_id,
    MAX(timestamp) 'last_touch'
  FROM page_visits
  WHERE page_name LIKE '%purchase%' 
  GROUP BY 1
),
all_lt AS (
  SELECT lt.user_id,
    lt.last_touch,
    pv.utm_campaign,
    pv.page_name 
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch = pv.timestamp
)
SELECT all_lt.utm_campaign,
  COUNT(*) num_last_touch
FROM all_lt
-- WHERE all_lt.page_name LIKE '%purchase%' -- If you filter on this line, the result will be different as there are 3 users (user_id: 29180, 76466, 94852) who make the last touch after making a purchase. 
GROUP BY 1
ORDER BY 2 DESC;


-- CoolTShirts can re-invest in 5 campaigns. Given your findings in the project, which should they pick and why?
/* Consider First- and Last-Touch Attribution, CoolTShirts should pick these 5 projects below:

  1. weekly-newsletter
  2. retargetting-ad
  3. retargetting-campaign
  4. paid-search
  5. getting-to-know-cool-tshirts (OR ten-crazy-cool-tshirts-facts)

  The weekly-newsletter and retargetting-ad campaings are responsible for the highest numbers of last touch on the purchase page. 
The numbers of users making a purchase from these 2 campaigns (115 and 113 respectively) are double higher than other campaigns, followed by retargetting-campaign (54) and paid-search (52). 
  However, for the fifth campaign, it can be either getting-to-know-cool-tshirts or ten-crazy-cool-tshirts-facts as both are responsible for the same numbers on the purchase page (9). 
Even though the getting-to-know-cool-tshirts has slightly higher numbers of the last touch (232, and 190 for the ten-crazy-cool-tshirts-facts), 
it would be a good idea to consider other perspectives, like comparing the costs of using the sources Nytimes and BuzzFeed.
*/
