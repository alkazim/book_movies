// screens/booking_screen.dart
import 'package:book_movies/models/movie.dart';
import 'package:flutter/material.dart';

class BookingScreen extends StatelessWidget {
  final Movie movie;
  final String selectedTime;
  final String selectedDate;

  BookingScreen({
    required this.movie,
    required this.selectedTime,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              // Back button
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
              ),
              
              SizedBox(height: 40),
              
              // Success checkmark
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Container(
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
              
              SizedBox(height: 30),
              
              // Booking Successful text
              Text(
                'Booking Successful',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              
              SizedBox(height: 8),
              
              // Movie subtitle
              Text(
                'For Avengers',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              
              SizedBox(height: 40),
              
              // Movie Ticket
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Movie Poster Section
                    Container(
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Movie poster image - replace with actual poster
                            Image.network(
                              movie.poster ?? 'https://example.com/default-poster.jpg',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                // Fallback gradient background
                                return Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFF2E1065),
                                        Color(0xFF7C3AED),
                                        Color(0xFFDB2777),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            // Overlay with movie title
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
                            // Movie title overlay
                            Positioned(
                              bottom: 20,
                              left: 20,
                              right: 20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Doctor Stran-ge',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'in the Multiverse of Madness',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Ticket Details Section
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Date, Time, Row, Seats
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Date: April 23',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Row: 2',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Time: 6 pm',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Seats: 9, 10',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          
                          SizedBox(height: 25),
                          
                          // Barcode
                          Container(
                            height: 60,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(35, (index) {
                                return Container(
                                  width: index % 5 == 0 ? 3 : (index % 3 == 0 ? 2 : 1),
                                  height: 60,
                                  margin: EdgeInsets.symmetric(horizontal: 0.5),
                                  color: Colors.black,
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              Spacer(),
              
              // Done button would be here if needed
            ],
          ),
        ),
      ),
    );
  }
}
