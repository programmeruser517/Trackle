import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // for encoding the query as JSON


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Subpages content for each tab
  static final List<Widget> _widgetOptions = <Widget>[
    AIPromptPage(),
    ControlPage(), // Control page with toggles
    OptimizePage(), // energy
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
        title: Image.asset(
          'images/logo_word.png', // Path to the logo image
          height: 40,
        ),
        backgroundColor: const Color.fromARGB(255, 51, 96, 101),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // Home Icon
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.toggle_on), // Switch Icon
            label: 'Controls', // Switches
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.battery_charging_full), // Energy Icon
            label: 'Optimize', // Energy
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

class AIPromptPage extends StatefulWidget {
  @override
  _AIPromptPageState createState() => _AIPromptPageState();
}

class _AIPromptPageState extends State<AIPromptPage> {
  final TextEditingController _controller = TextEditingController();
  String _response = 'Response will generate here.';
  String apiKey =
      'sk-6d17CHKVpPzd2rNyIvyvb-fPez0xP74Z8Jml67t83lT3BlbkFJnZmXlqsvcAR2_rcb-SgJlIikO-vmFT5qVo3dB__EUA';

  // This function sends a query to the API and fetches the response
  Future<void> _sendQuery(String query) async {
    const apiUrl =
        'https://api.openai.com/v1/chat/completions'; // Correct  API endpoint for gpt-3.5-turbo
    bool retry = true;
    int retries = 0;
    const maxRetries = 3;

    while (retry && retries < maxRetries) {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {"role": "system", "content": "You are an AI assistant."},
            {"role": "user", "content": query}
          ],
          "max_tokens": 150,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _response =
              jsonDecode(response.body)['choices'][0]['message']['content'];
        });
        retry = false; // Successfully got a response, stop retrying
      } else if (response.statusCode == 429) {
        setState(() {
          _response = 'Rate limit hit, retrying...';
        });
        retries += 1;
        await Future.delayed(
            Duration(seconds: 2)); // Wait 2 seconds before retrying
      } else {
        setState(() {
          _response =
              'Error: Unable to communicate with AI (Code: ${response.statusCode})';
        });
        retry = false; // No need to retry for other errors
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1.5), // Light border around entire area
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Welcome to Trackle!\n\n', // Bold this part
                          style: TextStyle(
                            fontWeight: FontWeight.bold, // Make it bold
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        TextSpan(
                          text:
                              'Try asking me things like:\n\n- How to turn off the microphone for "z"?\n'
                              '- What are the privacy settings for "y" app?\n'
                              '- How to disable geolocation for "x" app?',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Message Trackle', // New placeholder text
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    String query = _controller.text;
                    if (query.isNotEmpty) {
                      _sendQuery(query); // Call the AI API
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent.withOpacity(0.7),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    'Send',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    _response, // AI response
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Powered by ',
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    ),
                    Image.asset(
                      'images/intel_ai_logo.jpg',
                      height: 30,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ControlPage extends StatefulWidget {
  @override
  _ControlPageState createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  final List<Map<String, dynamic>> _apps = [
    {'name': 'Facebook', 'isOn': false},
    {'name': 'Google', 'isOn': false},
    {'name': 'Instagram', 'isOn': false},
    {'name': 'WhatsApp', 'isOn': false},
    {'name': 'Twitter', 'isOn': false},
    {'name': 'LinkedIn', 'isOn': false},
    {'name': 'Snapchat', 'isOn': false},
    {'name': 'TikTok', 'isOn': false},
    {'name': 'Pinterest', 'isOn': false},
    {'name': 'Reddit', 'isOn': false},
    {'name': 'Tumblr', 'isOn': false},
    {'name': 'YouTube', 'isOn': false},
    {'name': 'Spotify', 'isOn': false},
    {'name': 'Netflix', 'isOn': false},
    {'name': 'Twitch', 'isOn': false},
    {'name': 'Amazon', 'isOn': false},
    {'name': 'eBay', 'isOn': false},
    {'name': 'PayPal', 'isOn': false},
    {'name': 'Uber', 'isOn': false},
    {'name': 'Lyft', 'isOn': false},
    {'name': 'Airbnb', 'isOn': false},
    {'name': 'Booking', 'isOn': false},
    {'name': 'Expedia', 'isOn': false},
    {'name': 'TripAdvisor', 'isOn': false},
    {'name': 'Yelp', 'isOn': false},
    {'name': 'Zomato', 'isOn': false},
    {'name': 'Swiggy', 'isOn': false},
    {'name': 'Zomato', 'isOn': false},
    {'name': 'Ola', 'isOn': false},
    {'name': 'Uber Eats', 'isOn': false},
    {'name': 'DoorDash', 'isOn': false},
    {'name': 'Grubhub', 'isOn': false},
    {'name': 'Postmates', 'isOn': false},
    {'name': 'Instacart', 'isOn': false},
    {'name': 'Walmart', 'isOn': false},
    {'name': 'Target', 'isOn': false},
    {'name': 'Best Buy', 'isOn': false},
    {'name': 'Home Depot', 'isOn': false},
    {'name': 'Lowe\'s', 'isOn': false},
    {'name': 'IKEA', 'isOn': false},
    {'name': 'Costco', 'isOn': false},
    {'name': 'Safeway', 'isOn': false},
    {'name': 'Kroger', 'isOn': false},
    {'name': 'Whole Foods', 'isOn': false},
    {'name': 'Starbucks', 'isOn': false},
    {'name': 'McDonald\'s', 'isOn': false},
    {'name': 'Burger King', 'isOn': false},
    {'name': 'Subway', 'isOn': false},
    {'name': 'Pizza Hut', 'isOn': false},
    {'name': 'Domino\'s', 'isOn': false},
    {'name': 'Papa John\'s', 'isOn': false},
    {'name': 'Chipotle', 'isOn': false},
    {'name': 'Taco Bell', 'isOn': false},
    {'name': 'KFC', 'isOn': false},
    {'name': 'Wendy\'s', 'isOn': false},
    {'name': 'Dunkin\'', 'isOn': false},
    {'name': 'Starbucks', 'isOn': false},
    {'name': 'Tim Hortons', 'isOn': false},
    {'name': 'Panera Bread', 'isOn': false},
    {'name': 'Dairy Queen', 'isOn': false},
    {'name': 'Sonic Drive-In', 'isOn': false},
    {'name': 'Arby\'s', 'isOn': false},
    {'name': 'Jack in the Box', 'isOn': false},
    {'name': 'Carl\'s Jr.', 'isOn': false},
    {'name': 'Hardee\'s', 'isOn': false},
    {'name': 'In-N-Out Burger', 'isOn': false},
    {'name': 'Five Guys', 'isOn': false},
    {'name': 'Whataburger', 'isOn': false},
    {'name': 'White Castle', 'isOn': false},
    {'name': 'Culver\'s', 'isOn': false},
    {'name': 'Steak \'n Shake', 'isOn': false},
    {'name': 'Shake Shack', 'isOn': false},
    {'name': 'Wawa', 'isOn': false},
    {'name': 'Sheetz', 'isOn': false},
    {'name': 'QuikTrip', 'isOn': false},
    {'name': 'RaceTrac', 'isOn': false},
    {'name': '7-Eleven', 'isOn': false},
    {'name': 'Circle K', 'isOn': false},
    {'name': 'Shell', 'isOn': false},
    {'name': 'Chevron', 'isOn': false},
    // Add more apps if necessary
  ];

  void _toggleButton(int index) {
    setState(() {
      _apps[index]['isOn'] = !_apps[index]['isOn'];
    });
    _showToggleDialog(_apps[index]['name'], _apps[index]['isOn']);
  }

  void _showToggleDialog(String appName, bool isOn) {
    String message = isOn
        ? "$appName's permission to data is successfully turned on"
        : "$appName's permission to data is successfully turned off";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Permission Status'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _apps.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_apps[index]['name']),
          trailing: TextButton(
            onPressed: () {
              _toggleButton(index);
            },
            child: Text(
              _apps[index]['isOn'] ? 'ON' : 'OFF',
              style: TextStyle(
                color: _apps[index]['isOn'] ? Colors.green : Colors.red,
              ),
            ),
          ),
        );
      },
    );
  }
}

