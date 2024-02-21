SELECT
	Country_name,
    Time_period,
    Pct_managed_drinking_water_services,
    RANK() OVER(
		PARTITION BY Time_period
        ORDER BY Pct_managed_drinking_water_services) AS Rank_of_water_services
FROM access_to_basic_services;