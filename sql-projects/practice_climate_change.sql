/* Project: Climate Change
Source: codeacademy

Instruction: To practice what you’ve learned about window functions, you are going to use climate data from each state in the United States.
*/
-- Preview the data
SELECT *
FROM state_climate;
-- There are 4 columns; state, year, tempf, and tempc
-- I will focus on the tempc (average temperature for that year in Celsius).

-- Find the average temperaturn changes over time in each state
SELECT state,
  year,
  tempc,
  AVG(tempc) OVER (
    PARTITION BY state
    ORDER BY year
  ) AS 'running_avg_tempc'
FROM state_climate;

-- Find the lowest temperatures for each state by using the FIRST_VALUE() funtion
SELECT state,
  year,
  tempc,
  FIRST_VALUE (tempc) OVER (
    PARTITION BY state
    ORDER BY tempc
  ) AS 'lowest_temps'
FROM state_climate;
-- the lowest recorded temps for each state are more historic. 

-- Find the highest temperature for each state by using the LAST_VALUE() function
SELECT state,
  year,
  tempc,
  LAST_VALUE (tempc) OVER (
    PARTITION BY state
    ORDER BY tempc
    RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) AS 'highest_tempc'
FROM state_climate
ORDER BY 1, 3 DESC;
-- the highest recorded temps for each state are more recent.

-- Find how temperature has changed each year in each state.
SELECT state,
  year,
  tempc,
  tempc - LAG(tempc, 1, 0) OVER (
    ORDER BY year 
  ) change_in_temp
FROM state_climate
ORDER BY ABS(change_in_temp) DESC;
-- Maine in 1907 has the largest changes in temperture of -16.824 
-- The east part of the US shows the largest yearly changed in temperature.

-- Rank the coldest temperatures on record 
-- Can use either the ROW_NUMBER() or RANK() functions
SELECT ROW_NUMBER() OVER ( 
  ORDER BY tempc
) coldest_rank,
  year,
  state,
  tempc
FROM state_climate
LIMIT 1;
-- The coldest temperature on record is 1.61 in North Dakota in 1950. 

-- Rank the warmest temperatures for each state
SELECT RANK() OVER (
  PARTITION BY state 
  ORDER BY tempc DESC
) warmest_rank,
  year,
  state,
  tempc
FROM state_climate
ORDER BY 1;

-- Find the average yearly temperatures in quartiles instead of in rankings for each state.
SELECT 
  NTILE(4) OVER (
    PARTITION BY state
    ORDER BY tempc
  ) quartile_tempc,
  year,
  state,
  tempc
FROM state_climate;

-- Find the average overall yearly temperatures in quintiles (5).
SELECT 
  NTILE(5) OVER (
    ORDER BY tempc
  ) quintile_temp,
  year,
  state,
  tempc
FROM state_climate;
































