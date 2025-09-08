// services/movie_service.dart
import 'dart:convert';
import 'package:book_movies/models/movie_details.dart';
import 'package:http/http.dart' as http;
import 'package:book_movies/models/movie.dart';

class MovieService {
  static const String _apiKey = 'fabf4425'; // Your API key
  static const String _baseUrl = 'https://www.omdbapi.com/';

  Future<List<Movie>> searchMovies(String query, int page) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?apikey=$_apiKey&s=$query&page=$page'),
      );
      
      print('API URL: $_baseUrl?apikey=$_apiKey&s=$query&page=$page'); // Debug print
      print('Response Status: ${response.statusCode}'); // Debug print
      print('Response Body: ${response.body}'); // Debug print
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Response'] == 'True') {
          return (data['Search'] as List)
              .map((movie) => Movie.fromJson(movie))
              .toList();
        } else {
          print('API Error: ${data['Error']}'); // Debug print
          return [];
        }
      }
      return [];
    } catch (e) {
      print('Exception: $e'); // Debug print
      return [];
    }
  }

  Future<MovieDetails?> getMovieDetails(String imdbID) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?apikey=$_apiKey&i=$imdbID&plot=full'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Response'] == 'True') {
          return MovieDetails.fromJson(data);
        }
      }
      return null;
    } catch (e) {
      print('Exception getting movie details: $e');
      return null;
    }
  }
}
