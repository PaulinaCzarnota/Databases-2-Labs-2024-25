-- LAB 3 – TRIGGERS IN POSTGRESQL

-- EXERCISE 2

-- Dropping tables if they already exist
DROP TABLE IF EXISTS OLD_PATIENT_DATA, patients;

-- Creating the patients table
CREATE TABLE patients (
    PatientID SERIAL PRIMARY KEY,        
    Date DATE,                            
    PatientName VARCHAR(50),             
    PatientLastName VARCHAR(50),          
    Age INT CHECK (Age > 0),             
    Weight FLOAT CHECK (Weight > 0),      
    Height FLOAT CHECK (Height > 0),       
    BMI FLOAT                              
);

-- Create the old_patient_data table to store previous data before updates
CREATE TABLE OLD_PATIENT_DATA (
    PatientID INT REFERENCES patients(PatientID),  -- Reference to the patient
    Record_ID SERIAL,                              -- Unique ID for each historical record
    Date DATE,                                     -- Date of the record
    Age INT,                                       -- Previous age
    Weight FLOAT,                                  -- Previous weight
    Height FLOAT,                                  -- Previous height
    BMI FLOAT,                                     -- Previous BMI
    PRIMARY KEY (PatientID, Record_ID)            -- Composite primary key
);

-- Create or replace function to calculate BMI
CREATE OR REPLACE FUNCTION calculate_bmi() RETURNS TRIGGER AS $$ 
BEGIN
    -- Calculate BMI: weight in kg / (height in meters)^2
    NEW.BMI := NEW.Weight / ((NEW.Height / 100) * (NEW.Height / 100));
    RETURN NEW;
END; 
$$ LANGUAGE plpgsql;

-- Create trigger to automatically calculate BMI during insert and update
CREATE TRIGGER before_bmi_calculation
BEFORE INSERT OR UPDATE ON patients
FOR EACH ROW
EXECUTE FUNCTION calculate_bmi();

-- Create a trigger function to store previous data before updates
CREATE OR REPLACE FUNCTION store_old_patient_data() RETURNS TRIGGER AS $$ 
DECLARE
    next_record_id INT;
BEGIN
    -- Calculate the next Record_ID
    SELECT COALESCE(MAX(Record_ID), 0) + 1 INTO next_record_id
    FROM OLD_PATIENT_DATA
    WHERE PatientID = OLD.PatientID;

    -- Insert old data into the OLD_PATIENT_DATA table
    INSERT INTO OLD_PATIENT_DATA (PatientID, Record_ID, Date, Age, Weight, Height, BMI)
    VALUES (OLD.PatientID, next_record_id, OLD.Date, OLD.Age, OLD.Weight, OLD.Height, OLD.BMI);
    
    RETURN NEW;
END; 
$$ LANGUAGE plpgsql;

-- Create trigger to store old data before updating a patient record
CREATE TRIGGER before_patient_update
BEFORE UPDATE ON patients
FOR EACH ROW
EXECUTE FUNCTION store_old_patient_data();

-- Insert new patients
INSERT INTO patients (Date, PatientName, PatientLastName, Age, Weight, Height) 
VALUES 
    ('2024-01-01', 'John', 'Doe', 45, 75, 175), 
    ('2024-03-03', 'Mary', 'Smith', 24, 56, 172);

-- Check patients table to verify data and BMI calculation
SELECT * FROM patients;

-- Update patient data (this will trigger the storage of old data)
UPDATE patients 
SET Age = 46, Weight = 78 
WHERE PatientID = 1;

-- Check the old_patient_data table to see the stored old data
SELECT * FROM OLD_PATIENT_DATA;

-- Check updated data in the patients table
SELECT * FROM patients;