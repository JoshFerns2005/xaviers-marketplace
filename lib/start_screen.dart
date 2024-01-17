import 'package:flutter/material.dart';
import 'signin_screen.dart';
import 'createaccount_screen.dart';

void main() {
  runApp(StartScreen());
}

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/start_bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              color: Color.fromARGB(255, 26, 3, 59).withOpacity(0.85),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 100, 32, 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Adjusted to center the buttons vertically
                  crossAxisAlignment: CrossAxisAlignment.start, // Align the sentences to the left
                  children: [
                    SizedBox(height: 100), // Move down the sentences and buttons
                    Text(
                      'Get\nStarted!',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0), // Add left padding
                      child: Text(
                        'Join us now and start',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0), // Add left padding
                      child: Text(
                        'Your Journey',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 100),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateAccountScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0), // Square-like shape
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text('Create an Account'),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignInScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                          onPrimary: Colors.white,
                          side: BorderSide(color: Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0), // Square-like shape
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text('Sign In to Your Account'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




