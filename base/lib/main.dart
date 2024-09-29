import 'package:flutter/material.dart';
import 'dart:async';
import 'home.dart'; // Import home.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 51, 96, 101)),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _opacity = 1.0; // Initial opacity for the logo
  bool _logoVisible = true; // Whether the logo is visible or not

  @override
  void initState() {
    super.initState();
    _startLogoFadeTimer();
  }

  // Starts the timer to fade the logo and redirect
  void _startLogoFadeTimer() {
    // After 3 seconds, start fading the logo
    Timer(const Duration(seconds: 3), () {
      setState(() {
        _opacity = 0.0;
      });
    });

    // After 5 seconds, hide the logo completely and navigate to HomePage
    Timer(const Duration(seconds: 5), () {
      setState(() {
        _logoVisible = false;
      });

      // Redirect to HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()), // Navigate to HomePage from home.dart
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 51, 96, 101), // Background color changed to light blue
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Fading logo animation (only visible if _logoVisible is true)
            if (_logoVisible)
              AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(seconds: 2), // Duration for the fade-out effect
                child: Image.asset(
                  'images/logo_word_motto-curved.png', // Your logo path
                  width: 300, // Increased the width by a factor of 3
                  height: 300, // Increased the height by a factor of 3
                ),
              ),
          ],
        ),
      ),
    );
  }
}