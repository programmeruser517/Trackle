import 'package:flutter/material.dart';
import 'dart:async';
import 'package:overlay_support/overlay_support.dart'; // Import overlay support
import 'home.dart'; // Import home.dart
import 'overlay_widget.dart'; // Import the new overlay widget

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        title: 'Trackle',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 51, 96, 101)),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  double _opacity = 1.0; // Initial opacity for the logo
  bool _logoVisible = true; // Whether the logo is visible or not
  OverlaySupportEntry? _overlayEntry; // For handling overlay removal

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startLogoFadeTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
        MaterialPageRoute(
          builder: (context) => HomeScreen(), // Ensure HomeScreen is imported
        ),
      );
    });
  }

  // Detect if app goes to background or comes to foreground
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // App in background - show the overlay with buttons
      _overlayEntry = showOverlay(
        (context, t) {
          return OverlayWidget();
        },
        duration: Duration.zero, // Keep it visible indefinitely
      );
    } else if (state == AppLifecycleState.resumed) {
      // App in foreground - remove the overlay
      _overlayEntry?.dismiss(); // Remove the overlay
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 51, 96, 101), // Background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Fading logo animation (only visible if _logoVisible is true)
            if (_logoVisible)
              AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(seconds: 2), // Fade duration
                child: Image.asset(
                  'images/logo_word_motto-curved.png', // Logo path
                  width: 300, // Increased width
                  height: 300, // Increased height
                ),
              ),
          ],
        ),
      ),
    );
  }
}
