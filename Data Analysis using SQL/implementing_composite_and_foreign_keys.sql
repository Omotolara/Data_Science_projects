CREATE TABLE Basic_Services(
	Country_name VARCHAR(37),
    Time_Period INTEGER,
    Pct_managed_drinking_water_services NUMERIC(5, 2),
    Pct_managed_sanitation_services NUMERIC(5, 2),
    PRIMARY KEY (Country_name, Time_Period),
    FOREIGN KEY (Country_name) REFERENCES Geographic_location (Country_name)
);

INSERT INTO Basic_Services(Country_name, Time_Period, Pct_managed_drinking_water_services, Pct_managed_sanitation_services)
SELECT
	Country_name,
    Time_Period,
    Pct_managed_drinking_water_services,
    Pct_managed_sanitation_services
FROM access_to_basic_services;

CREATE TABLE Economic_Indicators(
	Country_name VARCHAR(37),
    Time_Period INTEGER,
    Est_gdp_in_billions NUMERIC(8, 2),
    Est_population_in_millions NUMERIC(11, 6),
    Pct_unemployment NUMERIC(5, 2),
    PRIMARY KEY (Country_name, Time_Period),
    FOREIGN KEY (Country_name) REFERENCES Geographic_location (Country_name)
);

INSERT INTO Economic_Indicators(Country_name, Time_Period, Est_gdp_in_billions, Est_population_in_millions, Pct_unemployment)
SELECT
	Country_name,
    Time_Period,
    Est_gdp_in_billions,
    Est_population_in_millions,
    Pct_unemployment
FROM access_to_basic_services;