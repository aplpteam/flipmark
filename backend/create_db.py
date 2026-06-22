import pandas as pd
import sqlite3

df = pd.read_csv("data.csv")

conn = sqlite3.connect("books.db")
df.to_sql("books", conn, if_exists="replace", index=False)
conn.close()

print("books.db created")
