import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'payment_page.dart';

class RideDetail extends StatefulWidget {
  @override
  _RideDetailState createState() => _RideDetailState();
}

class _RideDetailState extends State<RideDetail> {
  Map<String, dynamic> rideData = {}; // To store the fetched ride data
  bool isLoading = true; // State to manage loading

  @override
  void initState() {
    super.initState();
    fetchRideDetails(); // Call the fetch function on page load
  }

  // Function to fetch ride details from an API
  Future<void> fetchRideDetails() async {
    final url = Uri.parse(
        'https://example.com/api/ride/1'); // Replace with your API endpoint
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          rideData = json.decode(response.body);
          isLoading = false; // Stop loading
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Loading indicator
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date and Price
                  Text(
                    rideData['time'] != null
                        ? rideData['time'].split('T')[0] // Extract date
                        : 'Unknown Date',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total price for 1 passenger',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      Text(
                        '${rideData['price'] ?? 0} DT',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Time, Start, Destination
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Text(
                            rideData['time'] != null
                                ? rideData['time'].split('T')[1].substring(0, 5)
                                : '00:00',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Column(
                            children: [
                              CircleAvatar(
                                radius: 5,
                                backgroundColor: Colors.red,
                                child: CircleAvatar(
                                  radius: 3,
                                  backgroundColor: Colors.white,
                                ),
                              ),
                              Container(
                                width: 2,
                                height: 30,
                                color: Colors.red,
                              ),
                              CircleAvatar(
                                radius: 5,
                                backgroundColor: Colors.red,
                                child: CircleAvatar(
                                  radius: 3,
                                  backgroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text('04:00 PM', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            rideData['departure'] ?? 'Unknown Departure',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 48),
                          Text(
                            rideData['destination'] ?? 'Unknown Destination',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Seats Available
                  Row(
                    children: [
                      Icon(Icons.event_seat, size: 24, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        'Seats available: ${rideData['seats_available'] ?? 0}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),

                  // Request Ride Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PaymentPage()));
                      },
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Request for ride',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
