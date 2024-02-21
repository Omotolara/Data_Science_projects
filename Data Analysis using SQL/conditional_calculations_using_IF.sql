USE united_nations;

SELECT
	Region,
    Pct_unemployment,
    IF(
		(Region = 'Central and Southern Asia') AND (Pct_unemployment IS NULL), 19.59,
        IF(
			(Region = 'Eastern and South-Eastern Asia') AND (Pct_unemployment IS NULL), 22.64, 
            IF(
				(Region = 'Europe and North America') AND (Pct_unemployment IS NULL), 24.43,
                IF(
					(Region = 'Latin America and the Caribbean') AND (Pct_unemployment IS NULL), 24.23,
                    IF(
						(Region = 'Northern Africa and Western Asia') AND (Pct_unemployment IS NULL), 17.84,
                        IF(
							(Region = 'Oceania') AND (Pct_unemployment IS NULL), 4.98,
                            IF(
								(Region = 'Sub-Saharan Africa') AND (Pct_unemployment IS NULL), 33.65,
                            Pct_unemployment
                            )
						)
					)
				)
			)
		)
	) AS New_pct_unemployment
FROM access_to_basic_services;