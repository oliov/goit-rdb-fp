DROP SCHEMA IF EXISTS pandemic;

CREATE SCHEMA IF NOT EXISTS pandemic;

USE pandemic;

DROP TABLE IF EXISTS country;

CREATE TABLE IF NOT EXISTS country (
  country_id INT PRIMARY KEY AUTO_INCREMENT,
  country_name VARCHAR(255) UNIQUE NOT NULL,
  country_code VARCHAR(50)
);


INSERT INTO country (country_name, country_code) SELECT DISTINCT Entity, Code FROM infectious_cases;



DROP TABLE IF EXISTS country_infections;



CREATE TABLE IF NOT EXISTS country_infections (
  country_infections_id INT PRIMARY KEY AUTO_INCREMENT,
  country_id INT,
  year_field YEAR,
  Number_yaws VARCHAR(50) DEFAULT NULL,
  polio_cases INT DEFAULT NULL,
  cases_guinea_worm INT DEFAULT NULL,
  Number_rabies DOUBLE DEFAULT NULL,
  Number_malaria DOUBLE DEFAULT NULL,
  Number_hiv DOUBLE DEFAULT NULL,
  Number_tuberculosis DOUBLE DEFAULT NULL,
  Number_smallpox VARCHAR(50) DEFAULT NULL,
  Number_cholera_cases INT DEFAULT NULL,
  FOREIGN KEY (country_id) REFERENCES country (country_id)
);

INSERT INTO country_infections (country_id, year_field, Number_yaws, polio_cases,
cases_guinea_worm, Number_rabies, Number_malaria, Number_hiv, Number_tuberculosis, Number_smallpox,
Number_cholera_cases) 
SELECT (SELECT country_id FROM country WHERE infectious_cases.Entity = country_name), 
Year, Number_yaws, polio_cases,
cases_guinea_worm, Number_rabies, Number_malaria, Number_hiv, Number_tuberculosis, Number_smallpox,
Number_cholera_cases FROM infectious_cases;





SELECT  COUNT(*) FROM infectious_cases;
SELECT  COUNT(*) FROM country_infections;

SELECT (SELECT country_name FROM country WHERE country.country_id = country_infections.country_id) AS country,
(SELECT country_code FROM country WHERE country.country_id = country_infections.country_id) AS code,
AVG(Number_rabies) AS average,
MIN(Number_rabies) AS minimal,
MAX(Number_rabies) AS maximal,
SUM(Number_rabies) AS total
FROM country_infections
WHERE Number_rabies IS NOT NULL
GROUP BY country_id
ORDER BY average DESC
LIMIT 10;

SELECT MAKEDATE(year_field, 1) AS table_date, 
CURDATE() AS date_now, 
CAST(DATEDIFF(CURDATE(), MAKEDATE(year_field, 1)) / 365 AS INT) AS years_ago
FROM country_infections;

DROP FUNCTION IF EXISTS YEARSDIFF;

DELIMITER //

CREATE FUNCTION YEARSDIFF(year_field YEAR)
RETURNS INT
DETERMINISTIC 
NO SQL
BEGIN
    DECLARE result INT;
    SET result = CAST(DATEDIFF(CURDATE(), MAKEDATE(year_field, 1)) / 365 AS INT);
    RETURN result;
END //

DELIMITER ;

SELECT YEARSDIFF(year_field) FROM country_infections;

