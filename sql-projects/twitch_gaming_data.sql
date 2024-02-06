/* Project: Analyze Twitch Gaming Data
Source: codeacademy .com

Twitch is the world’s leading live-streaming platform for gamers, with 15 million daily active users. Using data to understand its users and products is one of the main responsibilities of the Twitch Data Science Team.

In this project, you will be working with two tables that contain Twitch users’ stream viewing data and chat room usage data.

Stream viewing data:

stream table
Chat usage data:

chat table
The Twitch Science Team provided this practice dataset. You can download the .csv files (800,000 rows) from GitHub.

https://github.com/Codecademy-Curriculum/Codecademy-Learn-SQL-from-Scratch/tree/master/Twitch
*/
-- 1. Preview the data
SELECT *
FROM stream
LIMIT 20;

SELECT * 
FROM chat
LIMIT 20;

-- 2. What are the unique games in the stream table?
SELECT DISTINCT(game)
FROM stream;

-- 3. What are the unique channels in the stream table?
SELECT DISTINCT(channel)
FROM stream;

-- 4. What are the most popular games in the stream table?
SELECT game,
  COUNT(*)
FROM stream
GROUP BY 1
ORDER BY 2 DESC;

-- 5. These are some big numbers from the game League of Legends (also known as LoL). Where are these LoL stream viewers located?
SELECT country,
  COUNT(*)
FROM stream
WHERE game = 'League of Legends' AND
  country IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

-- 6. The player column contains the source the user is using to view the stream (site, iphone, android, etc). Create a list of players and their number of streamers.
SELECT player,
  COUNT(*)
FROM stream
GROUP BY 1
ORDER BY 2 DESC;

-- 7. Create a new column named genre for each of the games. Group the games into their genres: Multiplayer Online Battle Arena (MOBA), First Person Shooter (FPS), Survival, and Other.
SELECT game,
  CASE
    WHEN game IN ('League of Legends', 'Dota 2', 'Heroes of the Storm') THEN 'Multiplayer Online Battle Arena (MOBA)'
    WHEN game = 'Counter-Strike: Global Offensive' THEN 'First Person Shooter (FPS)'
    WHEN game IN ('DayZ', 'ARK: Survival Evolved') THEN 'Survival'
    ELSE 'Other'
  END AS 'genre',
  COUNT(*)
FROM stream
GROUP BY 1
ORDER BY 3 DESC;

-- 8. Check the timeline of both tables
SELECT MAX(DATETIME(time)),
  MIN(DATETIME(time))
FROM chat;

SELECT MAX(DATETIME(time)),
  MIN(DATETIME(time))
FROM stream;

-- 9. Write a query that returns two columns: The hours of the time  and The view count for each hour. Then, filter the result with only the users in your country using a WHERE clause.
SELECT STRFTIME('%H', time) 'hour',
  COUNT(*) 'viewa'
FROM stream
WHERE country ='US'
GROUP BY 1
ORDER BY 2 DESC;

-- 10. Join tables
SELECT *
FROM stream
JOIN chat
  ON stream.device_id = chat.device_id
LIMIT 20;

SELECT s.device_id, 
  s.channel,
  s.country,
  s.player,
  s.game
FROM stream s
JOIN chat c
  ON s.device_id = c.device_id;

-- 11. Which channel is the most active one in chat? Which game does this channel play? 
SELECT stream.channel,
  stream.country,
  stream.game,
  COUNT(*)
FROM stream
JOIN chat
  ON stream.device_id = chat.device_id
GROUP BY 1
ORDER BY 4 DESC;

-- 12. In which game there are the most communications?
SELECT stream.game,
  COUNT(*)
FROM stream
JOIN chat
  ON stream.device_id = chat.device_id
GROUP BY 1
ORDER BY 2 DESC;
