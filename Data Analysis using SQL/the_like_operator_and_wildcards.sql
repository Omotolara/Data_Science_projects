SELECT
	Country_name,
    Time_period,
    Pct_managed_drinking_water_services,
    Pct_managed_sanitation_services
FROM access_to_basic_services
WHERE
	Country_name LIKE "Iran%"
    OR Country_name LIKE "%_Republic of Korea";