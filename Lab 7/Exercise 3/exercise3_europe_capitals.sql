-- LAB 7 - NOSQL DATA IN POSTGRESQL

-- EXERCISE 3: EUROPEAN CAPITALS

-- Step 1: Enable the PostGIS extension if not already enabled
CREATE EXTENSION IF NOT EXISTS postgis;

-- Step 2: Drop the table if it already exists to avoid conflicts
DROP TABLE IF EXISTS capital_cities;

-- Step 3: Create the table
CREATE TABLE capital_cities (
    id SERIAL PRIMARY KEY,      -- Auto-increment ID for each row
    country VARCHAR(100),       -- Name of the country
    capital VARCHAR(100),       -- Name of the capital city
    latitude FLOAT,             -- Latitude coordinate
    longitude FLOAT,            -- Longitude coordinate
    coord GEOGRAPHY(Point, 4326) -- Geography column to store coordinates
);

-- Step 4: Import the CSV file into the table
-- Ensure the file path is correct and accessible by PostgreSQL
COPY capital_cities (country, capital, latitude, longitude)
FROM 'C:\\Program Files\\PostgreSQL\\17\\europe_capitals.csv'
DELIMITER ','
CSV HEADER;

-- Step 5: Update the coord column with latitude and longitude values
-- Use ST_SetSRID and ST_MakePoint to create geography points
UPDATE capital_cities
SET coord = ST_SetSRID(ST_MakePoint(longitude, latitude), 4326);

-- Step 6: Query 1 - Calculate the distance between Dublin and London
SELECT 
    ST_Distance(
        (SELECT coord FROM capital_cities WHERE capital = 'Dublin' LIMIT 1),
        (SELECT coord FROM capital_cities WHERE capital = 'London' LIMIT 1)
    ) AS distance_in_meters;

-- Step 7: Query 2 - Find all capitals within 1000 km of Dublin
SELECT 
    c1.capital AS origin,
    c2.capital AS destination,
    ST_Distance(c1.coord, c2.coord) AS distance_in_meters
FROM capital_cities c1
JOIN capital_cities c2 ON c1.capital <> c2.capital
WHERE 
    c1.capital = 'Dublin' AND
    ST_Distance(c1.coord, c2.coord) < 1000000;

-- Step 8: Query 3 - Find the most distant European capital from Dublin
SELECT 
    c1.capital AS origin,
    c2.capital AS destination,
    ST_Distance(c1.coord, c2.coord) AS distance_in_meters
FROM capital_cities c1
JOIN capital_cities c2 ON c1.capital <> c2.capital
WHERE c1.capital = 'Dublin'
ORDER BY distance_in_meters DESC
LIMIT 1;

-- Step 9: Query 4 - Find the capital with the most reachable capitals within 500 km
SELECT 
    c1.capital AS origin,
    COUNT(c2.capital) AS reachable_capitals
FROM capital_cities c1
JOIN capital_cities c2 ON ST_Distance(c1.coord, c2.coord) < 500000 AND c1.capital <> c2.capital
GROUP BY c1.capital
ORDER BY reachable_capitals DESC
LIMIT 1;

-- Step 10: Query 5 - Find the capital with the minimum average distance to all others
SELECT 
    c1.capital AS origin,
    AVG(ST_Distance(c1.coord, c2.coord)) AS avg_distance
FROM capital_cities c1
JOIN capital_cities c2 ON c1.capital <> c2.capital
GROUP BY c1.capital
ORDER BY avg_distance ASC
LIMIT 1;

-- Validation Query - Check data and coordinates
SELECT * FROM capital_cities ORDER BY id;