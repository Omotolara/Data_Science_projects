-- Q1: Which SQL query will produce the date format "DD Month YYYY" from the time_of_record column in the visits table, as a single column? 
SELECT 
	CONCAT(day(time_of_record), 
		" ", 
        monthname(time_of_record), 
        " ", 
        year(time_of_record)
	) AS new_time_of_record
FROM visits;

-- You are working with an SQL query designed to calculate the Annual Rate of Change (ARC) for basic rural water services:
-- To accomplish this task, what should you use for placeholders (a) and (b)?
SELECT
	name,
    year,
    wat_bas_r,
	wat_bas_r - LAG(wat_bas_r) OVER (PARTITION BY name ORDER BY year) AS ARC
FROM global_water_access
ORDER BY name;

-- Q3: What are the names of the two worst-performing employees who visited the fewest sites, and how many sites did the worst-performing employee visit?
SELECT
	assigned_employee_id,
    COUNT(visit_count) AS number_of_visits
FROM visits
GROUP BY assigned_employee_id
ORDER BY number_of_visits
LIMIT 2;
SELECT
	assigned_employee_id,
    employee_name,
    email,
    phone_number
FROM employee
WHERE assigned_employee_id IN (20, 22);

-- Q4: What does the following query do?
SELECT 
    location_id,
    time_in_queue,
    AVG(time_in_queue) OVER (PARTITION BY location_id ORDER BY visit_count) AS total_avg_queue_time
FROM visits
WHERE visit_count > 1 -- Only shared taps were visited > 1
ORDER BY location_id, time_of_record;

-- Q5: One of our employees, Farai Nia, lives at 33 Angelique Kidjo Avenue. What would be the result if we TRIM() her address?
-- TRIM('33 Angelique Kidjo Avenue  ') 

-- Q6: How many employees live in Dahabu?
SELECT
	town_name,
    COUNT(assigned_employee_id) AS number_of_employees_per_town
FROM employee
WHERE town_name = 'Dahabu'
GROUP BY town_name;

-- Q7: How many employees live in Harare, Kilimani?
SELECT
	town_name,
    province_name,
    COUNT(assigned_employee_id) AS number_of_employees_per_town
FROM employee
WHERE
	town_name = 'Harare'
    AND province_name = 'Kilimani'
GROUP BY town_name, province_name;

-- Q8: How many people share a well on average? Round your answer to 0 decimals.
SELECT
	type_of_water_source,
    ROUND(AVG(number_of_people_served)) AS average_people_per_source
FROM water_source
GROUP BY type_of_water_source;

-- Q9: Consider the query we used to calculate the total number of people served by each water source:
-- Which of the following lines of code will calculate the total number of people using some sort of tap?
SELECT
	type_of_water_source,
	SUM(number_of_people_served) AS population_served
FROM water_source
WHERE type_of_water_source LIKE "%tap%"
GROUP BY type_of_water_source
ORDER BY population_served DESC;

/* Q10: Use the pivot table we created to answer the following question. What are the average queue times for the following times?
Saturday from 12:00 to 13:00
Tuesday from 18:00 to 19:00
Sunday from 09:00 to 10:00
*/
SELECT
	TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day,
	-- Sunday
	ROUND(AVG(
		CASE
		WHEN DAYNAME(time_of_record) = 'Sunday'
			THEN time_in_queue
		ELSE NULL
		END
	),0) AS Sunday,
	-- Monday
	ROUND(AVG(
		CASE
		WHEN DAYNAME(time_of_record) = 'Monday' 
			THEN time_in_queue
		ELSE NULL
		END
	),0) AS Monday,
	-- Tuesday
    ROUND(AVG(
		CASE
		WHEN DAYNAME(time_of_record) = 'Tuesday' 
			THEN time_in_queue
		ELSE NULL
		END
	),0) AS Tuesday,
	-- Wednesday
    ROUND(AVG(
		CASE
		WHEN DAYNAME(time_of_record) = 'Wednesday' 
			THEN time_in_queue
		ELSE NULL
		END
	),0) AS Wednesday,
    -- Thursday
    ROUND(AVG(
		CASE
		WHEN DAYNAME(time_of_record) = 'Thursday' 
			THEN time_in_queue
		ELSE NULL
		END
	),0) AS Thursday,
    -- Friday
    ROUND(AVG(
		CASE
		WHEN DAYNAME(time_of_record) = 'Friday' 
			THEN time_in_queue
		ELSE NULL
		END
	),0) AS Friday,
    -- Saturday
    ROUND(AVG(
		CASE
		WHEN DAYNAME(time_of_record) = 'Saturday' 
			THEN time_in_queue
		ELSE NULL
		END
	),0) AS Saturday
FROM visits
WHERE time_in_queue != 0
GROUP BY hour_of_day
ORDER BY hour_of_day;