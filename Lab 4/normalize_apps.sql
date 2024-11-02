-- LAB 4 – NORMALIZATION

-- EXERCISE 2: DESIGN AND IMPLEMENTATION

-- Drop existing normalized tables if they exist
DROP TABLE IF EXISTS Application_Referees CASCADE;
DROP TABLE IF EXISTS PriorSchools CASCADE;
DROP TABLE IF EXISTS Applications CASCADE;
DROP TABLE IF EXISTS Referees CASCADE;
DROP TABLE IF EXISTS StudentAddresses CASCADE;
DROP TABLE IF EXISTS Students CASCADE;
DROP TABLE IF EXISTS Student_PriorSchools CASCADE;

-- Create Students table
CREATE TABLE Students (
    StudentID INTEGER PRIMARY KEY,
    StudentName VARCHAR(50) NOT NULL
);

-- Create StudentAddresses table
CREATE TABLE StudentAddresses (
    AddressID SERIAL PRIMARY KEY,
    StudentID INTEGER REFERENCES Students(StudentID) ON DELETE CASCADE,
    Street VARCHAR(100),
    State VARCHAR(30),
    ZipCode VARCHAR(7),
    UNIQUE(StudentID, Street, State, ZipCode)
);

-- Create Applications table
CREATE TABLE Applications (
    App_No INTEGER,
    StudentID INTEGER REFERENCES Students(StudentID) ON DELETE CASCADE,
    App_Year INTEGER,
    PRIMARY KEY (App_No, App_Year)
);

-- Create Referees table
CREATE TABLE Referees (
    RefereeID SERIAL PRIMARY KEY,
    ReferenceName VARCHAR(100),
    RefInstitution VARCHAR(100),
    UNIQUE(ReferenceName, RefInstitution)
);

-- Create Application_Referees table
CREATE TABLE Application_Referees (
    App_No INTEGER,
    App_Year INTEGER,
    RefereeID INTEGER REFERENCES Referees(RefereeID) ON DELETE CASCADE,
    ReferenceStatement VARCHAR(500),
    PRIMARY KEY (App_No, App_Year, RefereeID),
    FOREIGN KEY (App_No, App_Year) REFERENCES Applications(App_No, App_Year) ON DELETE CASCADE
);

-- Create PriorSchools table
CREATE TABLE PriorSchools (
    PriorSchoolID SERIAL PRIMARY KEY,
    SchoolName VARCHAR(100) NOT NULL,
    UNIQUE(SchoolName)
);

-- Create Student_PriorSchools table
CREATE TABLE Student_PriorSchools (
    StudentID INTEGER REFERENCES Students(StudentID) ON DELETE CASCADE,
    PriorSchoolID INTEGER REFERENCES PriorSchools(PriorSchoolID) ON DELETE CASCADE,
    GPA NUMERIC(4, 2),
    PRIMARY KEY (StudentID, PriorSchoolID)
);

-- Data Migration

-- Insert data into Students
INSERT INTO Students (StudentID, StudentName)
SELECT DISTINCT StudentID, StudentName
FROM Apps_NOT_Normalized;

-- Insert data into StudentAddresses
INSERT INTO StudentAddresses (StudentID, Street, State, ZipCode)
SELECT DISTINCT StudentID, Street, State, ZipCode
FROM Apps_NOT_Normalized;

-- Insert data into Applications
INSERT INTO Applications (App_No, StudentID, App_Year)
SELECT DISTINCT App_No, StudentID, App_Year
FROM Apps_NOT_Normalized;

-- Insert data into Referees
INSERT INTO Referees (ReferenceName, RefInstitution)
SELECT DISTINCT ReferenceName, RefInstitution
FROM Apps_NOT_Normalized;

-- Insert data into Application_Referees
INSERT INTO Application_Referees (App_No, App_Year, RefereeID, ReferenceStatement)
SELECT DISTINCT a.App_No, a.App_Year, r.RefereeID, a.ReferenceStatement
FROM Apps_NOT_Normalized a
JOIN Referees r ON a.ReferenceName = r.ReferenceName AND a.RefInstitution = r.RefInstitution;

-- Insert data into PriorSchools
INSERT INTO PriorSchools (SchoolName)
SELECT DISTINCT PriorSchoolAddr
FROM Apps_NOT_Normalized;

-- Insert data into Student_PriorSchools
INSERT INTO Student_PriorSchools (StudentID, PriorSchoolID, GPA)
SELECT DISTINCT a.StudentID, p.PriorSchoolID, a.GPA
FROM Apps_NOT_Normalized a
JOIN PriorSchools p ON a.PriorSchoolAddr = p.SchoolName;

-- Verification
SELECT 'Data Migration Complete' AS Status;