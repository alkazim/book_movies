// import 'package:book_movies/models/movie.dart';
// import 'package:book_movies/screens/movie_details_screen.dart';
// import 'package:book_movies/services/movie_service.dart';
// import 'package:flutter/material.dart';

// class SearchResultsScreen extends StatefulWidget {
//   final String query;

//   SearchResultsScreen({required this.query});

//   @override
//   _SearchResultsScreenState createState() => _SearchResultsScreenState();
// }

// class _SearchResultsScreenState extends State<SearchResultsScreen> {
//   final MovieService _movieService = MovieService();
//   List<Movie> _searchResults = [];
//   bool _isLoading = true;
//   bool _hasError = false;

//   @override
//   void initState() {
//     super.initState();
//     _performSearch();
//   }

//   void _performSearch() async {
//     setState(() {
//       _isLoading = true;
//       _hasError = false;
//     });

//     try {
//       final results = await _movieService.searchMovies(widget.query, 1);
//       setState(() {
//         _searchResults = results;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _hasError = true;
//         _isLoading = false;
//       });
//       print('Search error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: Text(
//           'Search: ${widget.query}',
//           style: TextStyle(color: Colors.white),
//         ),
//         iconTheme: IconThemeData(color: Colors.white),
//         elevation: 0,
//       ),
//       body: _isLoading
//           ? Center(
//               child: CircularProgressIndicator(color: Colors.red),
//             )
//           : _hasError
//               ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.error_outline,
//                         color: Colors.red,
//                         size: 64,
//                       ),
//                       SizedBox(height: 16),
//                       Text(
//                         'Something went wrong',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         'Please try again later',
//                         style: TextStyle(
//                           color: Colors.grey[400],
//                           fontSize: 14,
//                         ),
//                       ),
//                       SizedBox(height: 24),
//                       ElevatedButton(
//                         onPressed: _performSearch,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.red,
//                         ),
//                         child: Text(
//                           'Retry',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               : _searchResults.isEmpty
//                   ? Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.search_off,
//                             color: Colors.grey[400],
//                             size: 64,
//                           ),
//                           SizedBox(height: 16),
//                           Text(
//                             'No results found',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           SizedBox(height: 8),
//                           Text(
//                             'Try searching with different keywords',
//                             style: TextStyle(
//                               color: Colors.grey[400],
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//                   : Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.all(16),
//                           child: Text(
//                             'Found ${_searchResults.length} results',
//                             style: TextStyle(
//                               color: Colors.grey[400],
//                               fontSize: 14,
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: ListView.builder(
//                             padding: EdgeInsets.symmetric(horizontal: 16),
//                             itemCount: _searchResults.length,
//                             itemBuilder: (context, index) {
//                               final movie = _searchResults[index];
//                               return _buildSearchResultItem(movie);
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//     );
//   }

//   Widget _buildSearchResultItem(Movie movie) {
//     return GestureDetector(
//       onTap: () => _navigateToDetails(movie),
//       child: Container(
//         margin: EdgeInsets.only(bottom: 16),
//         decoration: BoxDecoration(
//           color: Color(0xFF1a1a1a),
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.3),
//               blurRadius: 6,
//               offset: Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             // Movie poster
//             ClipRRect(
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(12),
//                 bottomLeft: Radius.circular(12),
//               ),
//               child: Container(
//                 width: 80,
//                 height: 120,
//                 child: Image.network(
//                   movie.poster != 'N/A'
//                       ? movie.poster
//                       : 'https://via.placeholder.com/80x120',
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) => Container(
//                     color: Colors.grey[800],
//                     child: Icon(
//                       Icons.movie,
//                       color: Colors.grey[600],
//                       size: 30,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             // Movie details
//             Expanded(
//               child: Padding(
//                 padding: EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       movie.title,
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       'Year: ${movie.year}',
//                       style: TextStyle(
//                         color: Colors.grey[400],
//                         fontSize: 14,
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       'Type: ${movie.type.toUpperCase()}',
//                       style: TextStyle(
//                         color: Colors.grey[400],
//                         fontSize: 14,
//                       ),
//                     ),
//                     SizedBox(height: 12),
//                     Container(
//                       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                       decoration: BoxDecoration(
//                         color: Colors.red,
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                       child: Text(
//                         'View Details',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _navigateToDetails(Movie movie) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => MovieDetailsScreen(movie: movie),
//       ),
//     );
//   }
// }
