import 'package:flutter/material.dart';

class OverlayWidget extends StatefulWidget {
  @override
  _OverlayWidgetState createState() => _OverlayWidgetState();
}

class _OverlayWidgetState extends State<OverlayWidget> {
  Color _locationButtonColor = Colors.blueAccent.withOpacity(0.7);
  Color _cameraButtonColor = Colors.blueAccent.withOpacity(0.7);
  Color _micButtonColor = Colors.blueAccent.withOpacity(0.7);

  // Helper method to change button color when clicked
  void _changeButtonColor(String buttonType) {
    setState(() {
      switch (buttonType) {
        case "Location":
          _locationButtonColor =
              _locationButtonColor == Colors.blueAccent.withOpacity(0.7)
                  ? Colors.green.withOpacity(0.7)
                  : Colors.blueAccent.withOpacity(0.7);
          break;
        case "Camera":
          _cameraButtonColor =
              _cameraButtonColor == Colors.blueAccent.withOpacity(0.7)
                  ? Colors.green.withOpacity(0.7)
                  : Colors.blueAccent.withOpacity(0.7);
          break;
        case "Mic":
          _micButtonColor =
              _micButtonColor == Colors.blueAccent.withOpacity(0.7)
                  ? Colors.green.withOpacity(0.7)
                  : Colors.blueAccent.withOpacity(0.7);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.4,
      right: 10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildCircularButton(Icons.location_on, "Location", _locationButtonColor),
          SizedBox(height: 10),
          _buildCircularButton(Icons.camera_alt, "Camera", _cameraButtonColor),
          SizedBox(height: 10),
          _buildCircularButton(Icons.mic, "Mic", _micButtonColor),
        ],
      ),
    );
  }

  // Circular button widget with color passed as a parameter
  Widget _buildCircularButton(IconData icon, String label, Color buttonColor) {
    return GestureDetector(
      onTap: () {
        _changeButtonColor(label); // Change color on tap
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: buttonColor, // Dynamic color based on state
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
