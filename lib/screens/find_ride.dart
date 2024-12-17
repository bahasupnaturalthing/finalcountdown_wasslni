import 'package:flutter/material.dart';

class FindRidePage extends StatefulWidget {
  const FindRidePage({super.key});

  @override
  State<FindRidePage> createState() => _FindRidePageState();
}

class _FindRidePageState extends State<FindRidePage> {
  // Variables to store the selected date
  DateTime? selectedDate;

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
          'Find a ride',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Starting Location
            Row(
              children: const [
                Icon(Icons.location_on_outlined, color: Colors.black),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter your starting location',
                      border: UnderlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Destination Location
            Row(
              children: const [
                Icon(Icons.location_on, color: Colors.black),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter your destination',
                      border: UnderlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Date Picker
            GestureDetector(
              onTap: _pickDate,
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined,
                      color: Colors.black),
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
            const Divider(height: 40, color: Colors.grey),

            // Number of Seats Needed
            ListTile(
              leading: const Icon(Icons.people_outline, color: Colors.black),
              title: const Text('Number of seats needed'),
              trailing: DropdownButton<int>(
                items: List.generate(
                  5,
                  (index) => DropdownMenuItem(
                    value: index + 1,
                    child: Text('${index + 1}'),
                  ),
                ),
                onChanged: (value) {
                  // Handle dropdown change
                },
                hint: const Text('Select'),
              ),
            ),

            const Divider(height: 20, color: Colors.grey),

            // Budget per Seat
            ListTile(
              leading:
                  const Icon(Icons.attach_money_outlined, color: Colors.black),
              title: const Text('Maximum budget per seat'),
              trailing: SizedBox(
                width: 80,
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: '0.00',
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Search Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Add navigation or functionality
                  Navigator.pushNamed(context, '/rideList');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 120, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Find a ride',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        currentIndex: 1, // Highlight the "Find a ride" tab
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Your rides',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Find a ride',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Offer a ride',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inbox_outlined),
            label: 'Inbox',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
