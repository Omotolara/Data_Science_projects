USE united_nations;

SELECT
	Region,
    Sub_region,
	MIN(Time_period) AS MIN_time_period,
    MAX(Time_period) AS MAX_time_period,
    AVG(Pct_managed_drinking_water_services) AS AVG_managed_drinking_water_services,
    COUNT(DISTINCT Country_name) AS Number_of_countries,
    SUM(Est_gdp_in_billions) AS EST_total_gdp_in_billions
    FROM access_to_basic_services
    GROUP BY Region, Sub_region 
    ORDER BY EST_total_gdp_in_billions;