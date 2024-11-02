-- LAB 2 – ADVANCED QUERIES

-- PART 1: PARIS 2024 ATHLETICS RESULTS

-- Step 0: Clean up existing tables and views if they exist
DROP VIEW IF EXISTS medal_table CASCADE;
DROP VIEW IF EXISTS event_ranking CASCADE;
DROP TABLE IF EXISTS paris_2024_results CASCADE;

-- Step 1: Create the `paris_2024_results` table with the appropriate data types
CREATE TABLE paris_2024_results (
    date DATE,
    event_name VARCHAR(255),  -- Handle extra quotes in the data
    gender CHAR(1),
    discipline_name VARCHAR(255),
    participant_name VARCHAR(255),
    participant_type VARCHAR(10),
    participant_country_code CHAR(3),
    participant_country VARCHAR(255),
    result DECIMAL,  -- Use DECIMAL for precision in results
    result_type VARCHAR(10)
);

-- Step 2: Load data into `paris_2024_results` using the `COPY` command
COPY paris_2024_results
FROM 'C:/Program Files/PostgreSQL/17/Paris_2024_Result.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ',',
    QUOTE '"',
    ESCAPE '"',
    NULL ''
);

-- Step 3a: Create a view `event_ranking` to rank participants per event
CREATE VIEW event_ranking AS
SELECT 
    date,
    event_name,
    gender,
    discipline_name,
    participant_name,
    participant_type,
    participant_country_code,
    participant_country,
    result,
    result_type,
    RANK() OVER (
        PARTITION BY event_name, gender 
        ORDER BY 
            CASE 
                WHEN result_type = 'TIME' THEN result 
                WHEN result_type = 'DISTANCE' THEN result * -1  -- For distance, use descending order
            END ASC
    ) AS rank
FROM 
    paris_2024_results;

-- Step 3b: Identify the best 5 Irish athletes based on their ranking
SELECT *
FROM event_ranking
WHERE participant_country_code = 'IRL'
ORDER BY rank
LIMIT 5;

-- Step 3c: Check the ranking of the Women’s Marathon winner in the Men’s Marathon event
WITH womens_marathon_winner AS (
    SELECT result
    FROM event_ranking
    WHERE event_name = 'Women''s Marathon' AND rank = 1
),
mens_marathon_ranks AS (
    SELECT result, 
           RANK() OVER (ORDER BY result ASC) AS men_rank
    FROM event_ranking
    WHERE event_name = 'Men''s Marathon'
)
SELECT men_rank 
FROM mens_marathon_ranks
WHERE result >= (SELECT result FROM womens_marathon_winner)
ORDER BY men_rank
LIMIT 1;

-- Step 3d: Generate the Medal Table view
CREATE VIEW medal_table AS
SELECT 
    participant_country AS Country,
    COUNT(CASE WHEN rank = 1 THEN 1 END) AS Gold,
    COUNT(CASE WHEN rank = 2 THEN 1 END) AS Silver,
    COUNT(CASE WHEN rank = 3 THEN 1 END) AS Bronze
FROM 
    event_ranking
GROUP BY 
    participant_country
ORDER BY 
    Gold DESC, Silver DESC, Bronze DESC;

-- Step 3e: Determine if EU countries won more medals than the USA
WITH eu_countries AS (
    SELECT unnest(ARRAY['IRL', 'FRA', 'GER', 'ITA', 'ESP', 'NED', 'SWE', 'POL', 'ROU', 'GRE']) AS country_code
),
eu_medals AS (
    SELECT 
        COUNT(*) AS total_medals
    FROM 
        event_ranking er
    JOIN 
        eu_countries eu ON er.participant_country_code = eu.country_code
    WHERE 
        rank <= 3
),
usa_medals AS (
    SELECT 
        COUNT(*) AS total_medals
    FROM 
        event_ranking
    WHERE 
        participant_country_code = 'USA' AND rank <= 3
)
SELECT 
    'EU' AS region, total_medals
FROM 
    eu_medals
UNION ALL
SELECT 
    'USA', total_medals
FROM 
    usa_medals;

-- Final verification of the medal_table structure
SELECT * FROM medal_table;