USE md_water_services;

-- Cleaning our Data: Creating employees' email addresses
SELECT
	CONCAT(
		LOWER(REPLACE(employee_name, ' ', '.')), '@ndogowater.gov'
	) AS new_email
FROM employee;

-- Modify emails in original table
SET SQL_SAFE_UPDATES = 0;
UPDATE employee
SET email = CONCAT(
		LOWER(REPLACE(employee_name, ' ', '.')), '@ndogowater.gov'
	);
    
-- Check the length of phone number
SELECT
	LENGTH(phone_number)
FROM employee;

-- Remove the space at the end of he phone number
SELECT
	TRIM(phone_number)
FROM employee;

-- Correct the phone number records in the original table
UPDATE employee
SET phone_number = TRIM(phone_number);

-- Honouring the workers: Count of employees in each town
SELECT
	town_name,
    COUNT(assigned_employee_id) AS number_of_employees_per_town
FROM employee
GROUP BY town_name;

-- Top 3 field employees with the highest number of locations visited
SELECT
	assigned_employee_id,
    COUNT(visit_count) AS number_of_visits
FROM visits
GROUP BY assigned_employee_id
ORDER BY number_of_visits DESC
LIMIT 3; -- They are employees with ids: 1, 30, and 34

-- Info of the top 3 employees deserving honour
SELECT
	employee_name,
    email,
    phone_number
FROM employee
WHERE assigned_employee_id IN (1, 30, 34);

-- Analysing Locations: Number of records per town
SELECT
	town_name,
    COUNT(*) AS record_per_town
FROM location
GROUP BY town_name;

-- Records per province
SELECT
	province_name,
    COUNT(*) AS record_per_town
FROM location
GROUP BY province_name;

-- Count of records by province and town
SELECT
	province_name,
    town_name,
    COUNT(*) AS records_per_town
FROM location
GROUP BY province_name, town_name
ORDER BY province_name, records_per_town DESC;

-- Records per location type
SELECT
	location_type,
    COUNT(*) AS records_per_location_type
FROM location
GROUP BY location_type;

-- Percentage of water sources that are from the rural communities
SELECT 23740 / (15910 + 23740) * 100 AS pct_rural_water_sources;
/* INSIGHTS:
1. Our entire country was properly canvassed, and our dataset represents the situation on the ground.
2. 60% of our water sources are in rural communities across Maji Ndogo. We need to keep this in mind when we make decisions.
*/

-- Diving into the sources: Total number of people surveyed
SELECT
	SUM(number_of_people_served) as Number_of_people
FROM water_source;

-- Count of each of the different water source types
SELECT DISTINCT
	type_of_water_source,
    COUNT(type_of_water_source) AS number_of_source
FROM water_source
GROUP BY type_of_water_source
ORDER BY number_of_source DESC;

-- Average number of people served by each water source type
SELECT
	type_of_water_source,
    ROUND(AVG(number_of_people_served)) AS average_people_per_source
FROM water_source
GROUP BY type_of_water_source;

-- Number of people served by each water source type in total.
SELECT
	type_of_water_source,
    SUM(number_of_people_served) AS population_served
FROM water_source
GROUP BY type_of_water_source
ORDER BY population_served DESC;

-- Percentage of people served by each water source type in total.
SELECT
	type_of_water_source,
    ROUND((SUM(number_of_people_served) / 27628140) * 100) AS percentage_people_per_source
FROM water_source
GROUP BY type_of_water_source
ORDER BY percentage_people_per_source DESC;

-- Start of a solution: Rank of water source type based on people served
SELECT
	type_of_water_source,
    SUM(number_of_people_served) AS people_served,
    RANK() OVER (
		ORDER BY SUM(number_of_people_served) DESC) AS rank_by_population
FROM water_source
GROUP BY type_of_water_source;

-- Rank of most used source types
SELECT
	source_id,
    type_of_water_source,
    SUM(number_of_people_served) AS people_served,
    RANK() OVER (
		PARTITION BY type_of_water_source
        ORDER BY SUM(number_of_people_served)) AS priority_rank
FROM water_source
WHERE type_of_water_source <> 'tap_in_home'
GROUP BY source_id, type_of_water_source;

-- Using DENSE_RANK()
SELECT
	source_id,
    type_of_water_source,
    SUM(number_of_people_served) AS people_served,
    DENSE_RANK() OVER (
		PARTITION BY type_of_water_source
        ORDER BY SUM(number_of_people_served)) AS priority_rank
FROM water_source
WHERE type_of_water_source <> 'tap_in_home'
GROUP BY source_id, type_of_water_source;

-- Using ROW_NUMBER()
SELECT
	source_id,
    type_of_water_source,
    SUM(number_of_people_served) AS people_served,
    ROW_NUMBER() OVER (
		PARTITION BY type_of_water_source
        ORDER BY SUM(number_of_people_served)) AS priority_rank
FROM water_source
WHERE type_of_water_source <> 'tap_in_home'
GROUP BY source_id, type_of_water_source;

-- Analysing queues: The duration of the survey.
SELECT 
	DATEDIFF(MAX(time_of_record), MIN(time_of_record)) AS survey_duration
FROM visits;

-- Average queue time for water in Maji Ndogo
SELECT
	AVG(NULLIF(time_in_queue, 0)) AS average_queue_time
FROM visits;

-- Total queue time across different days of the week
SELECT
	DAYNAME(time_of_record) AS day_of_the_week,
    ROUND(AVG(time_in_queue)) AS average_queue_time
FROM visits
GROUP BY DAYNAME(time_of_record);

-- Average queue time per hour of the day.
SELECT
	TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_the_day,
    ROUND(AVG(time_in_queue)) AS average_queue_time
FROM visits
GROUP BY TIME_FORMAT(TIME(time_of_record), '%H:00')
ORDER BY average_queue_time DESC;

-- Queue times for each hour per day.
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