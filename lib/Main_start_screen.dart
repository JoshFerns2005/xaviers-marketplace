import 'package:flutter/material.dart';
import 'package:xaviers_market/customer_or_seller.dart';

void main() {
  runApp(MainGetStarted());
}

class MainGetStarted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GetStartedPage(),
    );
  }
}

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 233, 226),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset('assets/images/welcome.png',
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.height * 0.2),
            Text(
              'Welcome to our Shopping App !!',
              style: TextStyle(
                fontSize: 28.0,
                color: const Color.fromARGB(255, 126, 70, 62),
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto', // Example of using a custom font
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Text(
              'Discover the latest trends and shop with ease!',
              style: TextStyle(
                fontSize: 18.0,
                color: const Color.fromARGB(255, 126, 70, 62),
                fontStyle: FontStyle.italic, // Example of using italic style
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SellCustomerApp()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.015,
                    horizontal: MediaQuery.of(context).size.height * 0.020),
              ),
              icon: Icon(Icons.shopping_cart,
                  color: Colors.white, size: 24.0), // Example of adding an icon
              label: Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5, // Example of adjusting letter spacing
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          ],
        ),
      ),
    );
  }
}
