-- LAB 1 – RELATIONAL DATABASE DESIGN

-- EXERCISE 2: CREATE TABLES FOR E1 AND E2 RELATIONSHIPS

-- Drop tables if they exist to avoid conflicts
DROP TABLE IF EXISTS E1_relation_1 CASCADE;
DROP TABLE IF EXISTS E2_relation_1 CASCADE;
DROP TABLE IF EXISTS E1_optional_relation CASCADE;
DROP TABLE IF EXISTS E2_optional_relation CASCADE;
DROP TABLE IF EXISTS E1_one_to_one_relation CASCADE;
DROP TABLE IF EXISTS E2_one_to_one_relation CASCADE;

-- --------------------
-- PART A: SELECTED SITUATIONS
-- --------------------

-- --------------------
-- Scenario 1: E1 (1,1) — R — (0,*) — E2 (One-to-Many)
-- --------------------

-- Create E1 table with primary key K1
CREATE TABLE E1_relation_1 (
    K1 SERIAL PRIMARY KEY  -- Primary key that auto-increments
);

-- Create E2 table with a nullable foreign key referencing E1
CREATE TABLE E2_relation_1 (
    K2 SERIAL PRIMARY KEY,  -- Primary key that auto-increments
    K1 INT,                 -- Foreign key that can be null
    FOREIGN KEY (K1) REFERENCES E1_relation_1(K1) ON DELETE SET NULL  -- Foreign key constraint
);

-- Insert sample data to demonstrate the relationship
INSERT INTO E1_relation_1 (K1) VALUES (DEFAULT), (DEFAULT);  -- Two entries for E1
INSERT INTO E2_relation_1 (K1) VALUES (1), (NULL), (2);  -- E2 referencing the E1 entries

-- --------------------
-- Scenario 2: E1 (0,1) — R — (0,*) — E2 (Optional One-to-Many)
-- --------------------

-- Create E1 table with primary key K1
CREATE TABLE E1_optional_relation (
    K1 SERIAL PRIMARY KEY  -- Primary key that auto-increments
);

-- Create E2 table with an optional foreign key referencing E1
CREATE TABLE E2_optional_relation (
    K2 SERIAL PRIMARY KEY,  -- Primary key that auto-increments
    K1 INT,                 -- Foreign key that can be null
    FOREIGN KEY (K1) REFERENCES E1_optional_relation(K1) ON DELETE SET NULL  -- Foreign key constraint
);

-- Insert sample data to demonstrate the relationship
INSERT INTO E1_optional_relation (K1) VALUES (DEFAULT);  -- One entry for E1
INSERT INTO E2_optional_relation (K1) VALUES (1), (NULL);  -- E2 referencing the E1 entry

-- --------------------
-- Scenario 3: E1 (1,1) — R — (1,1) — E2 (One-to-One)
-- --------------------

-- Create E1 table with primary key K1
CREATE TABLE E1_one_to_one_relation (
    K1 SERIAL PRIMARY KEY  -- Primary key that auto-increments
);

-- Create E2 table with a unique, non-null foreign key to enforce 1-to-1 relationship
CREATE TABLE E2_one_to_one_relation (
    K2 SERIAL PRIMARY KEY,  -- Primary key that auto-increments
    K1 INT UNIQUE NOT NULL,  -- Unique, non-null foreign key
    FOREIGN KEY (K1) REFERENCES E1_one_to_one_relation(K1) ON DELETE CASCADE  -- Foreign key constraint
);

-- Insert sample data to demonstrate the relationship
INSERT INTO E1_one_to_one_relation (K1) VALUES (DEFAULT), (DEFAULT);  -- Two entries for E1
INSERT INTO E2_one_to_one_relation (K1) VALUES (1), (2);  -- Unique references in E2

-- --------------------
-- Verify the Tables and Relationships for Part A
-- --------------------

-- Select data from Scenario 1 tables
SELECT * FROM E1_relation_1;
SELECT * FROM E2_relation_1;

-- Select data from Scenario 2 tables
SELECT * FROM E1_optional_relation;
SELECT * FROM E2_optional_relation;

-- Select data from Scenario 3 tables
SELECT * FROM E1_one_to_one_relation;

-- --------------------
-- PART B: ADDITIONAL SCENARIO
-- --------------------

-- Drop tables if they exist for the additional scenario
DROP TABLE IF EXISTS E1_relation CASCADE;
DROP TABLE IF EXISTS E2_relation CASCADE;

-- Create E1 table with primary key K1
CREATE TABLE E1_relation (
    K1 SERIAL PRIMARY KEY  -- Primary key that auto-increments
);

-- Create E2 table with K2 as Primary Key and K1 as Foreign Key (references E1)
CREATE TABLE E2_relation (
    K2 SERIAL PRIMARY KEY,  -- Primary key that auto-increments
    K1 INT NOT NULL,        -- Foreign key (NOT NULL to ensure every E2 has an associated E1)
    FOREIGN KEY (K1) REFERENCES E1_relation(K1) ON DELETE CASCADE  -- Foreign key constraint
);

-- Insert sample data to demonstrate the relationship
INSERT INTO E1_relation (K1) VALUES (DEFAULT);  -- One entry for E1
INSERT INTO E2_relation (K1) VALUES (1), (1);  -- Two entries for E2 linking to E1

-- --------------------
-- Verify the Tables and Relationships for Part B
-- --------------------

-- Select data from Part B tables
SELECT * FROM E1_relation;
SELECT * FROM E2_relation;