import pandas as pd
import numpy as np
import faiss
from sentence_transformers import SentenceTransformer
import pickle

print("Loading CSV...")
df = pd.read_csv("data.csv")
print("CSV loaded. Columns:", df.columns.tolist())

# Choose the correct text column
TEXT_COLUMN = "description"
print("Using text column:", TEXT_COLUMN)

# Load SBERT model BEFORE encoding
print("Loading model...")
model = SentenceTransformer("all-MiniLM-L6-v2")
print("Model loaded.")

# Clean + convert to string
texts = (
    df[TEXT_COLUMN]
    .fillna("")          # handle NaN
    .astype(str)         # handle floats
    .tolist()
)

print("Encoding texts...")
embeddings = model.encode(texts, convert_to_numpy=True)
print("Embeddings shape:", embeddings.shape)

print("Building FAISS index...")
dimension = embeddings.shape[1]
index = faiss.IndexFlatL2(dimension)
index.add(embeddings)
print("Index built.")

print("Saving index + metadata...")
faiss.write_index(index, "books.index")
df.to_pickle("books_metadata.pkl")

print("DONE — FAISS index + metadata saved.")
