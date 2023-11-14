/* Project: Multiple Tables with Reddit
Source: codeacademy.com

For this project, you’ll be working as a Data Analyst who will be examining some fictional data from Reddit, a social news aggregation, content rating site.

On Reddit, users can create posts with content such as text, media, and links to other websites. Users can post content to different communities known as subreddits, which focus on a particular topic. Users can then rate others’ content by upvoting or downvoting them, and each post will show its total cumulative score.

For this task you were given three tables:

users: users data
posts: posts information
subreddits: information about subreddits
*/

-- Preview these 3 tables
SELECT *
FROM users
LIMIT 5;

SELECT *
FROM posts
LIMIT 5;

SELECT *
FROM subreddits
LIMIT 5;

-- What user has the highest score?
SELECT *
FROM users
ORDER BY score DESC
LIMIT 1;
-- OR
SELECT username,
  MAX(score) 
FROM users;
-- The user who has the highest score is ctills1w with the score of 300,895.


-- What post has the highest score?
SELECT *
FROM posts
ORDER BY score DESC
LIMIT 1;
-- OR
SELECT id,
  title,
  MAX(score)
FROM posts;
-- The post that has the highest score is Picture of a kitten with the score of 149,176.

-- What are the top 5 subreddits with the highest subscriber_count?
SELECT *
FROM subreddits
ORDER BY subscriber_count DESC 
LIMIT 5;
-- The top 5 subreddits with the highest subscriber_count are AskReddit, gaming, aww, pics, and science.

-- Use a LEFT JOIN with the users and posts tables to find out how many posts each user has made. Have the users table as the left table and order the data by the number of posts in descending order.
SELECT users.username,
  COUNT(*) 'posts_made'
FROM users
LEFT JOIN posts
  ON users.id = posts.user_id
WHERE users.username IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC;

-- Some new posts have been added to Reddit! Stack the new posts2 table under the existing posts table to see them.
SELECT *
FROM posts
UNION 
SELECT * 
FROM posts2;

-- Now you need to find out which subreddits have the most popular posts. We’ll say that a post is popular if it has a score of at least 5000. We’ll do this using a WITH and a JOIN.
WITH popular_posts AS (
  SELECT *
  FROM posts
  WHERE score >= 5000
)
SELECT popular_posts.title,
  popular_posts.score,
  sub.name
FROM popular_posts
JOIN subreddits sub
  ON popular_posts.subreddit_id = sub.id
ORDER BY 2 DESC;

-- Next, you need to find out the highest scoring post for each subreddit.
SELECT posts.title,
  sub.name,
  MAX(posts.score)
FROM posts
JOIN subreddits sub
  ON posts.subreddit_id = sub.id
GROUP BY 2
ORDER BY 3 DESC;

-- Then, you need to write a query to calculate the average score of all the posts for each subreddit.
SELECT sub.name,
  ROUND(AVG(posts.score), 2) 'average_score'
FROM posts
JOIN subreddits sub
  ON posts.subreddit_id = sub.id
GROUP BY 1
ORDER BY 2 DESC;
