-- LAB 7 - NOSQL DATA IN POSTGRES

-- Exercise 2: Geographical Data with PostGIS

-- Step 1: Activate the PostGIS extension
-- This enables spatial data support in your PostgreSQL database.
CREATE EXTENSION IF NOT EXISTS postgis;

-- Step 2: Verify datasets
-- Assuming the required datasets (NYC stations, streets, neighborhoods) are pre-loaded into the database.

-- Step 3: Verify data loading
-- Check the number of records in each table to ensure the data has been loaded correctly.
SELECT COUNT(*) AS neighborhood_count FROM nycnb; -- Verify the neighborhoods table
SELECT COUNT(*) AS station_count FROM nycstation; -- Verify the stations table
SELECT COUNT(*) AS street_count FROM nycstreet;   -- Verify the streets table

-- Step 4: Queries

-- (a) Find the streets that are inside or crossing the East Village
-- This query identifies all streets that either cross or are contained within the East Village neighborhood.
SELECT ns.name AS street_name
FROM nycstreet ns
WHERE ST_Crosses(ns.geom, (SELECT geom FROM nycnb WHERE name = 'East Village' LIMIT 1))
   OR ST_Contains(ns.geom, (SELECT geom FROM nycnb WHERE name = 'East Village' LIMIT 1))
ORDER BY ns.name;

-- (b) Find the neighborhood with the most tube stations
-- This query finds the neighborhood that contains the highest number of tube stations.
SELECT nb.name AS neighborhood, 
       COUNT(st.gid) AS station_count
FROM nycstation st
JOIN nycnb nb ON ST_Contains(nb.geom, st.geom)
GROUP BY nb.name
ORDER BY station_count DESC
LIMIT 1;

-- (c) Find the longest road
-- This query calculates the length of all roads and returns the longest one.
SELECT ns.name AS road_name, 
       ST_Length(ns.geom) AS road_length
FROM nycstreet ns
ORDER BY road_length DESC
LIMIT 1;

-- (d) Find the smallest neighborhood by area
-- This query computes the area of all neighborhoods and returns the smallest one.
SELECT nb.name AS neighborhood, 
       ST_Area(nb.geom) AS area
FROM nycnb nb
ORDER BY area ASC
LIMIT 1;

-- (e) Calculate the total length of Broadway in Manhattan
-- This query sums up the lengths of all segments of Broadway located within the Manhattan borough.
SELECT 'Broadway' AS street_name, 
       SUM(ST_Length(ns.geom)) AS total_length
FROM nycstreet ns
JOIN nycnb nb ON ST_Within(ns.geom, nb.geom)
WHERE ns.name = 'Broadway' AND nb.boroname = 'Manhattan';

-- (f) Check for other streets named Broadway in NYC (outside Manhattan) and find the longest
-- This query lists all streets named Broadway in other boroughs, along with their lengths, and orders them by length.
SELECT ns.name AS street_name, 
       nb.boroname AS borough, 
       ST_Length(ns.geom) AS road_length
FROM nycstreet ns
JOIN nycnb nb ON ST_Within(ns.geom, nb.geom)
WHERE ns.name = 'Broadway' AND nb.boroname != 'Manhattan'
ORDER BY road_length DESC;