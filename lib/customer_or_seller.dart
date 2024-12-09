// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'Main_start_screen.dart';
import 'customerscreens/customer_get_started.dart';
import 'sellerscreens/seller_get_started.dart';

class SellCustomerApp extends StatelessWidget {
  const SellCustomerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SellOrCustomerScreen(),
    );
  }
}

class SellOrCustomerScreen extends StatelessWidget {
  const SellOrCustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 233, 226),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 242, 233, 226),
        leading: Padding(
          padding: const EdgeInsets.all(12.0), // Increased padding
          child: IconButton(
            icon: const Icon(Icons.arrow_back,
                size: 30,
                color: Color.fromARGB(255, 126, 70, 62)), // Bigger back button
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainGetStarted(),
                ),
              );
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 50), // Adjusted top padding
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Are you a',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Color.fromARGB(255, 126, 70, 62),
                ),
              ),
              const SizedBox(height: 10),
              CustomButton(
                imageAsset: 'assets/images/seller.jpg',
                buttonText: 'Seller',
                onPressed: () {
                  _navigateToSignInScreen(context, SellerGetStarted(), true);
                },
              ),
              const SizedBox(height: 10),
              const Divider(
                color: Colors.black, // Line color
                thickness: 2, // Line thickness
                indent: 40, // Left spacing
                endIndent: 40, // Right spacing
              ),
              CustomButton(
                imageAsset: 'assets/images/customer.png',
                buttonText: 'Customer',
                onPressed: () {
                  _navigateToSignInScreen(context, CustomerGetStarted(), false);
                },
              ),
              const SizedBox(height: 10), // Adjusted height              
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToSignInScreen(
      BuildContext context, Widget signInScreen, bool isSeller) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => signInScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          if (isSeller) {
            // For Seller, use SlideTransition to slide from the top
            return SlideTransition(
                position:
                    Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
                        .animate(animation),
                child: child);
          } else {
            // For Customer, use SlideTransition to slide from the bottom
            return SlideTransition(
                position:
                    Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                        .animate(animation),
                child: child);
          }
        },
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String imageAsset;
  final String buttonText;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.imageAsset,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 200,
        height: 230,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10)),
                image: DecorationImage(
                  image: AssetImage(imageAsset),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              height: 80,
              decoration: const BoxDecoration(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(10)),
                color: Color.fromARGB(255, 126, 70, 62),
              ),
              child: Center(
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
