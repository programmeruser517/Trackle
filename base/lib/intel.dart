// Simplest implementation of Intel AI chat feature

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class IntelPage extends StatefulWidget {
  @override
  _IntelPageState createState() => _IntelPageState();
}

class _IntelPageState extends State<IntelPage> {
  final TextEditingController _controller = TextEditingController();
  String _response = '';

  Future<void> _askAI(String question) async {
    final url = Uri.parse('http://localhost:5000/ask');  // Replace with server URL if deployed
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'question': question}),
      );
      
      if (response.statusCode == 200) {
        setState(() {
          _response = jsonDecode(response.body)['response'];
        });
      } else {
        setState(() {
          _response = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _response = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Intel AI Assistant'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Ask a question',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final question = _controller.text;
                if (question.isNotEmpty) {
                  _askAI(question);  // Make the API call
                }
              },
              child: Text('Ask AI'),
            ),
            SizedBox(height: 20),
            Text(
              _response,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
