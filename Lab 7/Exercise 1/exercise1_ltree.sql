-- LAB 7 - NOSQL DATA IN POSTGRESQL

-- EXERCISE 1: HIERARCHICAL DATA WITH LTREE

-- Step 1: Enable the ltree extension
-- This extension is required to manage hierarchical data
CREATE EXTENSION IF NOT EXISTS ltree;

-- Step 2: Create the hierarchical table if it doesn't already exist
-- The table will store hierarchical paths and CAO points
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT FROM information_schema.tables
        WHERE table_name = 'tud_tree'
    ) THEN
        CREATE TABLE tud_tree (
            path ltree,         -- Column for hierarchical paths
            cao_points INTEGER  -- Column for CAO points
        );
    END IF;
END $$;

-- Step 3: Insert the initial hierarchical data
-- Populate the table with the university structure
INSERT INTO tud_tree (path)
VALUES
    ('TUD'::ltree),
    ('TUD.Science'::ltree),
    ('TUD.Science.Computer_Science'::ltree),
    ('TUD.Science.Computer_Science.Software'::ltree),
    ('TUD.Science.Computer_Science.AI'::ltree),
    ('TUD.Science.BiologicalScience'::ltree),
    ('TUD.Science.BiologicalScience.MolecularBiology'::ltree),
    ('TUD.Art'::ltree),
    ('TUD.Art.Design'::ltree),
    ('TUD.Engineering'::ltree)
ON CONFLICT DO NOTHING;  -- Avoids duplicate insertions

-- Step 4: Add a new school named Computer_Science under TUD.Science
-- Add only if it does not already exist
INSERT INTO tud_tree (path)
SELECT 'TUD.Science.Computer_Science'::ltree
WHERE NOT EXISTS (
    SELECT 1 FROM tud_tree WHERE path = 'TUD.Science.Computer_Science'::ltree
);

-- Step 5: Add two degrees Software and AI under Computer_Science
-- Add degrees only if they don't already exist
INSERT INTO tud_tree (path)
VALUES 
    ('TUD.Science.Computer_Science.Software'::ltree),
    ('TUD.Science.Computer_Science.AI'::ltree)
ON CONFLICT DO NOTHING;

-- Step 6: Find the degree under which MolecularBiology falls
-- Extract the direct parent of MolecularBiology
SELECT subpath(path, 1, 1) AS degree
FROM tud_tree
WHERE path ~ '*.MolecularBiology';

-- Step 7: Count the total number of courses in the TUD dataset
-- Count all hierarchical paths in the table
SELECT COUNT(*) AS course_count
FROM tud_tree;

-- Step 8: Find the faculty with the highest number of courses
-- Group by the top-level faculty and find the one with the most courses
SELECT subpath(path, 0, 1) AS faculty, COUNT(*) AS course_count
FROM tud_tree
GROUP BY faculty
ORDER BY course_count DESC
LIMIT 1;

-- Step 9: Count the number of colleges in the TUD dataset
-- Count distinct first-level paths (colleges)
SELECT COUNT(DISTINCT subpath(path, 0, 1)) AS college_count
FROM tud_tree;

-- Step 10: Rename the university TUD to TUDublin
-- Update the path by replacing 'TUD' with 'TUDublin'
UPDATE tud_tree
SET path = regexp_replace(path::text, '^TUD', 'TUDublin')::ltree
WHERE path ~ 'TUD.*';

-- Step 11: Delete the BiologicalScience school and all its courses
-- Use <@ operator to delete all descendants of BiologicalScience
DELETE FROM tud_tree
WHERE path <@ 'TUDublin.Science.BiologicalScience'::ltree;

-- Step 12: Add a column for CAO points if it doesn't already exist
-- Dynamically add the CAO points column to store scores
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT column_name
        FROM information_schema.columns
        WHERE table_name = 'tud_tree' AND column_name = 'cao_points'
    ) THEN
        ALTER TABLE tud_tree ADD COLUMN cao_points INTEGER;
    END IF;
END $$;

-- Step 13: Assign CAO points based on faculty
-- Use a CASE statement to assign scores based on faculty type
UPDATE tud_tree
SET cao_points = 
    CASE 
        WHEN path ~ 'TUDublin.Art.*' THEN 300
        WHEN path ~ 'TUDublin.Science.*' THEN 450
        WHEN path ~ 'TUDublin.Engineering.*' THEN 400
        ELSE 350
    END;

-- Step 14: Assign 500 CAO points to Computer Science degrees
-- Specifically update scores for Computer Science degrees
UPDATE tud_tree
SET cao_points = 500
WHERE path ~ 'TUDublin.Science.Computer_Science.*';

-- Step 15: Compute the average CAO points for the Science College
-- Calculate the average score for degrees under TUDublin.Science
SELECT AVG(cao_points) AS avg_cao_points
FROM tud_tree
WHERE path ~ 'TUDublin.Science.*';

-- Verify the final state of the table
-- Display all distinct paths and their associated CAO points
SELECT DISTINCT path, cao_points FROM tud_tree ORDER BY path;