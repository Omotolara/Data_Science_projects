SELECT
	AVG(Est_gdp_in_billions)
FROM access_to_basic_services
WHERE Time_period = 2020;

SELECT
	Country_name,
    Time_period,
    Est_gdp_in_billions,
    Pct_managed_drinking_water_services
FROM access_to_basic_services
WHERE 
	Time_period = 2020
    AND Pct_managed_drinking_water_services < 90
    AND Est_gdp_in_billions > (
		SELECT
			AVG(Est_gdp_in_billions)
		FROM access_to_basic_services
		WHERE Time_period = 2020
    );