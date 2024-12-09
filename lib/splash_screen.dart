import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'dart:async';
import 'package:xaviers_market/Main_start_screen.dart';
import 'package:xaviers_market/customerscreens/CustomerNavbar.dart';
import 'package:xaviers_market/sellerscreens/SellerNavbar.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // Remove the debug banner
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    initUserStatus();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual);
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => MainGetStarted(),
      ));
    });
  }

  Future<void> initUserStatus() async {
    var box = await Hive.openBox('userBox');
    String? userId = box.get('userId');
    bool isSignedIn = box.get('isSignedIn', defaultValue: false);
    bool isSeller = box.get('isSeller', defaultValue: false);

    if (isSignedIn) {
      if (isSeller) {
        // Navigate to seller home screen
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual);
        Future.delayed(const Duration(seconds: 5), () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => BottomNavigation(userId!),
          ));
        });
        print('User is signed in as a seller with userId: $userId');
      } else {
        // Navigate to customer home screen
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual);
        Future.delayed(const Duration(seconds: 5), () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => customerBottomNavigation(userId!),
          ));
        });
        print('User is signed in as a customer with userId: $userId');
      }
    } else {
      print('User is not signed in');
      // Navigate to sign-in screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual);
      Future.delayed(const Duration(seconds: 5), () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => MainGetStarted(),
        ));
      });
    }
  }
  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 233, 226),
      body: Container(
        width: double.infinity,
        color: const Color.fromARGB(255, 242, 233, 226)
            .withOpacity(0.85), // Light Brown Color
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.3, // Adjust the height of the image
              child: Image.asset(
                'assets/images/XLogo.png', // Replace with your image path
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height *
                    0.01), // Adjust the spacing between the image and text
            const Text(
              "StallMart",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: const Color.fromARGB(255, 126, 70, 62),
                fontSize: 30,
                fontWeight: FontWeight.bold, // Adjust the font size
              ),
            ),
          ],
        ),
      ),
    );
  }
}
