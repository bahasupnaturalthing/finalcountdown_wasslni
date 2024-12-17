import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON encoding and decoding

class OfferRidePage extends StatefulWidget {
  const OfferRidePage({super.key});

  @override
  State<OfferRidePage> createState() => _OfferRidePageState();
}

class _OfferRidePageState extends State<OfferRidePage> {
  // Variables to store the selected date and time
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  // Variables to store user inputs
  final TextEditingController departureController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  int? selectedPassengers;

  // Method to pick a date
  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  // Method to pick a time
  Future<void> _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  // Method to send POST request
  Future<void> _offerRide() async {
    // Validate inputs
    if (departureController.text.isEmpty ||
        destinationController.text.isEmpty ||
        selectedDate == null ||
        selectedTime == null ||
        selectedPassengers == null ||
        priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all the fields.')),
      );
      return;
    }

    // Combine date and time into a single DateTime object
    final dateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    // Prepare request data
    Map<String, dynamic> requestData = {
      "departure_id": departureController.text,
      "time": dateTime.toIso8601String(),
      "destination_id": destinationController.text,
      "addresses": {},
      "available_seats": selectedPassengers,
      "options": [0], // Example options, update as needed
      "price": double.tryParse(priceController.text) ?? 0,
      "driver": 0 // Update with the driver ID if applicable
    };

    final url = Uri.parse(
        'https://wassalni-maak.onrender.com//carpool/'); // Update the URL

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ride offered successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to offer ride: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Offer a ride',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location input fields
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.redAccent),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: departureController,
                    decoration: const InputDecoration(
                      hintText: 'Departure (e.g., Bizerte)',
                      border: UnderlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.redAccent),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: destinationController,
                    decoration: const InputDecoration(
                      hintText: 'Destination (e.g., Sfax)',
                      border: UnderlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Date and Time section
            Row(
              children: [
                // Date Picker
                Expanded(
                  child: GestureDetector(
                    onTap: _pickDate,
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          selectedDate != null
                              ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                              : 'Select Date',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                // Time Picker
                GestureDetector(
                  onTap: _pickTime,
                  child: Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        selectedTime != null
                            ? selectedTime!.format(context)
                            : 'Select Time',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 40, color: Colors.grey),

            // Number of Passengers
            ListTile(
              leading: const Icon(Icons.people, color: Colors.grey),
              title: const Text('Number Of passengers'),
              trailing: DropdownButton<int>(
                items: List.generate(
                  5,
                  (index) => DropdownMenuItem(
                    value: index + 1,
                    child: Text('${index + 1}'),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    selectedPassengers = value;
                  });
                },
                value: selectedPassengers,
                hint: const Text('Select'),
              ),
            ),

            // Price Per Seat
            const Divider(height: 20, color: Colors.grey),
            ListTile(
              leading: const Icon(Icons.attach_money, color: Colors.grey),
              title: const Text('Price per seat'),
              trailing: SizedBox(
                width: 80,
                child: TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: '0.00',
                  ),
                ),
              ),
            ),
            // Offer a Ride Button
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await _offerRide(); // Execute your API request when the button is pressed
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 120, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Offer a ride',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        currentIndex: 2, // Highlight the "Publish" tab
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Your rides',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, color: Colors.redAccent),
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
      ),
    );
  }
}
