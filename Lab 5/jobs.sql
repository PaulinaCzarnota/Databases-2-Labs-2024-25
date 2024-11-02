-- LAB 5 – INDEXES AND QUERY OPTIMIZATION

-- EXERCISE 4 

-- Drop tables if they already exist to avoid conflicts
DROP TABLE IF EXISTS job_person;
DROP TABLE IF EXISTS joblist;
DROP TABLE IF EXISTS persons;

-- Create the persons table
CREATE TABLE persons(
    person_id INTEGER,
    person_name VARCHAR(20),
    person_surname VARCHAR(20),
    person_age INTEGER NULL,
    person_wealth INTEGER,
    person_weight FLOAT
);

-- Create the joblist table
CREATE TABLE joblist(
    job_id INTEGER,
    job_description VARCHAR(200),
    salary INTEGER
);

-- Create the job_person table to establish many-to-many relationships
CREATE TABLE job_person(
    job_id INTEGER,
    person_id INTEGER,
    start_date TIMESTAMP,
    end_date TIMESTAMP
);

-- Procedure to populate the persons table with random data
CREATE OR REPLACE PROCEDURE Populate_table()
AS
$$
DECLARE
    v_p_id NUMERIC;
    v_p_name VARCHAR(20);
    v_p_surname VARCHAR(20);
    v_p_age INTEGER;
    p_wealth NUMERIC;
    p_weight NUMERIC;

BEGIN
    FOR i IN 1..10000 LOOP 
        SELECT STRING_AGG(SUBSTRING('0123456789bcdfghjkmnpqrstvwxyz', ROUND(RANDOM() * 30)::INTEGER, 1), '') 
        INTO v_p_name  
        FROM generate_series(1, 20);
        
        SELECT STRING_AGG(SUBSTRING('0123456789bcdfghjkmnpqrstvwxyz', ROUND(RANDOM() * 30)::INTEGER, 1), '') 
        INTO v_p_surname  
        FROM generate_series(1, 20);
        
        SELECT (18 + RANDOM() * 82)::INT INTO v_p_age;
        SELECT RANDOM() * 1000000 INTO p_wealth;
        SELECT (40 + RANDOM() * 80)::INT INTO p_weight;
        
        INSERT INTO persons VALUES(i, v_p_name, v_p_surname, v_p_age, p_wealth, p_weight);
    END LOOP;

END;
$$ LANGUAGE plpgsql;

-- Procedure to populate the joblist table with random data
CREATE OR REPLACE PROCEDURE Populate_jobs()
AS
$$
DECLARE
    j_description VARCHAR(100);
    j_salary NUMERIC;

BEGIN
    FOR i IN 1..10000 LOOP 
        SELECT STRING_AGG(SUBSTRING('0123456789bcdfghjkmnpqrstvwxyz', ROUND(RANDOM() * 30)::INTEGER, 1), '') 
        INTO j_description  
        FROM generate_series(1, 100);
        
        SELECT (35000 + RANDOM() * 65000)::INT INTO j_salary;
        
        INSERT INTO joblist VALUES(i, j_description, j_salary);
    END LOOP;

END;
$$ LANGUAGE plpgsql;

-- Procedure to populate the job_person table with random associations
CREATE OR REPLACE PROCEDURE Populate_jobs_persons()
AS
$$
DECLARE
    v_p_id NUMERIC;
    start_date TIMESTAMP;
    end_date TIMESTAMP;

BEGIN
    FOR i IN 1..10000 LOOP
        FOR j IN 1..15 LOOP 
            SELECT TIMESTAMP '2004-01-10' + RANDOM() * (TIMESTAMP '2024-01-20' - TIMESTAMP '2014-01-10') INTO start_date; 
            SELECT TIMESTAMP '2014-01-10' + RANDOM() * (TIMESTAMP '2024-01-20' - TIMESTAMP '2014-01-10') INTO end_date; 
            -- Assign a valid person_id for the job_person association
            SELECT ROUND(1 + RANDOM() * 9999)::INTEGER INTO v_p_id; 
            INSERT INTO job_person VALUES(i, v_p_id, start_date, end_date);
        END LOOP;  
    END LOOP;

END;
$$ LANGUAGE plpgsql;

-- Call procedures to populate the tables
CALL Populate_table();
CALL Populate_jobs();
CALL Populate_jobs_persons();

-- Analyze the number of rows in each table
SELECT 'persons' AS table_name, COUNT(*) AS row_count FROM persons;
SELECT 'joblist' AS table_name, COUNT(*) AS row_count FROM joblist;
SELECT 'job_person' AS table_name, COUNT(*) AS row_count FROM job_person;

-- 1. Analyze SELECT all persons
EXPLAIN ANALYZE SELECT * FROM persons;

-- 2. Analyze range query on person_id
EXPLAIN ANALYZE SELECT * FROM persons WHERE person_id > 1000 AND person_id < 3000;

-- 3. Add primary key to the persons table
ALTER TABLE persons ADD PRIMARY KEY (person_id);

-- 4. Re-run the range query after adding primary key
EXPLAIN ANALYZE SELECT * FROM persons WHERE person_id >= 3;

-- 5. Aggregate query on person_age
EXPLAIN ANALYZE SELECT person_age, COUNT(person_id) FROM persons GROUP BY person_age;

-- 6. Add index on person_age
CREATE INDEX p_age ON persons(person_age);

-- 7. Analyze aggregate query after adding index
EXPLAIN ANALYZE SELECT person_age, COUNT(person_id) FROM persons GROUP BY person_age;

-- 8. Another aggregate query to compare performance
EXPLAIN ANALYZE SELECT person_age, COUNT(person_age) FROM persons GROUP BY person_age;

-- 9. Analyze join query between joblist and job_person tables
CREATE INDEX idx_joblist_job_id ON joblist(job_id);
CREATE INDEX idx_job_person_job_id ON job_person(job_id);
CREATE INDEX idx_job_person_person_id ON job_person(person_id);
CREATE INDEX idx_persons_person_id ON persons(person_id);

EXPLAIN ANALYZE 
SELECT joblist.job_id, joblist.job_description, joblist.salary, job_person.person_id, persons.person_name 
FROM joblist 
INNER JOIN job_person ON joblist.job_id = job_person.job_id 
INNER JOIN persons ON job_person.person_id = persons.person_id 
WHERE job_person.job_id = 34;