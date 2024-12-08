# LAB 6 - POSTGRES, PYTHON AND EXTERNAL APIS

import requests
import psycopg2
from collections import Counter

def get_lyrics(artist, song_title):
    """Fetch lyrics from Lyrics.ovh API."""
    url = f"https://api.lyrics.ovh/v1/{artist}/{song_title}"
    response = requests.get(url)
    if response.status_code == 200:
        return response.json().get("lyrics", "")
    else:
        print(f"Failed to fetch lyrics for {song_title} by {artist}. Status Code: {response.status_code}")
        return ""

# Connect to PostgreSQL database
try:
    conn = psycopg2.connect(
        dbname="postgres",
        user="postgres",
        password="nowe_haslo",
        host="localhost",
        port="5432"
    )
    cur = conn.cursor()
    # Fetch songs from the database
    cur.execute("SELECT song_title, singer FROM songs;")
    songs = cur.fetchall()

    # Iterate over each song and populate songs_words
    for song_title, singer in songs:
        lyrics = get_lyrics(singer, song_title)
        if lyrics:
            word_counts = Counter(lyrics.split())
            for word, count in word_counts.items():
                if 4 <= len(word) <= 100:  # Ignore words shorter than 4 characters
                    cur.execute("""
                        INSERT INTO songs_words (song_title, word, word_count)
                        VALUES (%s, %s, %s)
                        ON CONFLICT (song_title, word)
                        DO UPDATE SET word_count = songs_words.word_count + EXCLUDED.word_count;
                    """, (song_title, word, count))
    conn.commit()
    print("Lyrics and word counts have been successfully inserted.")
except Exception as e:
    print(f"Error: {e}")
finally:
    if conn:
        cur.close()
        conn.close()