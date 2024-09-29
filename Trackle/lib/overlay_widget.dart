import 'package:flutter/material.dart';

class OverlayWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.4,
      right: 10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildCircularButton(Icons.location_on, "Location"),
          SizedBox(height: 10),
          _buildCircularButton(Icons.camera_alt, "Camera"),
          SizedBox(height: 10),
          _buildCircularButton(Icons.mic, "Mic"),
        ],
      ),
    );
  }

  // Circular button widget
  Widget _buildCircularButton(IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        // Action for the button goes here (e.g., open permissions settings)
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blueAccent.withOpacity(0.7), // Button color with transparency
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 30),
      ),
    );
  }
}
