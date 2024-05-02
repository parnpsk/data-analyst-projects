/* Project: Codecademy Learners Mockup Data
Source: codeacademy.com

Goal: Use your knowledge of SQL and analyze some mockup Codecademy learners data.
Data: 2 tables with 2,000 rows 
*/

-- Preview the data from these 2 tables
SELECT *
FROM users
LIMIT 10;

SELECT *
FROM progress
LIMIT 10; 

-- What are the Top 25 schools (.edu domains)?
SELECT email_domain,
  COUNT(user_id) AS 'num_users'
FROM users
WHERE email_domain LIKE '%.edu'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 25;


-- How many .edu learners are located in New York?
SELECT city,
  COUNT(user_id) AS 'num_NY_edu_users'
FROM users
WHERE email_domain LIKE '%.edu'
    AND city = 'New York';

-- The mobile_app column contains either mobile-user or NULL. How many of these Codecademy learners are using the mobile app?
SELECT mobile_app,
  COUNT(user_id) AS 'num_mobile_users'
FROM users
WHERE mobile_app = 'mobile-user';

--  Query for the sign up counts for each hour.
SELECT strftime('%H', sign_up_at) AS 'hour',
  COUNT(user_id) AS 'num_users'
FROM users
GROUP BY 1
ORDER BY 1 ASC;

-- Join the two tables using JOIN and then see what you can dig out of the data!
-- Do different schools (.edu domains) prefer different courses?
SELECT users.email_domain,
  SUM(
    CASE
      WHEN progress.learn_cpp IN ('started', 'completed')
      THEN 1
      ELSE 0 
   END) 'num_learn_cpp',
  SUM(
    CASE
      WHEN progress.learn_sql IN ('started', 'completed')
      THEN 1
      ELSE 0 
   END) 'num_learn_sql',
   SUM(
    CASE
      WHEN progress.learn_html IN ('started', 'completed')
      THEN 1
      ELSE 0 
   END) 'num_learn_html',
   SUM(
    CASE
      WHEN progress.learn_javascript IN ('started', 'completed')
      THEN 1
      ELSE 0 
   END) 'num_learn_javascript',
   SUM(
    CASE
      WHEN progress.learn_java IN ('started', 'completed')
      THEN 1
      ELSE 0 
   END) 'num_learn_java'
FROM users
JOIN progress
    ON users.user_id = progress.user_id
WHERE users.email_domain LIKE '%.edu'
GROUP BY 1;

-- Yes, different schools prefer different courses.

-- What courses are the New Yorkers students taking
-- What courses are the Chicago students taking?
WITH user_courses AS (
  SELECT users.user_id, 
    users.email_domain,
    users.city,
    SUM(
       CASE 
          WHEN progress.learn_cpp IN ('started', 'completed') 
          THEN 1 
          ELSE 0 
        END
      ) AS num_learn_cpp,
    SUM(
        CASE 
          WHEN progress.learn_sql IN ('started', 'completed') 
          THEN 1 
          ELSE 0 
        END
        ) AS num_learn_sql,
    SUM(
      CASE 
        WHEN progress.learn_html IN ('started', 'completed') 
        THEN 1 
        ELSE 0 
      END
      ) AS num_learn_html,
    SUM(
      CASE 
        WHEN progress.learn_javascript IN ('started', 'completed') 
        THEN 1 
        ELSE 0 
      END
      ) AS num_learn_javascript,
    SUM(
      CASE 
        WHEN progress.learn_java IN ('started', 'completed') 
        THEN 1 
        ELSE 0 
      END
      ) AS num_learn_java
  FROM users
  JOIN progress ON users.user_id = progress.user_id
  GROUP BY 1, 2
)
SELECT city,
  SUM(num_learn_cpp) AS num_learn_cpp,
  SUM(num_learn_sql) AS num_learn_sql,
  SUM(num_learn_html) AS num_learn_html,
  SUM(num_learn_javascript) AS num_learn_javascript,
  SUM(num_learn_java) AS num_learn_java
FROM user_courses
WHERE email_domain LIKE '%.edu'
  AND city IN ('New York', 'Chicago')
GROUP BY 1;

-- The NY students study JavaScript the most of 29, then SQL (25), CPP (16), HTML (14), and Java (8). 
-- Similar to the NY students, the Chicago students study JavaScript the most (46), then SQL (42), CPP (37), HTML (29), and Java (8). 