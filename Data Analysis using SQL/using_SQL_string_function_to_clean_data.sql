SELECT DISTINCT
	Country_name,
    LENGTH(Country_name) AS String_length,
    POSITION('(' IN Country_name) AS Pos_opening_bracket,
    RTRIM(LEFT(Country_name, POSITION('(' IN Country_name) - 1)) AS New_country_name,
    LENGTH(RTRIM(LEFT(Country_name, POSITION('(' IN Country_name) - 1))) AS New_country_name_length
FROM access_to_basic_services
WHERE
	Country_name LIKE "%(%)%";