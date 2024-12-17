import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FeedbackPage(),
    );
  }
}

class FeedbackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text('Feedback of your ride'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
         // Profile Section
Container(
  width: double.infinity, // Ajout pour étendre la largeur
  color: Colors.redAccent,
  padding: EdgeInsets.symmetric(vertical: 20), // Optionnel : pour plus d'espace
  child: Column(
    children: [
      CircleAvatar(
        radius: 40,
        backgroundImage: AssetImage('assets/ayoub.png'),
        backgroundColor: Colors.redAccent,
      ),
      SizedBox(height: 10),
      Text(
        'Ayoub Ben Omrane',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),
),

          SizedBox(height: 20),
          // Rating Section
          Text(
            'Rate your ride',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) => Icon(
                Icons.star_border,
                size: 40,
                color: Colors.grey,
              ),
            ),
          ),
          SizedBox(height: 20),
          // Suggestions Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Submit your suggestions or complaints',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          // Would you ride again Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Would you love to ride with the same person again?',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black,
                      ),
                      child: Text('Definitely'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black,
                      ),
                      child: Text('May be'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black,
                      ),
                      child: Text('Never'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          // Submit Button
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              'Submit',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
