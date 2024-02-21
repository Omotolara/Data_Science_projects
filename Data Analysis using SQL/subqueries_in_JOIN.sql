SELECT
	Sub_region,
    SUM(Land_area) AS TotalLandArea
FROM access_to_basic_services
GROUP BY Sub_region;

SELECT
	bs.Country_name,
    bs.Land_area,
    bs.Sub_region,
    ROUND((bs.Land_area / land_per_region.TotalLandArea) * 100) AS PctOfRegionLand
FROM access_to_basic_services bs
JOIN (
	SELECT
		Sub_region,
		SUM(Land_area) AS TotalLandArea
	FROM access_to_basic_services
	GROUP BY Sub_region
) AS land_per_region
ON bs.Sub_region = land_per_region.Sub_region;