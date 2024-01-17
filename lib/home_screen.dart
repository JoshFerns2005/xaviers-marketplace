import 'package:flutter/material.dart';
import 'package:xaviers_market/chat.dart';
import 'package:xaviers_market/signin_screen.dart';

void main() {
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.purple,
        scaffoldBackgroundColor: Color.fromARGB(255, 63, 5, 73),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 25),
        automaticallyImplyLeading: false, // Remove back button
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to SignInScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignInScreen(),
                ),
              );
            },
            icon: Icon(Icons.account_circle),
            color: Colors.white,
          ),
          IconButton(
            onPressed: () {
              // Navigate to ChatScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => chat(),
                ),
              );
            },
            icon: Icon(Icons.chat),
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
