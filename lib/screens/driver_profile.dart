import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DriverProfilePage extends StatefulWidget {
  final int driverId;

  DriverProfilePage({required this.driverId});
  @override
  _DriverProfilePageState createState() => _DriverProfilePageState();
}

class _DriverProfilePageState extends State<DriverProfilePage> {
  String driverName = "Loading...";
  String phoneNumber = "";
  Uint8List? profilePicture;
  double rating = 0.0;
  int evaluations = 0;
  List<dynamic> feedbacks = [];

  @override
  void initState() {
    super.initState();
    print("Driver ID: ${widget.driverId}");
    fetchDriver();
    fetchFeedbacks();
  }

  Future<void> fetchDriver() async {
    final url =
        "https://wassalni-maak.onrender.com/user/10"; // Use driverId dynamically
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        setState(() {
          driverName =
              data['firstName'] + " " + data['lastName'] ?? "Unknown Driver";
          phoneNumber = data['phoneNumber'] ?? "N/A";
          final base64Image = data['profilePicture'] ?? "";
          profilePicture = base64Image.isNotEmpty
              ? base64Decode(base64Image)
              : null; // Decode image safely
          rating = double.tryParse(data['rating'].toString()) ?? 0.0;
        });
      } else {
        print("Failed to load driver data");
      }
    } catch (e) {
      print("Error fetching driver data: $e");
    }
  }

  Future<void> fetchFeedbacks() async {
    // Example feedback fetch (replace with your API logic)
    final feedbackUrl =
        "https://wassalni-maak.onrender.com/user/${widget.driverId}/feedbacks";
    try {
      final response = await http.get(Uri.parse(feedbackUrl));
      if (response.statusCode == 200) {
        setState(() {
          feedbacks = jsonDecode(response.body);
        });
      }
    } catch (e) {
      print("Error fetching feedbacks: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // Top Section with Profile Info
          Container(
            color: Colors.red,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Profile Picture
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: profilePicture != null
                      ? CircleAvatar(
                          radius: 48,
                          backgroundImage: MemoryImage(profilePicture!),
                        )
                      : CircleAvatar(
                          radius: 48,
                          backgroundColor: Colors.grey,
                          child:
                              Icon(Icons.person, size: 48, color: Colors.white),
                        ),
                ),
                SizedBox(height: 10),
                // Name
                Text(
                  driverName,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                // Ratings and Phone Number
                Text(
                  '⭐ $rating / 5 - $evaluations Ratings',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Phone number: $phoneNumber',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Feedbacks Section
          Expanded(
            child: feedbacks.isEmpty
                ? Center(
                    child: CircularProgressIndicator()) // Loading feedbacks
                : ListView.builder(
                    itemCount: feedbacks.length,
                    itemBuilder: (context, index) {
                      final feedback = feedbacks[index];
                      return ListTile(
                        leading: Icon(Icons.feedback, color: Colors.red),
                        title: Text(
                          feedback['username'] ?? "Anonymous",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(feedback['comment'] ?? "No comment"),
                        trailing: Text(
                          "${feedback['rating']} ⭐",
                          style: TextStyle(color: Colors.green),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Your rides',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Publish',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inbox),
            label: 'Inbox',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          print("Tab $index clicked");
        },
      ),
    );
  }
}
