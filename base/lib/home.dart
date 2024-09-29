import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Subpages content for each tab
  static const List<Widget> _widgetOptions = <Widget>[
    Center(child: Text('Home')), // home
    Center(child: Text('Control')), // switches
    Center(child: Text('Log')), // log
    Center(child: Text('Optimize')), // energy
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trackle'),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // Home Icon
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.toggle_on), // Switch Icon (replace with image if needed)
            label: 'Switches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart), // Log Icon (replace with image if needed)
            label: 'Log',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.battery_charging_full), // Energy Icon (replace with image if needed)
            label: 'Energy',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
