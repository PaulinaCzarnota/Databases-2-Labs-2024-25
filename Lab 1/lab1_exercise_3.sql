-- LAB 1 – RELATIONAL DATABASE DESIGN

-- EXERCISE 3: CREATE TABLES FOR CINEMA DATABASE

-- Dropping tables if they already exist, handling dependencies in reverse order
DROP TABLE IF EXISTS bookings CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS showings CASCADE;
DROP TABLE IF EXISTS screens CASCADE;
DROP TABLE IF EXISTS movies CASCADE;
DROP TABLE IF EXISTS cinemas CASCADE;

-- Creating the 'cinemas' table
CREATE TABLE cinemas (
    cinema_id SERIAL PRIMARY KEY,                   -- Unique identifier for each cinema
    location VARCHAR(100) NOT NULL,                -- Location of the cinema
    contact_number VARCHAR(15),                     -- Contact number of the cinema
    name VARCHAR(100) NOT NULL,                     -- Name of the cinema
    number_of_screens INT CHECK (number_of_screens > 0)  -- Number of screens in the cinema
);

-- Creating the 'movies' table
CREATE TABLE movies (
    movie_id SERIAL PRIMARY KEY,                    -- Unique identifier for each movie
    title VARCHAR(100) NOT NULL,                    -- Title of the movie
    duration INT CHECK (duration > 0),              -- Duration of the movie in minutes
    rating VARCHAR(5)                               -- Rating of the movie (e.g., PG-13, R)
);

-- Creating the 'screens' table
CREATE TABLE screens (
    screen_id SERIAL PRIMARY KEY,                   -- Unique identifier for each screen
    cinema_id INT REFERENCES cinemas(cinema_id) ON DELETE CASCADE,  -- Foreign key referencing cinemas
    number_of_seats INT CHECK (number_of_seats > 0)  -- Number of seats in the screen
);

-- Creating the 'showings' table
CREATE TABLE showings (
    show_id SERIAL PRIMARY KEY,                     -- Unique identifier for each showing
    movie_id INT REFERENCES movies(movie_id) ON DELETE CASCADE,  -- Foreign key referencing movies
    screen_id INT REFERENCES screens(screen_id) ON DELETE CASCADE,  -- Foreign key referencing screens
    show_time TIMESTAMP NOT NULL                    -- Time of the showing
);

-- Creating the 'customers' table
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,                 -- Unique identifier for each customer
    username VARCHAR(50) UNIQUE NOT NULL,          -- Unique username for the customer
    password VARCHAR(50) NOT NULL,                  -- Password for customer login
    dob DATE NOT NULL                                -- Date of birth of the customer
);

-- Creating the 'bookings' table
CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,                  -- Unique identifier for each booking
    customer_id INT REFERENCES customers(customer_id) ON DELETE CASCADE,  -- Foreign key referencing customers
    show_id INT REFERENCES showings(show_id) ON DELETE CASCADE,  -- Foreign key referencing showings
    adult_tickets INT CHECK (adult_tickets >= 0),  -- Number of adult tickets booked
    child_tickets INT CHECK (child_tickets >= 0),  -- Number of child tickets booked
    total_price DECIMAL(10, 2) CHECK (total_price >= 0),  -- Total price of the booking
    seat_numbers VARCHAR(255)                       -- Seat numbers selected for the booking
);

-- Inserting example data into the 'cinemas' table
INSERT INTO cinemas (location, contact_number, name, number_of_screens) VALUES 
('New York', '123456789', 'Cinema One', 5),
('Los Angeles', '987654321', 'Cinema Two', 8);

-- Inserting example data into the 'movies' table
INSERT INTO movies (title, duration, rating) VALUES 
('Inception', 148, 'PG-13'),
('Toy Story', 100, 'G');

-- Inserting example data into the 'screens' table
INSERT INTO screens (cinema_id, number_of_seats) VALUES 
(1, 100),  -- Screen in Cinema One
(2, 150);  -- Screen in Cinema Two

-- Inserting example data into the 'showings' table
INSERT INTO showings (movie_id, screen_id, show_time) VALUES 
(1, 1, '2024-10-26 14:00:00'),  -- Showing of Inception in Screen 1
(2, 2, '2024-10-26 16:00:00');  -- Showing of Toy Story in Screen 2

-- Inserting example data into the 'customers' table
INSERT INTO customers (username, password, dob) VALUES 
('john_doe', 'password123', '1985-05-12'),  -- Customer 1
('jane_smith', 'securepass456', '1990-08-23');  -- Customer 2

-- Inserting example data into the 'bookings' table
INSERT INTO bookings (customer_id, show_id, adult_tickets, child_tickets, total_price, seat_numbers) VALUES 
(1, 1, 2, 1, 30.00, '3,4,5'),  -- Booking for Customer 1
(2, 2, 1, 2, 45.00, '10,11,12');  -- Booking for Customer 2

-- Select statements to display the tables
SELECT * FROM cinemas;
SELECT * FROM movies;
SELECT * FROM screens;
SELECT * FROM showings;
SELECT * FROM customers;
SELECT * FROM bookings;