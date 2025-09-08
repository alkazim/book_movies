// screens/onboarding_screen.dart
import 'package:book_movies/screens/home_screen.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: "Catch Every\nBlockbuster Without\nthe Queue",
      backgroundImage: "lib/asset/images/onboarding_image1.png",
      backgroundColor: Color(0xFF2C3E50),
      textColor: Colors.white,
      isAsset: true,
    ),
    OnboardingPage(
      title: "Because\nMoviesDeserve\nMore Than Queues",
      backgroundImage: "lib/asset/images/onboarding_image 2.png",
      backgroundColor: Color(0xFF3498DB),
      textColor: Colors.white,
      isAsset: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _buildOnboardingPage(_pages[index]);
            },
          ),
          
          // Bottom Section with Next Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 120,
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  // Page Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildPageIndicators(),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Next Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      child: Text(
                        _currentPage == _pages.length - 1 ? 'Get Started' : 'NEXT',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                          side: BorderSide(color: Colors.white.withOpacity(0.5)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingPage page) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            page.backgroundColor,
            page.backgroundColor.withOpacity(0.8),
            Colors.black.withOpacity(0.9),
          ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          if (page.backgroundImage != null)
            page.isAsset
              ? Image.asset(
                  page.backgroundImage!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: page.backgroundColor,
                  ),
                )
              : Image.network(
                  page.backgroundImage!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: page.backgroundColor,
                  ),
                ),
          
          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  page.backgroundColor.withOpacity(0.3),
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
          
          // Content
          Positioned(
            bottom: 200,
            left: 30,
            right: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  page.title,
                  style: TextStyle(
                    color: page.textColor,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageIndicators() {
    List<Widget> indicators = [];
    for (int i = 0; i < _pages.length; i++) {
      indicators.add(
        Container(
          width: _currentPage == i ? 20 : 8,
          height: 8,
          margin: EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: _currentPage == i ? Colors.white : Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      );
    }
    return indicators;
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to Home Screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class OnboardingPage {
  final String title;
  final String? backgroundImage;
  final Color backgroundColor;
  final Color textColor;
  final bool isAsset;

  OnboardingPage({
    required this.title,
    this.backgroundImage,
    required this.backgroundColor,
    required this.textColor,
    this.isAsset = false,
  });
}
