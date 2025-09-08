import 'dart:async';
import 'package:flutter/material.dart';
import 'onboarding_screen.dart'; // Updated import

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.0, 0.6, curve: Curves.easeInOut),
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.0, 0.8, curve: Curves.elasticOut),
    ));

    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.3, 1.0, curve: Curves.easeInOut),
    ));
    
    _animationController.forward();
    
    // Navigate to onboarding screen after 3 seconds
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.black,
              Colors.grey[900]!,
              Colors.black,
            ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App Logo with rotation and glow effect
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              Colors.red,
                              Colors.redAccent,
                              Colors.red[800]!,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.4),
                              blurRadius: 25,
                              spreadRadius: 5,
                              offset: Offset(0, 0),
                            ),
                            BoxShadow(
                              color: Colors.red.withOpacity(0.2),
                              blurRadius: 40,
                              spreadRadius: 10,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        child: RotationTransition(
                          turns: _rotateAnimation,
                          child: Icon(
                            Icons.movie,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 30),
                      
                      // App Name with typewriter effect
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [Colors.red, Colors.redAccent, Colors.white],
                        ).createShader(bounds),
                        child: Text(
                          'Movie Explorer',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 10),
                      
                      // Subtitle with fade effect
                      FadeTransition(
                        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: Interval(0.5, 1.0, curve: Curves.easeIn),
                          ),
                        ),
                        child: Text(
                          'Discover • Book • Enjoy',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 50),
                      
                      // Loading animation
                      FadeTransition(
                        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: Interval(0.7, 1.0, curve: Curves.easeIn),
                          ),
                        ),
                        child: Container(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                            strokeWidth: 3,
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 20),
                      
                      // Loading text
                      FadeTransition(
                        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: Interval(0.8, 1.0, curve: Curves.easeIn),
                          ),
                        ),
                        child: Text(
                          'Loading amazing movies...',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
