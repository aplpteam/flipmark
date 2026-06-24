class BookResult {
  final String title;
  final String? authors;
  final String? categories;
  final String? thumbnail;
  final String? description;
  final double? distance;

  BookResult({
    required this.title,
    this.authors,
    this.categories,
    this.thumbnail,
    this.description,
    this.distance,
  });

  factory BookResult.fromJson(Map<String, dynamic> json) {
    return BookResult(
      title: json["title"] ?? "Untitled",
      authors: json["authors"] ?? "Unknown",
      categories: json["categories"] ?? "Unknown",
      thumbnail: json["thumbnail"] ?? "Unknown",
      description: json["description"] ?? "Unknown",
      distance: (json["distance"] is num) ? json["distance"].toDouble() : null,
    );
  }
}
