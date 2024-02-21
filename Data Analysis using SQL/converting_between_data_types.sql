USE united_nations;

SELECT 
	Country_name,
    Time_period,
    CAST(Est_population_in_millions AS Decimal(6, 2)) AS Est_population_in_millions_2dp
FROM access_to_basic_services;