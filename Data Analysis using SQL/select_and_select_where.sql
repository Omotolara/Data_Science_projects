SELECT 
	Country_name,
    Time_period,
    Pct_managed_drinking_water_services AS pct_access_to_water
FROM access_to_basic_services
WHERE 
	Time_period = 2020;