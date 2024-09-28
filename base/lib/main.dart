import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trackle',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 51, 96, 101)),
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

  // Starts the timer to fade the logo
  void _startLogoFadeTimer() {
    // After 3 seconds, start fading the logo
    Timer(const Duration(seconds: 3), () {
      setState(() {
        _opacity = 0.0;
      });
    });

    // After 5 seconds, hide the logo completely
    Timer(const Duration(seconds: 5), () {
      setState(() {
        _logoVisible = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
          255, 70, 108, 105), // Background color changed to light blue
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Fading logo animation (only visible if _logoVisible is true)
            if (_logoVisible)
              AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(
                    seconds: 2), // Duration for the fade-out effect
                child: Image.asset(
                  'images/logo_word_motto-curved.png', // Add your logo to the images folder
                  width: 300,
                  height: 300,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
