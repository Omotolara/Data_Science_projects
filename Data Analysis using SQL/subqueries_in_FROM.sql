SELECT
	Country_name,
    Est_gdp_in_billions,
    Est_population_in_millions
FROM access_to_basic_services
WHERE
	Pct_unemployment > 5
    AND Time_period = 2020;
    
SELECT
	Country_name,
    AVG(Est_gdp_in_billions) AS Avg_GDP,
    AVG(Est_population_in_millions) AS Avg_population
FROM (
	SELECT
		Country_name,
		Est_gdp_in_billions,
		Est_population_in_millions
	FROM access_to_basic_services
	WHERE
		Pct_unemployment > 5
		AND Time_period = 2020
) AS FilteredCountries
GROUP BY Country_name;