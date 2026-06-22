import 'package:flutter/material.dart';
import 'widgets/book_result.dart';

class ResultsPage extends StatelessWidget {
  final String query;
  final List<BookResult> results;

  const ResultsPage({super.key, required this.query, required this.results});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Results for \"$query\"")),
      body: results.isEmpty
          ? const Center(
              child: Text("No results found", style: TextStyle(fontSize: 18)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final book = results[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Thumbnail
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: book.thumbnail != null
                              ? Image.network(
                                  book.thumbnail!,
                                  width: 80,
                                  height: 120,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 80,
                                  height: 120,
                                  color: Colors.grey.shade300,
                                  child: const Icon(Icons.book, size: 40),
                                ),
                        ),

                        const SizedBox(width: 12),

                        // Text info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                book.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              if (book.authors != null)
                                Text(
                                  book.authors!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade700,
                                  ),
                                ),

                              if (book.categories != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    book.categories!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.blueGrey.shade600,
                                    ),
                                  ),
                                ),

                              const SizedBox(height: 8),

                              if (book.description != null)
                                Text(
                                  book.description!,
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 14),
                                ),

                              if (book.distance != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    "Similarity: ${book.distance!.toStringAsFixed(3)}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
