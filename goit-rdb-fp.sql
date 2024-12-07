-- 1

CREATE SCHEMA  IF NOT EXISTS pandemic;

USE pandemic;

SELECT * FROM infectious_cases
LIMIT 30;

-- 2

CREATE TABLE IF NOT EXISTS countries (
	id INT AUTO_INCREMENT PRIMARY KEY,
    country_code VARCHAR(20) NOT NULL,
    country_name VARCHAR(50) NOT NULL);
    
CREATE TABLE IF NOT EXISTS infectious_cases_norm (
	id INT AUTO_INCREMENT PRIMARY KEY,
    country_id INT NOT NULL,
    year INT NOT NULL,
    number_yaws TEXT,
	polio_cases TEXT,
	cases_guinea_worm TEXT,
	number_rabies TEXT,
	number_malaria TEXT,
	number_hiv TEXT,
	number_tuberculosis TEXT,
	number_smallpox TEXT,
	number_cholera_cases TEXT,
    FOREIGN KEY (country_id) REFERENCES countries (id));
    
    
INSERT INTO countries (country_code, country_name)
SELECT DISTINCT code, entity FROM infectious_cases
WHERE code IS NOT NULL AND CODE != '';
    
INSERT INTO infectious_cases_norm (
    country_id, 
    year, 
    number_yaws, 
    polio_cases, 
    cases_guinea_worm, 
    number_rabies, 
    number_malaria, 
    number_hiv, 
    number_tuberculosis, 
    number_smallpox, 
    number_cholera_cases
)
SELECT 
    c.id, 
    ic.year, 
    ic.number_yaws, 
    ic.polio_cases, 
    ic.cases_guinea_worm, 
    ic.number_rabies, 
    ic.number_malaria, 
    ic.number_hiv, 
    ic.number_tuberculosis, 
    ic.number_smallpox, 
    ic.number_cholera_cases
FROM infectious_cases AS ic 
INNER JOIN countries AS c ON (ic.code = c.country_code AND ic.entity = c.country_name);
    
-- 3   

SELECT ic.country_id, c.country_name,
	AVG(number_rabies) AS average,
    MIN(number_rabies) AS minimum,
    MAX(number_rabies) AS maximum,
    SUM(number_rabies) AS summa
FROM infectious_cases_norm AS ic
JOIN countries AS c ON(ic.country_id = c.id)
WHERE number_rabies != ''
GROUP BY ic.country_id, c.country_name
ORDER BY average DESC
LIMIT 10;

-- 4 

SELECT 
	MAKEDATE(year, 1) AS date_,
	CURDATE() AS current_date_,
    TIMESTAMPDIFF(year, MAKEDATE(year, 1), CURDATE()) AS date_diff
FROM infectious_cases_norm;

-- 5

DROP FUNCTION IF EXISTS year_difference;

DELIMITER //
CREATE FUNCTION year_difference(input_year INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE date_from_year DATE;
    DECLARE years_diff INT;
    SET date_from_year = MAKEDATE(input_year, 1);
    SET years_diff = TIMESTAMPDIFF(YEAR, date_from_year, CURDATE());
    RETURN years_diff;
END//
DELIMITER ;


SELECT year_difference(2014);