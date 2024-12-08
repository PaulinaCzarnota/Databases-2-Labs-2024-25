-- LAB 6 - POSTGRES, PYTHON AND EXTERNAL APIS

-- Drop the existing tables if needed
DROP TABLE IF EXISTS songs_words;
DROP TABLE IF EXISTS songs;

-- Create the songs table
CREATE TABLE songs (
    song_title VARCHAR(300) PRIMARY KEY,
    singer VARCHAR(100),
    song_year INT
);

-- Create the songs_words table with unique constraints
CREATE TABLE songs_words (
    song_title VARCHAR(300) REFERENCES songs(song_title),
    word VARCHAR(100),
    word_count INT,
    CONSTRAINT unique_song_word UNIQUE (song_title, word)
);

-- Insert songs into the songs table
INSERT INTO songs (song_title, singer, song_year) 
VALUES
    ('Last Night', 'Morgan Wallen', 2023),
    ('Flowers', 'Miley Cyrus', 2023),
    ('Kill Bill', 'SZA', 2023),
    ('Anti-Hero', 'Taylor Swift', 2023),
    ('Creepin', 'Metro Boomin', 2023),
    ('Calm Down', 'Rema', 2023),
    ('Die For You', 'The Weeknd', 2023),
    ('Fast Car', 'Luke Combs', 2023),
    ('Snooze', 'SZA', 2023),
    ('Physical', 'Olivia Newton-John', 1982),
    ('Eye of the Tiger', 'Survivor', 1982),
    ('I Love Rock n Roll', 'Joan Jett', 1982),
    ('Ebony and Ivory', 'Paul McCartney', 1982),
    ('Centerfold', 'The J. Geils Band', 1982),
    ('Jack and Diane', 'John Cougar', 1982),
    ('Hurts So Good', 'John Cougar', 1982),
    ('Dont You Want Me', 'Human League', 1982),
    ('Abracadabra', 'Steve Miller Band', 1982),
    ('Hard to Say I''m Sorry', 'Chicago', 1982)
ON CONFLICT (song_title) DO NOTHING;