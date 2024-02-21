SELECT
	Country_name,
    Time_period,
    Pct_managed_drinking_water_services,
    Pct_managed_sanitation_services,
    Est_population_in_millions,
    Est_gdp_in_billions
FROM access_to_basic_services
WHERE 
	Time_period = 2020
    AND Pct_managed_sanitation_services <= 50
    AND Pct_managed_drinking_water_services <= 50;