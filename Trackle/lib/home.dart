import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_apps/device_apps.dart'; // For getting installed apps

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Application> _installedApps = [];

  @override
  void initState() {
    super.initState();
    _fetchInstalledApps();
  }

  // Fetch installed applications
  Future<void> _fetchInstalledApps() async {
    List<Application> apps = await DeviceApps.getInstalledApplications();
    setState(() {
      _installedApps = apps;
    });
  }

  // Subpages content for each tab
  List<Widget> _widgetOptions() {
    return [
      Center(child: Text('Home')), // Home
      _buildAppsPage(), // New Switches Page (manage apps)
      Center(child: Text('Log')), // Log
      Center(child: Text('Optimize')), // Energy
    ];
  }

  // Build the Installed Apps Page content
  Widget _buildAppsPage() {
    return ListView.builder(
      itemCount: _installedApps.length,
      itemBuilder: (context, index) {
        Application app = _installedApps[index];
        return ListTile(
          title: Text(app.appName),
          subtitle: Text(app.packageName),
          onTap: () async {
            // Open app settings for permission management
            DeviceApps.openAppSettings(app.packageName);
          },
        );
      },
    );
  }

  // Handle the bottom navigation bar item taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'images/logo_word.png',  // Path to the logo image
          height: 40,
        ),
        backgroundColor: const Color.fromARGB(255, 51, 96, 101),
      ),
      body: _widgetOptions().elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.toggle_on),
            label: 'Controls',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart),
            label: 'Log',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.battery_charging_full),
            label: 'Optimize',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
