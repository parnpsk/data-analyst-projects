/* Project: World Populations SQL Practice I & II - SQLite
Source: codeacademy

Objective: You’ll work with a dataset of world population by country data from recent years. You’ll write queries to retrieve interesting data and answer a set of specific questions.


The population_year table with 2,354 rows and the countries table with 214 rows

*/
-- Preview the data
SELECT *
FROM population_years
LIMIT 10;

SELECT *
FROM countries
LIMIT 5;

-- What years are covered by the dataset? (you can manually count the number of years returned).
SELECT DISTINCT(year)
FROM population_years;
-- between 2000 - 2010

-- What is the largest population size for Gabon in this dataset?
SELECT *
FROM population_years
WHERE country = 'Gabon'
ORDER BY population DESC;
-- The largest population size of Gabon is 1.54526 million on 2010

-- What were the 10 lowest-population countries in 2005?
SELECT *
FROM population_years
WHERE year = '2005'
ORDER BY population ASC
LIMIT 10;

-- What are all the distinct countries with a population of over 100 million in 2010?
SELECT *  -- or SELECT DISTINCT(country)
FROM population_years
WHERE year = '2010'
  AND population > 100
ORDER BY population DESC;

-- How many countries in this dataset have the word “Islands” in their name?
SELECT COUNT(DISTINCT(country)) AS country
FROM population_years
WHERE country LIKE '%Islands%';
-- There are 9 countries: Cayman Islands, Falkland Islands (Islas Malvinas), Turks and Caicos Islands, Virgin Islands-U.S., Virgin Islands-British, Faroe Islands, Cook Islands, Solomon Islands, U.S. Pacific Islands

-- What is the difference in population between 2000 and 2010 in Indonesia?
SELECT *
FROM population_years
WHERE country = 'Indonesia'
  AND year IN ('2000', '2010');
-- SELECT 242.96834 - 214.67661;
-- The difference is 28.29173 million.

-- How many entries in the countries table are from Africa?
SELECT COUNT(DISTINCT(name))
FROM countries
WHERE continent = 'Africa';
-- There are 56 African countries

-- What was the total population of the continent of Oceania in 2005?
SELECT ROUND(SUM(pop.population), 2) AS total_pop_oceania_2005
FROM population_years pop
JOIN countries
  ON pop.country_id = countries.id
WHERE countries.continent = 'Oceania'
  AND pop.year = '2005';
-- 32.66 million

-- What was the average population of countries in South America in 2003?
SELECT ROUND(AVG(pop.population),2) AS avg_pop_south_af_2003
FROM population_years pop
JOIN countries
  ON pop.country_id = countries.id
WHERE countries.continent = 'South America'
  AND pop.year = '2003';
-- 25.89 million

-- What country had the smallest population in 2007?
SELECT countries.name,
  pop.population
FROM population_years pop
JOIN countries
  ON pop.country_id = countries.id
WHERE pop.year = '2007'
  AND pop.population IS NOT NULL   -- the population of Former Serbia and Montenegro is null
ORDER BY pop.population ASC
LIMIT 1;
-- Niue has the smallest population in 2007.

-- What is the average population of Poland during the time period covered by this dataset?
SELECT countries.name,
  ROUND(AVG(pop.population),2) AS avg_pop_poland
FROM population_years pop
JOIN countries
  ON pop.country_id = countries.id
WHERE countries.name = 'Poland';
-- 38.56 million

-- How many countries have the word “The” in their name?
SELECT COUNT(DISTINCT(name))
FROM countries
WHERE name LIKE '%The' 
  OR name LIKE 'The%';  -- cannot use name LIKE '%The%' as it includes Netherlands
-- There are 2 countries
-- (option) to check the names
SELECT name
FROM countries
WHERE name LIKE '%The' 
  OR name LIKE 'The%'; 

-- What was the total population of each continent in 2010?
SELECT countries.continent,
  ROUND(SUM(pop.population),2) AS population
FROM population_years pop
JOIN countries
  ON pop.country_id = countries.id
WHERE pop.year = '2010'
GROUP BY 1
ORDER BY 2 DESC;


