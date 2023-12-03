SELECT * FROM car_resales;

-- find the missing value and replace those
DROP TEMPORARY TABLE IF EXISTS temp_table;
CREATE TEMPORARY TABLE temp_table AS
SELECT MyUnknownColumn, LEFT(full_name, 4) AS new_value
FROM car_resales;

UPDATE car_resales
JOIN temp_table ON car_resales.MyUnknownColumn = temp_table.MyUnknownColumn
SET car_resales.registered_year = temp_table.new_value;

DROP TEMPORARY TABLE IF EXISTS temp_table;
-------------------------------------------------------------------------------------------
--- convert price to dolar
ALTER TABLE car_resales
MODIFY COLUMN resale_price_as_dolar VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;


UPDATE car_resales
SET resale_price_as_dolar = 
  CASE 
    WHEN POSITION('Lakh' IN resale_price) > 0 
      THEN CAST(REPLACE(REPLACE(resale_price, 'â‚¹', ''), ' Lakh', '') AS DECIMAL(10, 2)) * 1203
    WHEN POSITION('Crore' IN resale_price) > 0 
      THEN CAST(REPLACE(REPLACE(resale_price, 'â‚¹', ''), ' Crore', '') AS DECIMAL(10, 2)) * 120300.00
    ELSE CAST(REPLACE(resale_price, 'â‚¹', '') AS DECIMAL(10,2)) * 0.012
  END;

UPDATE car_resales
SET resale_price_as_dolar = CONCAT(resale_price_as_dolar, '$');

UPDATE car_resales
SET resale_price_as_dolar = SUBSTRING(resale_price_as_dolar, 1, LENGTH(resale_price_as_dolar) - 1);

---------------------------------------------------------------
SELECT transmission_type, COUNT(*) AS total_count,sum(resale_price_as_dolar) as total_price_for_type
FROM car_resales
GROUP BY transmission_type;
---------------------------------------------------------------
select full_name,registered_year,resale_price_as_dolar
from car_resales
where registered_year >2015 and resale_price_as_dolar < 15000;
--------------------------------------------------------------
SELECT full_name, engine_capacity, kms_driven, resale_price_as_dolar
FROM car_resales
WHERE 
  engine_capacity > 1500 AND 
  CAST(REPLACE(SUBSTRING_INDEX(kms_driven, ' ', 1), ',', '') AS SIGNED) < 50000;
------------------------------------
SELECT city, COUNT(*) AS total_count,sum(resale_price_as_dolar) AS total_price
FROM car_resales
GROUP BY city;

------------------------------------
SELECT
  city,
  full_name,
  resale_price_as_dolar,
  AVG(resale_price_as_dolar) OVER(PARTITION BY city) AS avg_price_by_city
FROM
  car_resales;
  
  SELECT body_type,AVG(engine_capacity) AS avg_engine_capacity 
FROM car_resales
group by body_type;

SELECT fuel_type, AVG(engine_capacity) AS avg_engine_capacity
FROM car_resales
GROUP BY fuel_type;

SELECT city, AVG(mileage) AS avg_mileage
FROM car_resales
GROUP BY city
ORDER BY avg_mileage DESC;


SELECT
    city,
    body_type,
    AVG(mileage) AS avg_mileage
FROM
    car_resales
GROUP BY
    city, body_type;


SELECT city, transmission_type, AVG(mileage) AS avg_mileage
FROM car_resales
GROUP BY city, transmission_type;

SELECT transmission_type, MAX(max_power) AS max_power
FROM car_resales
GROUP BY transmission_type;

SELECT city, body_type, COUNT(*) AS car_count
FROM car_resales
GROUP BY city, body_type;

SELECT city, body_type,
       RANK() OVER (ORDER BY COUNT(*) DESC) AS ranking
FROM car_resales
GROUP BY city, body_type;


SELECT city, body_type,
       RANK() OVER (PARTITION BY city ORDER BY COUNT(*) DESC) AS ranking
FROM car_resales
GROUP BY city, body_type;
------------------------------------
SELECT city, body_type, COUNT(*) AS car_count
FROM car_resales
GROUP BY city, body_type
ORDER BY city, car_count DESC;

SELECT city, body_type, MAX(resale_price_as_dolar) AS max_resale_price_as_dolar
FROM car_resales
GROUP BY city, body_type
ORDER BY city, max_resale_price DESC;

SELECT city, COUNT(*) AS total_cars_sold
FROM car_resales
WHERE resale_price_as_dolar > 0  
GROUP BY city
ORDER BY total_cars_sold DESC;

SELECT fuel_type, AVG(max_power) AS avg_max_power
FROM car_resales
GROUP BY fuel_type;


  




