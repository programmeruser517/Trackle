import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_apps/device_apps.dart';

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

  // Handle permission management
  Future<void> _togglePermission(Permission permission) async {
    PermissionStatus status = await permission.request();
    setState(() {
      // Update the permission status if necessary
    });
  }

  // List of widget options for each tab
  List<Widget> _widgetOptions() {
    return [
      Center(child: Text('Home')),
      _buildSwitchesPage(), // Switches Page
      _buildAppsPage(), // New Page for Installed Apps
      Center(child: Text('Log')),
    ];
  }

  // Build the Switches Page content for managing permissions
  Widget _buildSwitchesPage() {
    return ListView(
      children: [
        // Add your permission switches here
      ],
    );
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
            DeviceApps.openApp(app.packageName);
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
        title: Text('Trackle'),
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
            label: 'Switches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            label: 'Apps',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart),
            label: 'Log',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}