import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ride_detail.dart';

// RideCard Widget
class RideCard extends StatelessWidget {
  final String timeStart;
  final String departure;
  final String destination;
  final String price;
  final String driver;
  final int totalSeats = 4;
  final int seats_available;
  final Function() onTap;

  RideCard({
    required this.timeStart,
    required this.departure,
    required this.destination,
    required this.price,
    required this.driver,
    required this.seats_available,
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
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    departure,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    destination,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
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
                        color: i <= seats_available ? Colors.red : Colors.grey,
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
                    ],
                  ),
                ],
              ),
            ]),
          ),
        ));
  }
}

// RideListPage Widget
class RideListPage extends StatefulWidget {
  final String departure;
  final String destination;
  final int? seats;
  final DateTime? date;
  final String token; // Token parameter

  RideListPage({
    required this.departure,
    required this.destination,
    this.seats,
    this.date,
    required this.token, // Token passed
  });

  @override
  _RideListPageState createState() => _RideListPageState();
}

class _RideListPageState extends State<RideListPage> {
  List<dynamic> rides = [];

  @override
  void initState() {
    super.initState();
    fetchCarpools();
    print(widget.departure);
    print(widget.destination);
    print('Token: ${widget.token}');
  }

  Future<void> fetchCarpools() async {
    final String url = 'https://wassalni-maak.onrender.com/carpool?'
        'departure=${widget.departure}&destination=${widget.destination}'
        '${widget.seats != null ? '&min_seats=${widget.seats}' : ''}';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer ${widget.token}'}, // Token header
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          rides = data['carpools'];
        });
      } else {
        throw Exception('Failed to load carpools');
      }
    } catch (e) {
      print("Error fetching rides: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load rides. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.departure} to ${widget.destination}'),
        backgroundColor: Colors.redAccent,
      ),
      body: rides.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: rides.length,
              itemBuilder: (context, index) {
                final ride = rides[index];
                return RideCard(
                  timeStart: ride['time'] ?? '',
                  departure: ride['departure'] ?? '',
                  destination: ride['destination'] ?? '',
                  price: '${ride['price'] ?? 0} DT/Person',
                  driver:
                      '${ride['owner_name'] ?? 'Unknown'}', // Adjust as needed
                  seats_available: ride['seats_available'] ?? 0,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RideDetail(
                          rideId: ride['id'],
                          token: widget.token, // Pass the token
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
