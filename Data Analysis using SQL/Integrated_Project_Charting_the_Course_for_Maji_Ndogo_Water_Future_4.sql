USE md_water_services;

CREATE VIEW combined_analysis_table AS
SELECT
	type_of_water_source,
    town_name,
    province_name,
    location_type,
    number_of_people_served,
    time_in_queue,
    results
FROM location l
JOIN visits v
ON l.location_id = v.location_id
LEFT JOIN well_pollution wp
ON v.source_id = wp.source_id
JOIN water_source w
ON v.source_id = w.source_id
WHERE 
	visit_count = 1;
    
WITH province_totals AS (-- This CTE calculates the population of each province
	SELECT
		province_name,
		SUM(number_of_people_served) AS total_ppl_serv
	FROM combined_analysis_table
	GROUP BY province_name
)

SELECT
	ct.province_name,
-- These case statements create columns for each type of source.
-- The results are aggregated and percentages are calculated
	ROUND((SUM(
		CASE 
			WHEN type_of_water_source = 'river'
				THEN number_of_people_served 
			ELSE 0 
		END
		) * 100.0 / pt.total_ppl_serv
	), 0) AS river,
	ROUND((SUM(
		CASE 
			WHEN type_of_water_source = 'shared_tap'
				THEN number_of_people_served 
			ELSE 0 
		END
        ) * 100.0 / pt.total_ppl_serv
	), 0) AS shared_tap,
	ROUND((SUM(
		CASE 
			WHEN type_of_water_source = 'tap_in_home'
				THEN number_of_people_served 
			ELSE 0 
		END
        ) * 100.0 / pt.total_ppl_serv
	), 0) AS tap_in_home,
	ROUND((SUM(
		CASE 
			WHEN type_of_water_source = 'tap_in_home_broken'
				THEN number_of_people_served 
			ELSE 0 
		END
        ) * 100.0 / pt.total_ppl_serv
	), 0) AS tap_in_home_broken,
	ROUND((SUM(
		CASE 
			WHEN type_of_water_source = 'well'
				THEN number_of_people_served 
			ELSE 0 
		END
        ) * 100.0 / pt.total_ppl_serv
	), 0) AS well
FROM combined_analysis_table ct
JOIN province_totals pt
ON ct.province_name = pt.province_name
GROUP BY ct.province_name
ORDER BY ct.province_name;

CREATE TEMPORARY TABLE town_aggregated_water_access
WITH town_totals AS (-- This CTE calculates the population of each province
-- Since there are two Harare towns, we have to group by province_name and town_name
	SELECT
		province_name,
        town_name,
		SUM(number_of_people_served) AS total_ppl_serv
	FROM combined_analysis_table
	GROUP BY province_name, town_name
)

SELECT
	ct.province_name,
    ct.town_name,
-- These case statements create columns for each type of source.
-- The results are aggregated and percentages are calculated
	ROUND((SUM(
		CASE 
			WHEN type_of_water_source = 'river'
				THEN number_of_people_served 
			ELSE 0 
		END
		) * 100.0 / tt.total_ppl_serv
	), 0) AS river,
	ROUND((SUM(
		CASE 
			WHEN type_of_water_source = 'shared_tap'
				THEN number_of_people_served 
			ELSE 0 
		END
        ) * 100.0 / tt.total_ppl_serv
	), 0) AS shared_tap,
	ROUND((SUM(
		CASE 
			WHEN type_of_water_source = 'tap_in_home'
				THEN number_of_people_served 
			ELSE 0 
		END
        ) * 100.0 / tt.total_ppl_serv
	), 0) AS tap_in_home,
	ROUND((SUM(
		CASE 
			WHEN type_of_water_source = 'tap_in_home_broken'
				THEN number_of_people_served 
			ELSE 0 
		END
        ) * 100.0 / tt.total_ppl_serv
	), 0) AS tap_in_home_broken,
	ROUND((SUM(
		CASE 
			WHEN type_of_water_source = 'well'
				THEN number_of_people_served 
			ELSE 0 
		END
        ) * 100.0 / tt.total_ppl_serv
	), 0) AS well
FROM combined_analysis_table ct
JOIN town_totals tt
ON 
	ct.province_name = tt.province_name
    AND ct.town_name = tt.town_name
GROUP BY ct.province_name, ct.town_name
ORDER BY ct.province_name;

SELECT
	province_name,
	town_name,
	ROUND(tap_in_home_broken / (tap_in_home_broken + tap_in_home) * 100,0) AS Pct_broken_taps
FROM town_aggregated_water_access;

CREATE TABLE Project_progress (
	Project_id SERIAL PRIMARY KEY,
	source_id VARCHAR(20) NOT NULL REFERENCES water_source(source_id) ON DELETE CASCADE ON UPDATE CASCADE,
	Address VARCHAR(50),
	Town VARCHAR(30),
	Province VARCHAR(30),
	Source_type VARCHAR(50),
	Improvement VARCHAR(50),
	Source_status VARCHAR(50) DEFAULT 'Backlog' CHECK (Source_status IN ('Backlog', 'In progress', 'Complete')),
	Date_of_completion DATE,
	Comments TEXT
);

INSERT INTO project_progress (source_id, Address, Town, Province, Source_type, Improvement)
SELECT
	ws.source_id,
    l.address,
	l.town_name,
	l.province_name,
	ws.type_of_water_source,
    CASE
		WHEN wp.results = 'Contaminated: Biological'
			THEN 'Install UV filter'
		WHEN wp.results = 'Contaminated: Chemical'
			THEN 'Install RO filter'
		WHEN ws.type_of_water_source= 'river'
			THEN 'Drill well'
		WHEN ws.type_of_water_source= 'shared_tap' AND v.time_in_queue >= 30
			THEN CONCAT('Install', FLOOR(v.time_in_queue / 30), 'taps nearby')
		WHEN ws.type_of_water_source= 'tap_in_home_broken'
			THEN 'Diagnose local infrastructure'
		ELSE NULL
	END AS Improvement
FROM water_source ws
LEFT JOIN well_pollution wp
ON ws.source_id = wp.source_id
INNER JOIN visits v
ON ws.source_id = v.source_id
INNER JOIN location l
ON v.location_id = l.location_id
WHERE 
	v.visit_count = 1
    AND (
		(ws.type_of_water_source = 'shared tap' AND v.time_in_queue >= 30)
        OR (wp.results != 'Clean')
        OR ws.type_of_water_source IN ('river', 'tap_in_home_broken')
    );