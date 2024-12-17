import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Login/Sign Up'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', width: 300, height: 300),
            SizedBox(height: 20),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to sign-up page
                Navigator.pushNamed(context, '/signup');
              },
              style: ElevatedButton.styleFrom(
                iconColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: Text('Sign Up'),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Navigate to log-in page
                Navigator.pushNamed(context, '/login');
              },
              child: Text('Log in'),
            ),
          ],
        ),
      ),
    );
  }
}
