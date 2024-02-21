SELECT
	Country_name,
    Time_period,
    Pct_managed_drinking_water_services,
    LAG(Pct_managed_drinking_water_services, 1) OVER(
		PARTITION BY Country_name
        ORDER BY Time_period) AS Prev_year_pct_managed_drinking_water_services
FROM access_to_basic_services;

SELECT
	Country_name,
    Time_period,
    Pct_managed_drinking_water_services,
    LAG(Pct_managed_drinking_water_services, 1) OVER(
		PARTITION BY Country_name
        ORDER BY Time_period) AS Prev_year_pct_managed_drinking_water_services,
    Pct_managed_drinking_water_services - LAG(Pct_managed_drinking_water_services, 1) OVER(
		PARTITION BY Country_name
        ORDER BY Time_period) AS ARC_pct_managed_drinking_water_services
FROM access_to_basic_services;