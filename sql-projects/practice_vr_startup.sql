/* Project: VR Startup Company
Source: codecademy.com

Codecademy Virtual Reality (CVR), Inc. is the latest startup on the VR scene. As head of the Project Completion team, you have been given a list of upcoming projects needing to be delivered. Your main responsibility is to analyze our current talent pool to ensure each project can be completed efficiently and effectively.

Each project needs a Project Manager, Team Lead, Designer, Database Administrator (DBA), and at least two Developers.

There are 2 tables in this project: employees and projects
*/
-- Preview the data
SELECT * 
FROM employees;

SELECT * 
FROM projects;

-- What are the names of employees who have not chosen a project?
SELECT first_name || ' ' || last_name AS full_name,
  current_project
FROM employees
WHERE current_project IS NULL;

-- to count (optional)
SELECT COUNT(*)
FROM employees
WHERE current_project IS NULL;
-- There are 3 employees who have not chosen a project.

-- What are the names of projects that were not chosen by any employees?
SELECT *
FROM projects
LEFT JOIN employees
  ON projects.project_id = employees.current_project
WHERE employee_id IS NULL
GROUP BY project_id;
-- OR
SELECT project_name
FROM projects
WHERE project_id NOT IN (
  SELECT current_project
  FROM employees
  WHERE current_project IS NOT NULL);
-- There are 3 projects that were not chosen by any employees, including CycleScenes, CarnivalCoasters, and SparkPoint.

-- What is the name of the project chosen by the most employees?
SELECT projects.project_id,
  projects.project_name,
  COUNT(*) number_of_employees
FROM employees
LEFT JOIN projects
 ON employees.current_project = projects.project_id
WHERE project_id IS NOT NULL
GROUP BY 1
ORDER BY 3 DESC
LIMIT 1;
-- OR using INNER JOIN
SELECT projects.project_id,
  projects.project_name,
  COUNT(*) number_of_employees
FROM projects
JOIN employees
  ON projects.project_id = employees.current_project
GROUP BY 1
ORDER BY 3 DESC
LIMIT 1;
-- The project chosen by the most employees is FistsOfFury.

-- Which projects were chosen by multiple employees?
SELECT projects.project_name,
  COUNT(*) number_of_employees
FROM projects
JOIN employees
  ON projects.project_id = employees.current_project
GROUP BY 1
HAVING number_of_employees > 1;
-- There are 3 projects that were chosen by multiple employees: ExtremeJets, ExtremeJets, and RocketRush.	

/*When employees are hired at CVR, they are given the Myers-Briggs personality test. We try to diminish tension among team members by creating teams based on compatible personalities.
*/
-- Which personality is the most common across our employees?
SELECT personality,
  COUNT(*)
FROM employees
GROUP BY 1
ORDER BY 2 DESC;
-- The most common personality is ENFJ.

-- What are the names of projects chosen by employees with the most common personality type?
-- As we have already known that the most common personality type is ENFJ
WITH enfj_employees AS (
  SELECT *
FROM employees
WHERE personality = 'ENFJ'
)
SELECT projects.project_name,
  COUNT(*)
FROm projects
JOIN enfj_employees enfj
  ON projects.project_id = enfj.current_project
GROUP BY 1;
-- If we do not now the most common type
SELECT project_name,
  COUNT(*)
FROM projects
JOIN employees
  ON projects.project_id = employees.current_project
WHERE personality = (
  SELECT personality
  FROM employees
  GROUP BY 1
  ORDER BY COUNT(*) DESC)
GROUP BY 1;

-- Find the personality type most represented by employees with a selected project. What are names of those employees, the personality type, and the names of the project they’ve chosen?
SELECT employees.first_name || ' ' || employees.last_name full_name,
  employees.personality,
  project_name
FROM projects
JOIN employees
  ON projects.project_id = employees.current_project
WHERE personality = (
  SELECT personality
  FROM employees
  GROUP BY 1
  ORDER BY COUNT(*) DESC)
GROUP BY 1;

- For each employee, provide their name, personality, the names of any projects they’ve chosen, and the number of incompatible co-workers.
SELECT employees.first_name,
  employees.last_name,
  employees.personality,
  projects.project_name,
  CASE
    WHEN personality = 'INFP' THEN (
      SELECT COUNT(*)
      FROM employees
      WHERE personality IN ('ISFP', 'ESFP', 'ISTP', 'ESTP', 'ISFJ', 'ESFJ', 'ISTJ', 'ESTJ')
    )
    WHEN personality = 'ENFP' THEN (
      SELECT COUNT(*)
      FROM employees
      WHERE personality IN ('ISFP', 'ESFP', 'ISTP', 'ESTP', 'ISFJ', 'ESFJ', 'ISTJ', 'ESTJ')
    )
    WHEN personality = 'INFJ' THEN (
      SELECT COUNT(*)
      FROM employees
      WHERE personality IN ('ISFP', 'ESFP', 'ISTP', 'ESTP', 'ISFJ', 'ESFJ', 'ISTJ', 'ESTJ')
    )
     WHEN personality = 'ENFJ' THEN (
      SELECT COUNT(*)
      FROM employees
      WHERE personality IN ('ESFP', 'ISTP', 'ESTP', 'ISFJ', 'ESFJ', 'ISTJ', 'ESTJ')
    )
    WHEN personality = 'ISFP' THEN (
      SELECT COUNT(*)
      FROM employees
      WHERE personality IN ('INFP', 'ENFP','INFJ')
    )
    WHEN personality = 'ESFP' THEN (
      SELECT COUNT(*)
      FROM employees
      WHERE personality IN ('INFP', 'ENFP', 'INFJ', 'ENFJ')
    ) ELSE 0
    END 'incompatible co-worker'
FROM employees
LEFT JOIN projects
  ON employees.current_project = projects.project_id
WHERE project_name IS NOT NULL; -- This line is optional
