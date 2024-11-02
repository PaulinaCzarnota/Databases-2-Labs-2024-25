-- LAB 1 – RELATIONAL DATABASE DESIGN

-- EXERCISE 1: CREATE TABLES FOR TOYS DATABASE

-- Drop tables if they exist to avoid conflicts
DROP TABLE IF EXISTS car CASCADE;
DROP TABLE IF EXISTS teddy CASCADE;
DROP TABLE IF EXISTS toy CASCADE;

-- Create the main toy table
CREATE TABLE toy (
    uid VARCHAR(20) PRIMARY KEY UNIQUE NOT NULL,  -- Unique identifier for each toy
    name VARCHAR(20),                              -- Name of the toy
    price DECIMAL(10, 2)                          -- Price of the toy
);

-- Create the teddy table with specific attributes for teddy bears
CREATE TABLE teddy (
    uid VARCHAR(20) PRIMARY KEY UNIQUE NOT NULL,  -- Unique identifier, same as toy uid
    age INT,                                      -- Recommended age for the teddy bear
    material VARCHAR(20),                         -- Material used to make the teddy bear
    FOREIGN KEY (uid) REFERENCES toy(uid) ON DELETE CASCADE  -- Foreign key constraint
);

-- Create the car table with specific attributes for toy cars
CREATE TABLE car (
    uid VARCHAR(20) PRIMARY KEY UNIQUE NOT NULL,  -- Unique identifier, same as toy uid
    engine_size DECIMAL(3, 1),                    -- Engine size of the toy car
    petrol_or_diesel VARCHAR(20),                  -- Type of fuel used by the toy car
    FOREIGN KEY (uid) REFERENCES toy(uid) ON DELETE CASCADE  -- Foreign key constraint
);

-- Insert data into the toy table
INSERT INTO toy (uid, name, price) VALUES 
('860', 'Teddy Bear', 14.00),
('310', 'Toy Car', 10.00);

-- Insert data into the teddy table
INSERT INTO teddy (uid, age, material) VALUES 
('860', 3, 'Felt');  -- Teddy Bear details

-- Insert data into the car table
INSERT INTO car (uid, engine_size, petrol_or_diesel) VALUES 
('310', 1.8, 'Petrol');  -- Toy Car details

-- Query Data: Retrieve information about toys, including specific attributes
SELECT 
    t.uid, 
    t.name, 
    t.price, 
    c.engine_size, 
    c.petrol_or_diesel, 
    te.age, 
    te.material
FROM 
    toy t
LEFT JOIN 
    car c ON t.uid = c.uid
LEFT JOIN 
    teddy te ON t.uid = te.uid;