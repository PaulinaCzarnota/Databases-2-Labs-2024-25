-- LAB 4 – NORMALIZATION

-- EXERCISE 1: DESIGN

-- Set the schema to public
SET search_path TO public;

-- Drop any views that may exist
DROP VIEW IF EXISTS ranked_participants CASCADE;
DROP VIEW IF EXISTS best_irish_athletes CASCADE;
DROP VIEW IF EXISTS marathon_position CASCADE;
DROP VIEW IF EXISTS medal_table CASCADE;

-- Drop any unrelated tables if they exist
DROP TABLE IF EXISTS Purchase CASCADE;
DROP TABLE IF EXISTS Painting CASCADE;
DROP TABLE IF EXISTS Artist CASCADE;
DROP TABLE IF EXISTS Customer CASCADE;
DROP TABLE IF EXISTS City CASCADE;

-- Create City Table
CREATE TABLE City (
    ZipCode VARCHAR(10) PRIMARY KEY,
    CityName VARCHAR(100) NOT NULL
);

-- Create Customer Table
CREATE TABLE Customer (
    CustomerID SERIAL PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Phone VARCHAR(20) NOT NULL,
    Street VARCHAR(100) NOT NULL,
    ZipCode VARCHAR(10) NOT NULL,
    FOREIGN KEY (ZipCode) REFERENCES City(ZipCode) ON DELETE CASCADE
);

-- Create Artist Table
CREATE TABLE Artist (
    ArtistID SERIAL PRIMARY KEY,
    ArtistName VARCHAR(100) NOT NULL
);

-- Create Painting Table
CREATE TABLE Painting (
    PaintingID SERIAL PRIMARY KEY,
    ArtistID INT NOT NULL,
    PaintingCode VARCHAR(20) NOT NULL,
    Title VARCHAR(100) NOT NULL,
    FOREIGN KEY (ArtistID) REFERENCES Artist(ArtistID) ON DELETE CASCADE,
    UNIQUE (ArtistID, PaintingCode) -- Ensures uniqueness of painting codes for each artist
);

-- Create Purchase Table
CREATE TABLE Purchase (
    PurchaseID SERIAL PRIMARY KEY,
    CustomerID INT NOT NULL,
    PaintingID INT NOT NULL,
    PurchaseDate DATE NOT NULL,
    SalesPrice DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID) ON DELETE CASCADE,
    FOREIGN KEY (PaintingID) REFERENCES Painting(PaintingID) ON DELETE CASCADE
);

-- Verification step: List all tables in the public schema
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public';