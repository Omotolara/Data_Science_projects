SELECT DISTINCT
	Country_name,
    Time_period,
    Est_population_in_millions,
    CONCAT(
		SUBSTRING(IFNULL(UPPER(Country_name), 'UNKNOWN'), 1, 4),
        SUBSTRING(IFNULL(Time_period, 'UNKNOWN'), 1, 4),
        SUBSTRING(IFNULL(Est_population_in_millions, 'UNKNOWN'), -7)
	) AS Country_id
FROM access_to_basic_services;