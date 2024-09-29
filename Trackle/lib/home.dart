import 'package:flutter/material.dart';
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
            icon: Icon(Icons.insert_chart), // Log Icon
            label: 'Log', // Log
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
      'sk-TE-v0368KVMrj1Ind1xuYIXmHBUNW4i5ZgLo5XhuxLT3BlbkFJyuFDfmI-TA5e-uCT3blwcrZISJVDHQcRMH39Xy09oA';

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
        // Enable scrolling
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
                // Instructions Text
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
                // Message Input Field
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
                // Send Button
                ElevatedButton(
                  onPressed: () {
                    String query = _controller.text;
                    if (query.isNotEmpty) {
                      _sendQuery(query); // Call the AI API
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent
                        .withOpacity(0.7), // Mellow, less opaque color
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    elevation: 5, // Add elevation for a more modern button look
                  ),
                  child: Text(
                    'Send',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                // AI Response Area
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
                        offset: Offset(0, 3), // changes position of shadow
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
                // Footer Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Powered by ',
                      style:
                          TextStyle(fontSize: 14, color: Colors.grey.shade600),
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
