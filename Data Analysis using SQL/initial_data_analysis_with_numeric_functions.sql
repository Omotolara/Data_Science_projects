USE united_nations;

SELECT
	COUNT(*) AS Number_of_observations,
    MIN(Time_period) AS MIN_time_period,
    MAX(Time_period) AS MAX_time_period,
    COUNT(DISTINCT Country_name) AS Number_of_countries,
    AVG(Pct_managed_drinking_water_services) AS AVG_managed_drinking_water_services
    FROM access_to_basic_services;