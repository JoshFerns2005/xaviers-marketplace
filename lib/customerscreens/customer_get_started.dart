import 'package:flutter/material.dart';
import 'package:xaviers_market/customerscreens/createaccount_screen.dart';
import 'package:xaviers_market/customerscreens/signin_screen.dart';

class CustomerGetStarted extends StatelessWidget {
  const CustomerGetStarted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 233, 226),
      appBar: AppBar(
        title: const Text(''),
        leading: const BackButton(color: Colors.brown),
        backgroundColor: const Color.fromARGB(255, 242, 233, 226),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              color: const Color.fromARGB(255, 242, 233, 226).withOpacity(0.85),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  32, MediaQuery.of(context).size.height / 3.5, 32, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  const Text(
                    'Get\nStarted!',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 126, 70, 62),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Join us now and start',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 126, 70, 62),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Your Journey as a Customer',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 126, 70, 62),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateAccountScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ), backgroundColor: const Color.fromARGB(255, 126, 70, 62),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('Create a Customer Account',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ), backgroundColor: const Color.fromARGB(255, 126, 70, 62),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Log In to Your Customer Account',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
