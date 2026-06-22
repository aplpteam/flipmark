import math
import pickle
import sqlite3
import pandas as pd # Ensure pandas is imported if metadata is a DataFrame
import faiss
from fastapi import FastAPI, UploadFile, File
from sentence_transformers import SentenceTransformer
from fastapi.middleware.cors import CORSMiddleware

# -----------------------------
# Load model, index, metadata
# -----------------------------
model = SentenceTransformer("all-MiniLM-L6-v2")
index = faiss.read_index("books.index")
metadata = pickle.load(open("books_metadata.pkl", "rb"))

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

def is_fiction_category(cat: str):
    cat = cat.lower()
    if "nonfiction" in cat or "non-fiction" in cat:
        return False

    FICTION_KEYWORDS = [
        "fiction", "novel", "fantasy", "romance", "thriller", "mystery",
        "horror", "science fiction", "literary fiction", "young adult",
        "juvenile fiction", "dystopia", "dystopian", "classic", "literature",
        "satire", "allegory"
    ]
    return any(keyword in cat for keyword in FICTION_KEYWORDS)

@app.get("/similar")
def similar_books(query: str, k: int = 5):
    embedding = model.encode([query], convert_to_numpy=True)
    distances, indices = index.search(embedding, 1000)

    results = []
    seen_titles = set()

    for idx, dist in zip(indices[0], distances[0]):
        row = metadata.iloc[idx].to_dict()

        title = (row.get("title") or "").strip()
        title_lower = title.lower()
        category = str(row.get("categories", "")).lower()
        desc = (row.get("description") or "").lower()

        NONFICTION_CATEGORIES = [
            "essays", "biography", "autobiography", "memoir", "history",
            "political science", "language arts", "criticism", "philosophy",
            "social science", "literary collections", "literary criticism"
        ]
        if any(bad in category for bad in NONFICTION_CATEGORIES):
            continue

        NONFICTION_DESCRIPTION_KEYWORDS = [
            "essays", "letters", "pamphlets", "journalism", "reportage",
            "autobiographical", "memoir", "biographical", "experience of",
            "analysis", "commentary", "criticism", "historical", "civil war"
        ]
        if any(bad in desc for bad in NONFICTION_DESCRIPTION_KEYWORDS):
            continue

        description_says_fiction = any(
            keyword in desc for keyword in ["novel", "story", "dystopian", "utopian", "narrative", "tale", "classic", "allegory"]
        )
        category_says_fiction = is_fiction_category(category)

        if not (category_says_fiction or description_says_fiction):
            continue

        if " and " in title_lower:
            continue

        if title_lower in seen_titles:
            continue
        seen_titles.add(title_lower)

        for key, value in row.items():
            if isinstance(value, float) and math.isnan(value):
                row[key] = None

        results.append({
            "title": row.get("title"),
            "authors": row.get("authors"),
            "categories": row.get("categories"),
            "thumbnail": row.get("thumbnail"),
            "description": row.get("description"),
            "distance": float(dist)
        })

        if len(results) == k:
            break

    return {"query": query, "results": results}

@app.post("/upload_synopsis")
async def upload_synopsis(file: UploadFile = File(...)):
    content = await file.read()
    synopsis = content.decode("utf-8")
    return similar_books(query=synopsis, k=5)

@app.get("/")
def root():
    return {"message": "Backend is running"}

@app.get("/books")
def get_books():
    conn = sqlite3.connect("books.db")
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM books LIMIT 10")
    rows = cursor.fetchall()
    conn.close()
    return {"books": rows}