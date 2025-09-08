// screens/movie_details_screen.dart
import 'package:book_movies/models/movie.dart';
import 'package:book_movies/screens/booking_screen.dart'; // Add this import
import 'package:flutter/material.dart';
import 'package:book_movies/screens/booking_screen.dart'; // Add this line


class MovieDetailsScreen extends StatefulWidget {
  final Movie movie;

  MovieDetailsScreen({required this.movie});

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  String? _selectedTime;
  String? _selectedDate;
  List<String> _availableDates = [];
  List<String> _availableTimes = [
    '09:30 AM', '09:40 AM', '09:50 AM', '10:00 AM',
    '12:30 PM', '01:40 PM', '03:50 PM', '06:00 PM'
  ];

  @override
  void initState() {
    super.initState();
    _generateAvailableDates();
  }

  void _generateAvailableDates() {
    final now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      final date = now.add(Duration(days: i));
      _availableDates.add(
        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}',
      );
    }
    _selectedDate = _availableDates.first;
  }

  void _navigateToBooking(BuildContext context) {
    if (_selectedTime == null || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select date and time')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingScreen(
          movie: widget.movie,
          selectedTime: _selectedTime!,
          selectedDate: _selectedDate!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: Colors.black,
            iconTheme: IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.movie.poster != 'N/A' 
                        ? widget.movie.poster 
                        : 'https://via.placeholder.com/300x450?text=No+Image',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(
                          color: Colors.grey[800],
                          child: Icon(
                            Icons.movie,
                            size: 100,
                            color: Colors.grey[600],
                          ),
                        ),
                  ),
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
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.black,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Movie Title and Basic Info
                  Text(
                    widget.movie.title,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      SizedBox(width: 4),
                      Text(
                        '8.5',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 16),
                      Text(
                        widget.movie.year,
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      SizedBox(width: 16),
                      Text(
                        '2h 15min',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  
                  Text(
                    'Action, Adventure, Sci-Fi',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Date Selection
                  Text(
                    'Select Date',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildDateSelector(),
                  SizedBox(height: 20),

                  // Showtimes
                  Text(
                    'Select Showtime',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildShowtimes(),
                  SizedBox(height: 30),

                  // Book Now Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => _navigateToBooking(context),
                      child: Text(
                        'BOOK NOW',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _availableDates.length,
        itemBuilder: (context, index) {
          final date = _availableDates[index];
          final isSelected = _selectedDate == date;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = date;
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: 12),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.red : Colors.grey[800],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? Colors.red : Colors.grey[600]!,
                ),
              ),
              child: Center(
                child: Text(
                  date,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[300],
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShowtimes() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 2.2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _availableTimes.length,
      itemBuilder: (context, index) {
        final time = _availableTimes[index];
        final isSelected = _selectedTime == time;
        
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedTime = time;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? Colors.red : Colors.grey[800],
              border: Border.all(
                color: isSelected ? Colors.red : Colors.grey[600]!,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                time,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[300],
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
