import 'package:flutter/material.dart';
import 'package:xaviers_market/sellerscreens/createaccount_screen.dart';
import 'package:xaviers_market/sellerscreens/seller_signin_screen.dart';

class SellerGetStarted extends StatelessWidget {
  const SellerGetStarted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 233, 226),
      appBar: AppBar(
        title: const Text(''),
        leading: const BackButton(color: Colors.brown),
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Container(
          color: const Color.fromARGB(255, 242, 233, 226).withOpacity(0.85),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              32,
              MediaQuery.of(context).size.height / 3.5, // Adjusted padding dynamically
              32,
              10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 SizedBox(height: MediaQuery.of(context).size.height*0.045),
                 Text(
                  'Get\nStarted!',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height*0.045,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 126, 70, 62),
                  ),
                ),
                 SizedBox(height: MediaQuery.of(context).size.height*0.004),
                 Padding(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.height*0.008),
                  child: Text(
                    'Join us now and start',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height*0.023,
                      color: Color.fromARGB(255, 126, 70, 62),
                    ),
                  ),
                ),
                 Padding(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.height*0.008),
                  child: Text(
                    'Your Journey as a Seller',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height*0.023,
                      color: Color.fromARGB(255, 126, 70, 62),
                    ),
                  ),
                ),
                 SizedBox(height: MediaQuery.of(context).size.height*0.050),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const CreateAccountSellerScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height*0.012),
                      ), backgroundColor: const Color.fromARGB(255, 126, 70, 62),
                    ),
                    child:  Padding(
                      padding: EdgeInsets.all(MediaQuery.of(context).size.height*0.016),
                      child: Text('Create a Seller Account',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
                 SizedBox(height: MediaQuery.of(context).size.height*0.016),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SellerSignInScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height*0.012),
                      ), backgroundColor: const Color.fromARGB(255, 126, 70, 62),
                    ),
                    child:  Padding(
                      padding: EdgeInsets.all(MediaQuery.of(context).size.height*0.016),
                      child: Text(
                        'Log In to Your Seller Account',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
