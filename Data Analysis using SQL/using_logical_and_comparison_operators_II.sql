SELECT
	Country_name,
    Time_period,
    Pct_managed_drinking_water_services,
    Pct_managed_sanitation_services,
    Est_gdp_in_billions,
    Region
FROM access_to_basic_services
WHERE 
	Region = 'Sub-Saharan Africa'
    AND Time_period = 2020
    AND Est_gdp_in_billions IS NOT NULL
    AND Country_name NOT IN ('Nigeria', 'South Africa', 'Ethiopia', 'Kenya', 'Ghana');