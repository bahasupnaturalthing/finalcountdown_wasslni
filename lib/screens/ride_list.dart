import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RideCard extends StatelessWidget {
  final String timeStart;
  final String timeEnd;
  final String start;
  final String end;
  final String price;
  final String driver;
  final String distance;
  final int totalSeats;
  final int reservedSeats;
  final Function() onTap;

  RideCard({
    required this.timeStart,
    required this.timeEnd,
    required this.start,
    required this.end,
    required this.price,
    required this.driver,
    required this.distance,
    required this.totalSeats,
    required this.reservedSeats,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.only(bottom: 16),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    timeStart,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Spacer(),
                  Text(
                    price,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.red),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text('$start ➔ $end',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  for (int i = 1; i <= totalSeats; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Icon(
                        Icons.airline_seat_recline_normal,
                        size: 20,
                        color: i <= reservedSeats ? Colors.red : Colors.grey,
                      ),
                    ),
                ],
              ),
              Divider(height: 20, thickness: 1),
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey.shade300,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        driver,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        distance,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RideListPage extends StatefulWidget {
  final String token; // Token parameter

  RideListPage({Key? key, required this.token}) : super(key: key);

  @override
  _RideListPageState createState() => _RideListPageState();
}

class _RideListPageState extends State<RideListPage> {
  List<Map<String, dynamic>> rides = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRides();
  }

  Future<void> fetchRides() async {
    const url = 'https://wassalni-maak.onrender.com/carpool/';
    try {
      // Add the token to the headers for authentication
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          rides = data
              .map((ride) => {
                    'timeStart': ride['timeStart'] ?? 'N/A',
                    'timeEnd': ride['timeEnd'] ?? 'N/A',
                    'start': ride['start'] ?? 'N/A',
                    'end': ride['end'] ?? 'N/A',
                    'price': ride['price'] ?? 'N/A',
                    'driver': ride['driver'] ?? 'N/A',
                    'distance': ride['distance'] ?? 'N/A',
                    'totalSeats': ride['totalSeats'] ?? 0,
                    'reservedSeats': ride['reservedSeats'] ?? 0,
                  })
              .toList();
          isLoading = false;
        });
      } else {
        print('Error fetching rides: ${response.statusCode}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Error: $e');
      setState(() => isLoading = false);
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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Available Rides',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : rides.isEmpty
              ? Center(child: Text('No rides available'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: rides.length,
                  itemBuilder: (context, index) {
                    final ride = rides[index];
                    return RideCard(
                      timeStart: ride['timeStart'],
                      timeEnd: ride['timeEnd'],
                      start: ride['start'],
                      end: ride['end'],
                      price: ride['price'],
                      driver: ride['driver'],
                      distance: ride['distance'],
                      totalSeats: ride['totalSeats'],
                      reservedSeats: ride['reservedSeats'],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RideDetailPage(ride: ride),
                          ),
                        );
                      },
                    );
                  },
                ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.directions_car), label: 'Your rides'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Publish'),
          BottomNavigationBarItem(icon: Icon(Icons.inbox), label: 'Inbox'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class RideDetailPage extends StatelessWidget {
  final Map<String, dynamic> ride;

  RideDetailPage({required this.ride});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ride Details'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Start: ${ride['start']}'),
            Text('End: ${ride['end']}'),
            Text('Time: ${ride['timeStart']} - ${ride['timeEnd']}'),
            Text('Price: ${ride['price']}'),
            Text('Driver: ${ride['driver']}'),
            Text('Distance: ${ride['distance']}'),
          ],
        ),
      ),
    );
  }
}
