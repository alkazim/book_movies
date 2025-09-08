// screens/home_screen.dart
import 'package:book_movies/models/movie.dart';
import 'package:book_movies/services/movie_service.dart';
import 'package:book_movies/widgets/movie_card.dart';
import 'package:book_movies/screens/movie_details_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MovieService _movieService = MovieService();
  final TextEditingController _searchController = TextEditingController();
  List<Movie> _featuredMovies = [];
  List<Movie> _trendingMovies = [];
  List<Movie> _upcomingMovies = [];
  List<Movie> _carouselMovies = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadHomeContent();
  }

  void _loadHomeContent() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final featured = await _movieService.searchMovies('Avengers', 1);
      final trending = await _movieService.searchMovies('Spider-Man', 1);
      final upcoming = await _movieService.searchMovies('Batman', 1);
      final carousel = await _movieService.searchMovies('Marvel', 1);
      
      setState(() {
        _featuredMovies = featured.take(1).toList();
        _trendingMovies = trending.take(6).toList();
        _upcomingMovies = upcoming.take(6).toList();
        _carouselMovies = carousel.take(5).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading movies: $e');
    }
  }

  void _searchMovies(String query) {
    if (query.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultsScreen(query: query),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.red))
          : CustomScrollView(
              slivers: [
                _buildHeroSection(),
                
                SliverToBoxAdapter(child: _buildTrendingCarousel()),
                SliverToBoxAdapter(child: _buildSectionTitle('Trending Movie Near You')),
                // SliverToBoxAdapter(child: _buildTrendingCarousel()),
                SliverToBoxAdapter(child: _buildCarouselSection()),
                SliverToBoxAdapter(child: _buildSectionTitle('Upcoming')),
                SliverToBoxAdapter(child: _buildUpcomingGrid()),
                SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildHeroSection() {
    return SliverAppBar(
      expandedHeight: 520,
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Background with gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF8A2387),
                    Color(0xFFE94057),
                    Color(0xFFF27121),
                  ],
                ),
              ),
            ),
            
            // Featured movie background
            if (_featuredMovies.isNotEmpty)
              Positioned.fill(
                child: Image.network(
                  _featuredMovies.first.poster != 'N/A' 
                      ? _featuredMovies.first.poster 
                      : 'https://via.placeholder.com/400x600',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(),
                ),
              ),
            
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.7),
                    Colors.black,
                  ],
                ),
              ),
            ),

            // Glass effect search bar at top
            Positioned(
              top: 50,
              left: 16,
              right: 16,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search Movie...',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                        prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.7)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      onSubmitted: _searchMovies,
                    ),
                  ),
                ),
              ),
            ),

            // Hero content
            Positioned(
              bottom: 100,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  if (_featuredMovies.isNotEmpty) ...[
                    Text(
                      _featuredMovies.first.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                  ],
                  
                  // Action chips
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildActionChip('Drama'),
                      SizedBox(width: 12),
                      _buildActionChip('12+', isHighlighted: true),
                      SizedBox(width: 12),
                      _buildActionChip('Drama'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselSection() {
    if (_carouselMovies.isEmpty) return SizedBox.shrink();
    
    return Container(
      height: 180,
      margin: EdgeInsets.only(top: 20, bottom: 10),
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.7),
        itemCount: _carouselMovies.length,
        itemBuilder: (context, index) {
          final movie = _carouselMovies[index];
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 15,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () => _navigateToDetails(movie),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      movie.poster != 'N/A' 
                          ? movie.poster 
                          : 'https://via.placeholder.com/300x180',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[800],
                        child: Icon(Icons.movie, color: Colors.grey[600], size: 40),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 15,
                      left: 15,
                      right: 15,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 5),
                          Text(
                            movie.year,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'NEW',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionChip(String label, {bool isHighlighted = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isHighlighted ? Colors.white.withOpacity(0.3) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

Widget _buildTrendingCarousel() {
  return CarouselSlider.builder(
    itemCount: _trendingMovies.length,
    options: CarouselOptions(
      height: 300, // Increased height for enlarged center item
      autoPlay: true,
      autoPlayInterval: Duration(seconds: 4),
      autoPlayAnimationDuration: Duration(milliseconds: 800),
      autoPlayCurve: Curves.fastOutSlowIn,
      enlargeCenterPage: true, // Makes center item larger
      enlargeFactor: 0.3, // Controls enlargement amount (0.0 to 1.0)
      viewportFraction: 0.6, // Shows parts of adjacent items
      enableInfiniteScroll: true,
      scrollDirection: Axis.horizontal,
      pauseAutoPlayOnTouch: true, // Changed from Duration to bool
    ),
    itemBuilder: (context, index, realIndex) {
      final movie = _trendingMovies[index];
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: GestureDetector(
          onTap: () => _navigateToDetails(movie),
          child: Container(
            width: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  // Background gradient
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF2C3E50), Color(0xFF34495E)],
                      ),
                    ),
                  ),
                  
                  // Movie image
                  Positioned.fill(
                    child: Image.network(
                      movie.poster != 'N/A' 
                          ? movie.poster 
                          : 'https://via.placeholder.com/300x200',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[800],
                        child: Icon(Icons.movie, color: Colors.grey[600], size: 40),
                      ),
                    ),
                  ),
                  
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                  
                  // Movie title
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          movie.year,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}



  Widget _buildUpcomingGrid() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.65,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: _upcomingMovies.length > 6 ? 6 : _upcomingMovies.length,
        itemBuilder: (context, index) {
          final movie = _upcomingMovies[index];
          return GestureDetector(
            onTap: () => _navigateToDetails(movie),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  children: [
                    // Movie poster
                    Positioned.fill(
                      child: Image.network(
                        movie.poster != 'N/A' ? movie.poster : 'https://via.placeholder.com/100x150',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[800],
                          child: Icon(Icons.movie, color: Colors.grey[600], size: 30),
                        ),
                      ),
                    ),
                    
                    // Book Now button
                    Positioned(
                      bottom: 8,
                      left: 8,
                      right: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Book Now',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Color(0xFF1a1a1a),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Home', true),
          _buildNavItem(Icons.search, 'Find', false),
          _buildNavItem(Icons.bookmark_border, 'Saved', false),
          _buildNavItem(Icons.person_outline, 'Profile', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isSelected ? Colors.red : Colors.grey[400],
          size: 24,
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.red : Colors.grey[400],
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        if (isSelected)
          Container(
            width: 4,
            height: 4,
            margin: EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }

  void _navigateToDetails(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailsScreen(movie: movie),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class SearchResultsScreen extends StatefulWidget {
  final String query;

  SearchResultsScreen({required this.query});

  @override
  _SearchResultsScreenState createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final MovieService _movieService = MovieService();
  List<Movie> _searchResults = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _performSearch();
  }

  void _performSearch() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final results = await _movieService.searchMovies(widget.query, 1);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
      print('Search error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Search: ${widget.query}',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: Colors.red),
            )
          : _hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 64,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Something went wrong',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Please try again later',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _performSearch,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text(
                          'Retry',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
              : _searchResults.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            color: Colors.grey[400],
                            size: 64,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No results found',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Try searching with different keywords',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'Found ${_searchResults.length} results',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              final movie = _searchResults[index];
                              return _buildSearchResultItem(movie);
                            },
                          ),
                        ),
                      ],
                    ),
    );
  }

  Widget _buildSearchResultItem(Movie movie) {
    return GestureDetector(
      onTap: () => _navigateToDetails(movie),
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Color(0xFF1a1a1a),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Movie poster
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Container(
                width: 80,
                height: 120,
                child: Image.network(
                  movie.poster != 'N/A'
                      ? movie.poster
                      : 'https://via.placeholder.com/80x120',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[800],
                    child: Icon(
                      Icons.movie,
                      color: Colors.grey[600],
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
            // Movie details
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Year: ${movie.year}',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Type: ${movie.type.toUpperCase()}',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'View Details',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDetails(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailsScreen(movie: movie),
      ),
    );
  }
}