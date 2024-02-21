USE md_water_services;

SELECT
	a.location_id,
    w.record_id,
    true_water_source_score AS auditor_score,
    subjective_quality_score AS employee_score
FROM auditor_report a
JOIN visits v
ON a.location_id = v.location_id
JOIN water_quality w
ON v.record_id = w.record_id
WHERE 
	true_water_source_score != subjective_quality_score
    AND v.visit_count = 1;

WITH Incorrect_Records AS(
	SELECT
		a.location_id,
		w.record_id,
		employee_name,
		true_water_source_score AS auditor_score,
		subjective_quality_score AS employee_score
	FROM auditor_report a
	JOIN visits v
	ON a.location_id = v.location_id
	JOIN employee e
	ON v.assigned_employee_id = e.assigned_employee_id
	JOIN water_quality w
	ON v.record_id = w.record_id
	WHERE 
		true_water_source_score != subjective_quality_score
		AND v.visit_count = 1
)

SELECT
	DISTINCT employee_name,
    COUNT(*) AS number_of_mistakes
FROM Incorrect_records
GROUP BY employee_name
ORDER BY number_of_mistakes DESC;

CREATE VIEW Incorrect_Records AS(
	SELECT
		a.location_id,
		w.record_id,
		employee_name,
		true_water_source_score AS auditor_score,
		subjective_quality_score AS employee_score,
        statements
	FROM auditor_report a
	JOIN visits v
	ON a.location_id = v.location_id
	JOIN employee e
	ON v.assigned_employee_id = e.assigned_employee_id
	JOIN water_quality w
	ON v.record_id = w.record_id
	WHERE 
		true_water_source_score != subjective_quality_score
		AND v.visit_count = 1
);

WITH error_count AS (
	SELECT
		DISTINCT employee_name,
		COUNT(*) AS number_of_mistakes
	FROM Incorrect_records
	GROUP BY employee_name
	ORDER BY number_of_mistakes DESC
)

SELECT
	employee_name,
	number_of_mistakes
FROM error_count
WHERE number_of_mistakes > (SELECT
								AVG(number_of_mistakes) AS Avg_number_of_mistakes
							FROM error_count
							);
                            
WITH error_count AS (
	SELECT
		DISTINCT employee_name,
		COUNT(*) AS number_of_mistakes
	FROM Incorrect_records
	GROUP BY employee_name
	ORDER BY number_of_mistakes DESC
),
suspect_list AS (
SELECT
	employee_name,
	number_of_mistakes
FROM error_count
WHERE number_of_mistakes > (SELECT
								AVG(number_of_mistakes) AS Avg_number_of_mistakes
							FROM error_count
							)
)

SELECT
	employee_name,
    location_id,
    statements
FROM Incorrect_records
WHERE employee_name IN (SELECT
							employee_name
						FROM suspect_list
                        )
	AND statements LIKE "%cash%";
    
WITH error_count AS (
	SELECT
		DISTINCT employee_name,
		COUNT(*) AS number_of_mistakes
	FROM Incorrect_records
	GROUP BY employee_name
	ORDER BY number_of_mistakes DESC
),
suspect_list AS (
SELECT
	employee_name,
	number_of_mistakes
FROM error_count
WHERE number_of_mistakes > (SELECT
								AVG(number_of_mistakes) AS Avg_number_of_mistakes
							FROM error_count
							)
)

SELECT
	employee_name,
    location_id,
    statements
FROM Incorrect_records
WHERE employee_name NOT IN (SELECT
							employee_name
						FROM suspect_list
                        )
	AND statements LIKE "%cash%";