class OptimizePage extends StatefulWidget {
  @override
  _OptimizePageState createState() => _OptimizePageState();
}

class _OptimizePageState extends State<OptimizePage> {
  static const platform = MethodChannel('app.battery/energy');
  Map<String, double> _batteryStats = {};
  bool _loading = true;
  String _aiResponse = '';

  // Fetch battery usage data from Android
  Future<void> _getBatteryStats() async {
    try {
      final Map<dynamic, dynamic> result = await platform.invokeMethod('getBatteryStats');
      setState(() {
        _batteryStats = Map<String, double>.from(result);
        _loading = false;
      });
      _queryAI(); // Query AI after getting the battery stats
    } on PlatformException catch (e) {
      print("Failed to get battery stats: '${e.message}'");
      setState(() {
        _batteryStats = {};
        _loading = false;
      });
    }
  }

  // Query AI for recommendations based on top 5 apps and energy consumption
  Future<void> _queryAI() async {
    final top5Apps = _batteryStats.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value)); // Sort by energy consumption
    final top5 = top5Apps.take(5).map((e) => '${e.key}: ${e.value.toStringAsFixed(2)} mAh').join(", ");
    final String apiKey = 'sk-6d17CHKVpPzd2rNyIvyvb-fPez0xP74Z8Jml67t83lT3BlbkFJnZmXlqsvcAR2_rcb-SgJlIikO-vmFT5qVo3dB__EUA';
    final String query = 'The following apps consumed the most battery in the past 24 hours: $top5. Recommend two apps to revoke permissions from.';

    const apiUrl = 'https://api.openai.com/v1/chat/completions';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {"role": "system", "content": "You are an AI assistant."},
            {"role": "user", "content": query}
          ],
          "max_tokens": 150,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _aiResponse = jsonDecode(response.body)['choices'][0]['message']['content'];
        });
      } else {
        setState(() {
          _aiResponse = 'Error: Unable to communicate with AI (Code: ${response.statusCode})';
        });
      }
    } catch (e) {
      setState(() {
        _aiResponse = 'Error: Unable to reach the AI.';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getBatteryStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Optimize Energy Usage'),
        backgroundColor: Colors.green,
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _batteryStats.isEmpty
                    ? Center(child: Text('No battery usage data available'))
                    : Expanded(
                        child: ListView.builder(
                          itemCount: _batteryStats.length,
                          itemBuilder: (context, index) {
                            String appName = _batteryStats.keys.elementAt(index);
                            double energyConsumed = _batteryStats[appName] ?? 0.0;

                            // Format the app name if it contains package names
                            String formattedAppName = appName.split('.').last.capitalize();

                            return ListTile(
                              title: Text(formattedAppName),
                              trailing: Text('${energyConsumed.toStringAsFixed(2)} mAh'),
                            );
                          },
                        ),
                      ),
                SizedBox(height: 20),
                _aiResponse.isEmpty
                    ? CircularProgressIndicator()
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'AI Recommendation:\n$_aiResponse',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
              ],
            ),
    );
  }
}

// Extension method to capitalize the first letter of a string
extension StringCasingExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}