import re
import math
import pickle
import sqlite3
import pandas as pd
import faiss
from fastapi import FastAPI, UploadFile, File
from sentence_transformers import SentenceTransformer
from fastapi.middleware.cors import CORSMiddleware
from paddleocr import PaddleOCR

# How to run:
# cd backend
# .\venv\Scripts\activate
# uvicorn main:app --reload
# example query search: http://127.0.0.1:8000/similar?query=THE QUERY
# stop: ctrl+C or taskkill /IM python.exe /F


# Load model, index, metadata
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
        "fiction", "novel", "fantasy", "romance", "thriller",
        "mystery", "horror", "science fiction", "literary fiction",
        "young adult", "juvenile fiction", "dystopia", "dystopian",
        "classic", "literature", "satire", "allegory"
    ]

    return any(keyword in cat for keyword in FICTION_KEYWORDS)

@app.get("/similar")
def similar_books(query: str, k: int = 5):
    def normalize_title(title: str):
        title = title.lower().strip()

        # remove possessive author prefixes:
        # "ray bradbury's fahrenheit 451" → "fahrenheit 451"
        title = re.sub(r"^[a-z\s']+?'s\s+", "", title)

        # remove study-guide prefixes
        GUIDE_PREFIXES = [
            r"cliffsnotes on ",
            r"sparknotes on ",
            r"summary of ",
            r"study guide: ",
            r"study guide to ",
            r"analysis of ",
            r"critical essays on ",
            r"critical interpretations of ",
            r"bloom['’]s notes[: ]*",
            r"bloom['’]s modern critical interpretations[: ]*",
            r"modern critical interpretations[: ]*",
        ]
        for p in GUIDE_PREFIXES:
            title = re.sub(rf"^{p}", "", title)

        # remove subtitles after colon, dash, comma, parentheses
        title = re.split(r'[:\-,(]', title)[0]

        # remove volume/edition markers
        title = re.sub(r'\b(book|volume|vol|edition|ed|part|issue)\s*\d+\b', '', title)

        # collapse whitespace
        title = re.sub(r'\s+', ' ', title).strip()

        return title


    def is_combo_edition(title: str):
        # for books like "Animal Farm and 1984"
        return bool(re.search(
            r'([A-Z0-9][A-Za-z0-9]+.*)\s(and|&|/|;)\s+([A-Z0-9][A-Za-z0-9]+)',
            title
        ))

    embedding = model.encode([query], convert_to_numpy=True)
    distances, indices = index.search(embedding, 1000)

    results = []
    seen_titles = set()

    # Detect dystopian queries
    DYSTOPIAN_QUERY_KEYWORDS = [
        "totalitarian", "authoritarian", "dictatorship", "regime",
        "surveillance", "oppression", "dystopia", "dystopian",
        "control", "propaganda", "censorship",
    ]
    query_lower = query.lower()
    query_is_dystopian = any(word in query_lower for word in DYSTOPIAN_QUERY_KEYWORDS)

    # Classic dystopian books to always allow
    DYSTOPIAN_CLASSICS = [
        "1984", "animal farm", "fahrenheit 451",
        "brave new world", "the handmaid's tale"
    ]

    HIGH_SIMILARITY_THRESHOLD = 1.30

    for idx, dist in zip(indices[0], distances[0]):
        row = metadata.iloc[idx].to_dict()

        title = (row.get("title") or "").strip()
        title_lower = title.lower()
        normalized = normalize_title(title)
        category = str(row.get("categories", "")).lower()
        desc = (row.get("description") or "").lower()

        if is_combo_edition(row.get("title", "")):
            continue

        if normalized in seen_titles:
            continue
        
        NONFICTION_TERMS = [
            "nonfiction", "non-fiction",
            "juvenile nonfiction", "juvenile non-fiction",
            "biography", "autobiography", "memoir",
            "essays", "history", "criticism", "analysis",
            "commentary", "letters", "journalism", "reportage",
            "literary criticism", "literary collections",
            "political science", "social science",
            "psychology", "psychiatry", "self-help", "self help",
            "mental health", "cognitive science", "behavioral science"
        ]

        if any(term in category for term in NONFICTION_TERMS):
            continue

        if any(term in desc for term in NONFICTION_TERMS):
            continue

        if query_is_dystopian and any(c in title_lower for c in DYSTOPIAN_CLASSICS):

            for key, value in row.items():
                if isinstance(value, float) and math.isnan(value):
                    row[key] = None

            if isinstance(dist, float) and math.isnan(dist):
                dist = None
            else:
                dist = float(dist)

            results.append({
                "title": row.get("title"),
                "authors": row.get("authors"),
                "categories": row.get("categories"),
                "thumbnail": row.get("thumbnail"),
                "description": row.get("description"),
                "distance": dist
            })
            seen_titles.add(normalized)
            if len(results) == k:
                break
            continue
      
        description_says_fiction = any(
            keyword in desc for keyword in [
                "novel", "story", "dystopian", "utopian",
                "narrative", "tale", "classic", "allegory"
            ]
        )
        category_says_fiction = is_fiction_category(category)

        if query_is_dystopian:
            if any(word in desc for word in ["novel", "story", "classic", "dystopian", "allegory"]):
                category_says_fiction = True

        if not (category_says_fiction or description_says_fiction):
            continue

        for key, value in row.items():
            if isinstance(value, float) and math.isnan(value):
                row[key] = None

        if isinstance(dist, float) and math.isnan(dist):
            dist = None
        else:
            dist = float(dist)

        results.append({
            "title": row.get("title"),
            "authors": row.get("authors"),
            "categories": row.get("categories"),
            "thumbnail": row.get("thumbnail"),
            "description": row.get("description"),
            "distance": dist
        })

        seen_titles.add(normalized)

        if len(results) == k:
            break

    return {"query": query, "results": results}

# Initialize PaddleOCR to extract text from the image
ocr = PaddleOCR(use_angle_cls=True, lang='en')

@app.post("/upload_synopsis")
async def upload_synopsis(file: UploadFile = File(...)):
    try:
        # Read uploaded file
        contents = await file.read()

        # Save temporarily
        temp_path = f"temp_{file.filename}"
        with open(temp_path, "wb") as f:
            f.write(contents)

        # Run PaddleOCR on the file
        result = ocr.ocr(temp_path, cls=True)

        # Extract the recognized text lines
        text_lines = []
        for line in result[0]:
            text_lines.append(line[1][0])

        # combines the lines into one string
        text = "\n".join(text_lines)

        # Run similarity search, k=5 means return the top 5 most similar books
        return similar_books(query=text, k=5)

    except Exception as e:
        print("UPLOAD ERROR:", e)
        return {"error": str(e)}

@app.get("/")
def root():
    return {"message": "Backend is running"}
