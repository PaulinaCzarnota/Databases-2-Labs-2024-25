-- LAB 6 - POSTGRES, PYTHON AND EXTERNAL APIS

SELECT * FROM songs;
SELECT * FROM songs_words;
SELECT * FROM songs_words LIMIT 10;

-- Cleanup: Remove words shorter than 4 characters
DELETE FROM songs_words WHERE LENGTH(word) < 4;

-- Find the top 5 most used words in 2023
SELECT word, SUM(word_count) AS total_count
FROM songs_words
JOIN songs ON songs_words.song_title = songs.song_title
WHERE song_year = 2023
GROUP BY word
ORDER BY total_count DESC
LIMIT 5;

-- Find the top 5 most used words in 1982
SELECT word, SUM(word_count) AS total_count
FROM songs_words
JOIN songs ON songs_words.song_title = songs.song_title
WHERE song_year = 1982
GROUP BY word
ORDER BY total_count DESC
LIMIT 5;