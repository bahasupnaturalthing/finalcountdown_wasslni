import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'chat.dart';
import 'ride_booked.dart';

class RideDetail extends StatefulWidget {
  final int rideId;
  final String token; // Added token parameter

  RideDetail({required this.rideId, required this.token});

  @override
  _RideDetailPageState createState() => _RideDetailPageState();
}

class _RideDetailPageState extends State<RideDetail> {
  late Map<String, dynamic> ride = {};
  late Map<String, dynamic> driver = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRideDetails();
  }

  // Fetch ride details
  Future<void> fetchRideDetails() async {
    print('Fetching ride details for rideId: ${widget.rideId}');
    final url = "https://wassalni-maak.onrender.com/carpool/${widget.rideId}";
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer ${widget.token}'}, // Add token here
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          ride = data;
          isLoading = false;
        });

        // Fetch driver details
        fetchDriverDetails(ride['owner_id']);
      } else {
        print("Failed to load ride details");
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error fetching ride details: $e");
      setState(() => isLoading = false);
    }
  }

  // Fetch driver details
  Future<void> fetchDriverDetails(driverId) async {
    print('Fetching driver details for driverId: $driverId');
    final url = "https://wassalni-maak.onrender.com/user/${driverId}";
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer ${widget.token}'}, // Add token here
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          driver = data;
        });
      } else {
        print("Failed to load driver details");
      }
    } catch (e) {
      print("Error fetching driver details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.redAccent),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Ride Details',
          style:
              TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Ride Time
            Text(
              formatDate(ride['time'] ?? ""),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),

            // Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total price for 1 passenger',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                ),
                Text(
                  '${ride['price'] ?? 0} DT',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Driver Section
            Card(
              margin: EdgeInsets.all(16),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                      'https://example.com/profile_picture.jpg'), // Example placeholder
                ),
                title: Text(
                  '${driver['firstName']} ${driver['lastName']}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${driver['rating'] ?? 0}/5 ratings',
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
              ),
            ),
            Spacer(),
            // Chat Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatServicePage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
              ),
              child: Text(
                'Contact Driver',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            // Book Ride Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RideConfirmationPage(
                      token: widget.token, // Pass token to confirmation page
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
              ),
              child: Text(
                'Book Ride',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatDate(String dateString) {
    if (dateString.isEmpty) return "Loading...";
    DateTime dateTime = DateTime.parse(dateString);
    return DateFormat('EEE d MMM').format(dateTime);
  }
}

String getTime(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  return DateFormat('hh:mm a').format(dateTime);
}
