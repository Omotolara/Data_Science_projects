SELECT
	Country_name,
    Time_period,
    ROUND(Est_gdp_in_billions) AS Rounded_est_gdp_in_billions,
    LOG(Est_gdp_in_billions) AS Log_est_gdp_in_billions,
    SQRT(Est_gdp_in_billions) AS SQRT_est_gdp_in_billions
FROM access_to_basic_services;