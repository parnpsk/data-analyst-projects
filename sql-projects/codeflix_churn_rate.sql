/* Project Assignment: User Churn
Source: codeacademy.com

Codeflix, a streaming video startup, is interested in measuring its user churn rate. In this project, you’ll be helping them answer these questions about their churn:

1. Get familiar with the company.
- How many months has the company been operating? Which months do you have enough information to calculate a churn rate?
- What segments of users exist?

2. What is the overall churn trend since the company started?

3. Compare the churn rates between user segments.
- Which segment of users should the company focus on expanding?

The marketing department is particularly interested in how the churn compares between two segments of users. They provide you with a dataset containing subscription data for users who were acquired through two distinct channels.

The dataset provided to you contains one SQL table, subscriptions. Within the table, there are 4 columns:

id - the subscription id
subscription_start - the start date of the subscription
subscription_end - the end date of the subscription
segment - this identifies which segment the subscription owner belongs to
Codeflix requires a minimum subscription length of 31 days, so a user can never start and end their subscription in the same month.

*/
-- Preview the dataset in the subscriptions table
SELECT *
FROM subscriptions
LIMIT 20;

-- Determine the range of months of data provided. Which months will you be able to calculate churn for?
SELECT MIN(subscription_start),
  MAX(subscription_start)
FROM subscriptions;
-- The range of data starts on 2016-12-01 until 2017-03-30

-- Check how many segments
SELECT segment,
    COUNT(*)
FROM subscriptions 
GROUP BY 1;
-- There are 2 segments; 87 and 30.

-- Calculate the churn rate for both segments (87 and 30) over the first 3 months of 2017 (you can’t calculate it for December, since there are no subscription_end values yet).
-- First, create a temporary table of months as the start-end of each month by using WITH statement and UNION
WITH months AS (
  SELECT 
    '2017-01-01' AS first_date,
    '2017-01-31' AS last_date
  UNION
  SELECT
    '2017-02-01' AS first_date,
    '2017-02-28' AS last_date
  UNION
  SELECT
    '2017-03-01' AS first_date,
    '2017-03-31' AS last_date
),
-- Then, create another temporary table by using CROSS JOIN between the subscriptions table and the months table.
  cross_join AS (
    SELECT sub.*,
      months.*
    FROM subscriptions sub
    CROSS JOIN months
  ),
-- Create a temporary table status from the cross_join table 
status AS (
    SELECT id,
      first_date AS 'month',
      CASE
        WHEN segment = 87
          AND (subscription_start < first_date)
          AND (
            subscription_end > first_date
            OR subscription_end IS NULL
          ) THEN 1 
        ELSE 0
      END AS 'is_active_87',
      CASE
        WHEN segment = 30
          AND (subscription_start < first_date)
          AND (
            subscription_end > first_date
            OR subscription_end IS NULL
            ) THEN 1 
        ELSE 0
      END AS 'is_active_30',
      CASE
        WHEN segment = 87
          AND subscription_end BETWEEN first_date AND last_date
        THEN 1 
        ELSE 0
      END AS 'is_canceled_87',
      CASE 
        WHEN segment = 30
          AND subscription_end BETWEEN first_date AND last_date
        THEN 1
        ELSE 0
      END AS 'is_canceled_30' 
    FROM cross_join
  ),
/*-- Runs this below code to check whether the above lines are correct before  (optional)
SELECT *
FROM status;*/

-- Create a temporary table status_aggregate to calculate the active and cancelled subscriptions for each segment, for each month.
  status_aggregate AS (
    SELECT month,
      SUM(is_active_87) AS 'sum_active_87',
      SUM(is_active_30) AS 'sum_active_30',
      SUM(is_canceled_87) AS 'sum_canceled_87',
      SUM(is_canceled_30) AS 'sum_canceled_30'
    FROM status
    GROUP BY 1
  )
  /*-- Runs this below code to check whether the above lines are correct before  (optional)
  SELECT *
  FROM status_aggregate;*/

  -- Calculate the churn rates for the two segments over the three-month period. Which segment has a lower churn rate?
  SELECT month,
    ROUND(1.0 * sum_canceled_87 / sum_active_87,2) AS 'churn_rate_87',
    ROUND(1.0* sum_canceled_30 / sum_active_30, 2) AS 'churn_rate_30'
  FROM status_aggregate;

/* The results
- In January 2017, the churn rate for the segment 87 was 25% and 8% for the segment 30. 
- In February 2017, the churn rate for the segment 87 was 32% and 7% for the segment 30.
- In March 2017, the churn rate for the segment 87 was 49% and 12% for the segment 30. 
Overall, the churn rates of the segment 87 were much higher than the segment 30. It also increased over the three-month period. 
*/















