CREATE TABLE Geographic_location(
	Country_name VARCHAR(37) PRIMARY KEY,
    Sub_region VARCHAR(25),
    Region VARCHAR(32),
    Land_area NUMERIC(10, 2)
);

INSERT INTO Geographic_location(Country_name, Sub_region, Region, Land_area)
SELECT
	Country_name,
    Sub_region,
    Region,
    AVG(Land_area) AS Country_area
FROM access_to_basic_services
GROUP BY
	Country_name,
    Sub_region,
    Region;