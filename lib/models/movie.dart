class Movie {
  final String title;
  final String year;
  final String imdbID;
  final String poster;
  final String type; // Add this line

  Movie({
    required this.title,
    required this.year,
    required this.imdbID,
    required this.poster,
    required this.type, // Add this line
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['Title'] ?? '',
      year: json['Year'] ?? '',
      imdbID: json['imdbID'] ?? '',
      poster: json['Poster'] ?? 'N/A',
      type: json['Type'] ?? 'movie', // Add this line
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Title': title,
      'Year': year,
      'imdbID': imdbID,
      'Poster': poster,
      'Type': type, // Add this line
    };
  }
}
