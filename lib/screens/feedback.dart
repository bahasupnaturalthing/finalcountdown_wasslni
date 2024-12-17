import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FeedbackScreen extends StatefulWidget {
  final String token; // Accept token from previous page

  FeedbackScreen({required this.token});

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  int _rating = 0;
  final TextEditingController _feedbackController = TextEditingController();
  String _selectedOption = 'Definitely';
  String driverName = '';
  ImageProvider? profilePicture;

  @override
  void initState() {
    super.initState();
    fetchDriverDetails();
  }

  Future<void> fetchDriverDetails() async {
    try {
      final response = await http.get(
          Uri.parse("https://wassalni-maak.onrender.com/feedback"),
          headers: {
            'Authorization':
                'Bearer ${widget.token}', // Use token for authentication
          });
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        final base64Image = data['profilePicture'] ?? "";
        setState(() {
          driverName = "\${data['firstname']} \${data['firstname']}";
          profilePicture = base64Image.isNotEmpty
              ? MemoryImage(base64Decode(base64Image))
              : null;
        });
      } else {
        throw Exception('Failed to load driver details');
      }
    } catch (e) {
      print('Error fetching driver details: \$e');
    }
  }

  Future<void> submitFeedback() async {
    try {
      print({
        'rating': _rating,
        'comment': '\${_selectedOption} \${_feedbackController.text}',
        'receiver_id': 0,
        'id': 0,
        'giver_id': 0,
        'created_at': DateTime.now().toIso8601String(),
      });

      final response = await http.post(
        Uri.parse('https://wassalni-maak.onrender.com/feedback'),
        headers: {
          'Authorization': 'Bearer ${widget.token}', // Use the dynamic token
          'Content-Type': 'application/json'
        },
        body: json.encode({
          'rating': _rating,
          'comment': '\${_selectedOption} \${_feedbackController.text}',
          'receiver_id': 0,
          'id': 0,
          'giver_id': 0,
          'created_at': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 201) {
        _showConfirmationDialog();
      } else {
        throw Exception('Failed to submit feedback');
      }
    } catch (e) {
      print('Error submitting feedback: \$e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting feedback')),
      );
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          content: Container(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.check, color: Colors.white, size: 40),
                ),
                SizedBox(height: 16),
                Text(
                  'Feedback submitted!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Rating submitted: $_rating stars'),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    // Optionally, navigate to home or another screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  ),
                  child:
                      Text('Back home', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture and Name
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: profilePicture,
                    child: profilePicture == null
                        ? Icon(Icons.person, size: 40, color: Colors.white)
                        : null,
                  ),
                  SizedBox(height: 8),
                  Text(
                    driverName.isNotEmpty ? driverName : 'Loading...',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Rating Section
            Text('Rate your ride:', style: TextStyle(fontSize: 16)),
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.yellow,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                );
              }),
            ),
            SizedBox(height: 24),

            // Feedback Text Field
            TextField(
              controller: _feedbackController,
              decoration: InputDecoration(
                labelText: 'Submit your suggestions or complaints',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 24),

            // Future Ride Question
            Text('Would you love to ride with the same person again?',
                style: TextStyle(fontSize: 16)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildOptionButton('Definitely'),
                _buildOptionButton('May be'),
                _buildOptionButton('Never'),
              ],
            ),
            SizedBox(height: 24),

            // Submit Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  submitFeedback();
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  backgroundColor: Colors.red,
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(String option) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOption = option;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _selectedOption == option ? Colors.red : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          option,
          style: TextStyle(
            color: _selectedOption == option ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
