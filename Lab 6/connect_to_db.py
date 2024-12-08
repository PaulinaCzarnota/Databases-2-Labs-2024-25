# LAB 6 - POSTGRES, PYTHON AND EXTERNAL APIS

import psycopg2
import pandas as pd

# Connect to your PostgreSQL database
try:
    conn = psycopg2.connect(
        dbname="postgres",
        user="postgres",
        password="nowe_haslo",
        host="localhost",
        port="5432"
    )
    # Fetch the data from the songs table
    cur = conn.cursor()
    cur.execute("SELECT * FROM songs;")
    rows = cur.fetchall()
    # Convert the data to a pandas DataFrame
    df = pd.DataFrame(rows, columns=["song_title", "singer", "song_year"])
    print(df)
except Exception as e:
    print(f"Error: {e}")
finally:
    if conn:
        cur.close()
        conn.close()