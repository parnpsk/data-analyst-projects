/* Project: Analyze Hacker News Trends
Source: codeacademy.com
https://opensource.org/license/mit/

Instuction:
Hacker News is a popular website run by Y Combinator. It’s widely known by people in the tech industry as a community site for sharing news, showing off projects, asking questions, among other things.

In this project, you will be working with a table named hacker_news that contains stories from Hacker News since its launch in 2007. It has the following columns:

title: the title of the story
user: the user who submitted the story
score: the score of the story
timestamp: the time of the story
url: the link of the story
*/

 -- Previre the dataset
 SELECT * 
 FROM hacker_news
 LIMIT 10;

 -- What are the top five stories with the highest scores?
 SELECT title,
  score
FROM hacker_news
ORDER BY 2 DESC
LIMIT 5;

/* Recent studies have found that online forums tend to be dominated by a small percentage of their users. https://en.wikipedia.org/wiki/1%25_rule */
-- Is a small percentage of Hacker News submitters taking the majority of the points?
-- First, find the total score of all the stories.
SELECT SUM(score)
FROM hacker_news;

-- (optional) find how many users 
SELECT COUNT(user)
FROM hacker_news;

-- Second, find the individual users who have gotten combined scores of more than 200, and their combined scores.
SELECT user,
  SUM(score)
FROM hacker_news
GROUP BY 1
HAVING SUM(score) > 200
ORDER BY 2 DESC;

-- Then, find the percentage of each user
SELECT (309.0 + 304.0 + 282.0 + 517.0)/6366.0
-- These top 4 users take 22% ot the total scores. 

/* Some users are rickrolling — tricking readers into clicking on a link to a funny video and claiming that it links to information about coding.
The url of the video is:
https://www.youtube.com/watch?v=dQw4w9WgXcQ
*/
-- How many times has each offending user posted this link?
SELECT user,
  COUNT(*)
FROM hacker_news
WHERE url LIKE '%youtube.com/watch?v=dQw4w9WgXcQ%'
GROUP BY user
ORDER BY 2 DESC;
-- the link has been used 3 times. 2 times by the users 'sonnynomnom' and 1 time by the user 'scorpiosister'.

-- Which of these sites feed Hacker News the most: GitHub, Medium, or New York Times?
SELECT 
  CASE
    WHEN url LIKE '%github%' THEN 'GitHub'
    WHEN url LIKE '%medium%' THEN 'Medium'
    WHEN url LIKE '%nytimes%' THEN 'New York Times'
    ELSE 'Others'
  END AS 'Source',
    COUNT(*)
  FROM hacker_news
  WHERE Source <> 'Others'
  GROUP BY 1
  ORDER BY 2 DESC;
-- The most popular source is GitHub

-- What’s the best time of the day to post a story on Hacker News?
-- Check on the timestamp column
SELECT timestamp
FROM hacker_news
LIMIT 10;

SELECT 
  strftime('%H', timestamp) AS 'hour',
  ROUND(AVG(score), 2) AS 'average_score',
  COUNT(*) AS 'number_of_stories'
FROM hacker_news
WHERE hour IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC;
-- The best times for the highest average score are between 18:00 - 20:00 and 7:00.
