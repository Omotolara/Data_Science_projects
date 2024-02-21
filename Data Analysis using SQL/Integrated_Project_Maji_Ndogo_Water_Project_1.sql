USE md_water_services;

-- Get to know our data: Exploring the tables in our db 
SHOW TABLES;

-- Exploring data in the `location` table
SELECT 
	*
FROM location
LIMIT 10;

-- Exploring data in the `visits` table
SELECT 
	*
FROM visits
LIMIT 10;

-- Exploring data in the `water_source` table
SELECT 
	*
FROM water_source
LIMIT 10;

-- Dive into sources: to retrieve unique types of water sources. 
SELECT DISTINCT
	type_of_water_source
FROM water_source;

-- Unpack the visits: Retrieves all records where the `time_in_queue` is more than some crazy time, say 500mins.
SELECT 
	*
FROM visits
WHERE time_in_queue > 500; -- Imagine queueing 8hrs for water!

-- Check the records for these `source_id` to see which sources have people queueing.
SELECT 
	*
FROM water_source
WHERE
	source_id IN ('SoRu35083224', 'SoKo33124224', 'HaRu19601224', 'KiRu28935224', 'AkLu01628224');
 
-- Water source quality: Retrieving home tap source and other sources visited a second time.
SELECT
	*
FROM water_quality
WHERE
	subjective_quality_score = 10
    AND visit_count = 2;
    
-- Pollution Issues: Retrieving all records in the `well_pollution` table.
SELECT
	*
FROM well_pollution
LIMIT 5;

-- Investigating pollution issues to ascertion Scientists' recorded results.
SELECT
	*
FROM well_pollution
WHERE 
	results = "Clean"
    AND biological > 0.01;
    
-- Retrieving records with incorrect `description`
SELECT
	*
FROM well_pollution
WHERE 
	description LIKE "Clean_%";

-- Disable SQL safe update mode
SET SQL_SAFE_UPDATES = 0;

-- Creating a copy of `well_pollution` table.
CREATE TABLE 
	well_pollution_copy
AS (
	SELECT
		*
        FROM well_pollution
);

-- Correcting pollution data
UPDATE well_pollution_copy
SET description = "Bacteria: E. Coli"
WHERE
	description = "Clean Bacteria: E. Coli";
    
UPDATE well_pollution_copy
SET description = "Bacteria: Giardia Lamblia"
WHERE
	description = "Clean Bacteria: Giardia Lamblia";
    
UPDATE well_pollution_copy
SET results = "Contaminated: Biological"
WHERE
	biological > 0.01 
    AND results = "Clean";
    
-- Since the update went well, correct the pollution data in the original table.
UPDATE well_pollution
SET description = "Bacteria: E. Coli"
WHERE
	description = "Clean Bacteria: E. Coli";
    
UPDATE well_pollution
SET description = "Bacteria: Giardia Lamblia"
WHERE
	description = "Clean Bacteria: Giardia Lamblia";
    
UPDATE well_pollution
SET results = "Contaminated: Biological"
WHERE
	biological > 0.01 
    AND results = "Clean";
    
-- Delete the `well_pollution_copy` table.
DROP TABLE 
	well_pollution_copy;