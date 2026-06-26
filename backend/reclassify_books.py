# import sqlite3
# import torch
# from transformers import pipeline

# # 1. Hardware acceleration check (uses GPU if available, else CPU)
# device = 0 if torch.cuda.is_available() else -1
# print(f"Using device: {'GPU (CUDA)' if device == 0 else 'CPU'}")

# # 2. Initialize the pipeline with a fast, lightweight model
# classifier = pipeline(
#     "zero-shot-classification", 
#     model="valhalla/distilbart-mnli-12-3", 
#     device=device
# )

# # Define your target genres including the ones you want to ban/filter out
# my_labels = [
#     # --- Fiction Genres (Keep & Categorize) ---
#     "Sci-Fi", 
#     "Fantasy", 
#     "Mystery & Thriller", 
#     "Romance", 
#     "Historical Fiction", 
#     "Horror", 
#     "Action & Adventure",
#     "Literary Fiction", # Catches standard contemporary novels/dramas
#     "Graphic Novels & Manga",
#     "Poetry & Plays",
#     "Humor/Satire",
#     "Dystopian",
    
#     # --- Non-Fiction / Educational Genres (Will Be Deleted) ---
#     "Educational", 
#     "Non-Fiction",
#     "Biography & Memoir",
#     "History & Politics",
#     "Self-Help",
#     "Business & Economics"
# ]

# # 3. Connect to your SQLite database
# conn = sqlite3.connect('books.db')
# cursor = conn.cursor()

# # Make sure your books table has a 'genre' column before updating it
# cursor.execute("ALTER TABLE books ADD COLUMN genre TEXT;").fetchall()
# conn.commit()

# # Grab all your rows
# cursor.execute("SELECT id, description FROM books WHERE description IS NOT NULL")
# books = cursor.fetchall()

# BATCH_SIZE = 16 
# print(f"Starting reclassification of {len(books)} books...")

# # 4. Loop through the dataset in mini-batches
# for i in range(0, len(books), BATCH_SIZE):
#     batch = books[i:i+BATCH_SIZE]
#     batch_descriptions = [book[1] for book in batch]
#     batch_ids = [book[0] for book in batch]
#     banned_genres = ["Educational", "Non-Fiction", "Biography & Memoir", "History & Politics", "Self-Help", "Business & Economics"]
    
#     # Run the AI classifier
#     results = classifier(batch_descriptions, candidate_labels=my_labels, batch_size=BATCH_SIZE)
    
#     # Evaluate the results for each book in the batch
#     for book_id, result in zip(batch_ids, results):
#         best_genre = result['labels'][0]
        
#         # The updated filter rule inside your loop:
#        # FILTER RULE: If the highest scoring genre is Educational or Non-Fiction, delete it!
#         if best_genre in banned_genres:
#             cursor.execute("DELETE FROM books WHERE id = ?", (book_id,))
#         else:
#             # Otherwise, update the row with the clean fiction genre
#             cursor.execute("UPDATE books SET genre = ? WHERE id = ?", (best_genre, book_id))
    
#     # Save progress to the hard drive at the end of every batch
#     conn.commit()
#     print(f"Processed up to book {i + len(batch)}...")

# # 5. Clean up database storage space (Removes empty space left by deleted rows)
# cursor.execute("VACUUM")
# conn.commit()
# conn.close()

# print("Database scrubbing complete! All educational and non-fiction books have been purged.")