-- Q1: What is the address of Bello Azibo?
SELECT 
	address
FROM employee
WHERE employee_name = "Bello Azibo";

-- Q2: What is the name and phone number of our Microbiologist?
SELECT 
	employee_name,
    phone_number,
    position
FROM employee
WHERE position LIKE "Micro%";

-- Q3: What is the source_id of the water source shared by the most number of people?
SELECT 
	*
FROM water_source
WHERE source_id = 'AmAs10911224'
OR source_id = 'AkRu04862224'
OR source_id = 'AkHa00036224'
OR source_id = 'AkRu05603224';

-- Q4: What is the population of Maji Ndogo? 
SELECT
	*
FROM data_dictionary
WHERE description LIKE "%population%";
SELECT 
	pop_n
FROM global_water_access
WHERE name = "Maji Ndogo";

-- Q5: Which SQL query returns records of employees who are Civil Engineers residing in Dahabu or living on an avenue?
SELECT 
	*
FROM employee
WHERE 
	position = 'Civil Engineer' 
    AND (
		province_name = 'Dahabu' 
        OR address LIKE '%Avenue%'
	);
    
/* Q6: Create a query to identify potentially suspicious field workers based on an anonymous tip. This is the description we are given:

The employee’s phone number contained the digits 86 or 11. 
The employee’s last name started with either an A or an M. 
The employee was a Field Surveyor.
Which option is correct? */
SELECT
	*
FROM employee
WHERE 
	(phone_number LIKE "%86%" OR phone_number LIKE "%11%")
    AND (employee_name LIKE "%_A%" OR employee_name LIKE "%_M%")
    AND (position = "Field Surveyor");
    
-- Q7: What is the result of the following query? Choose the most appropriate description of the results set.
SELECT 
	*
FROM well_pollution
WHERE 
	description LIKE 'Clean_%' 
    OR results = 'Clean' 
    AND biological < 0.01;
    
-- Q8: Which query will identify the records with a quality score of 10, visited more than once?
SELECT 
	*
FROM water_quality
WHERE 
	visit_count >= 2 
    AND subjective_quality_score = 10;
    
/* Q9: You have been given a task to correct the phone number for the employee named 'Bello Azibo'. 
The correct number is +99643864786. Write the SQL query to accomplish this. */
UPDATE employee
SET phone_number = '+99643864786'
WHERE employee_name = 'Bello Azibo';

-- Q10: How many rows of data are returned for the following query?
SELECT 
	* 
FROM well_pollution
WHERE 
	description IN ('Parasite: Cryptosporidium', 'biologically contaminated')
	OR (results = 'Clean' AND biological > 0.01);