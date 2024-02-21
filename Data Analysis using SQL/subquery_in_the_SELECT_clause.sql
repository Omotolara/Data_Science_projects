SELECT
	Country_name,
    ROUND(Land_area / (SELECT
			SUM(Land_area)
		FROM access_to_basic_services
		WHERE Sub_region = a.Sub_region
		) * 100
    ) AS pct_regional_land
FROM access_to_basic_services a;