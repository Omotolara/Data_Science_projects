CREATE VIEW Country_Unemployment_Rate AS
	SELECT
		Country_name,
		Time_period,
		IFNULL(Pct_unemployment, 33.65) AS Pct_unemployment_imputed
	FROM access_to_basic_services
	WHERE Region = 'Sub-Sahara Africa';