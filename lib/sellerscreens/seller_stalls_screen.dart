import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xaviers_market/sellerscreens/SellerNavbar.dart';
import 'package:xaviers_market/sellerscreens/register_stall.dart';
import 'package:xaviers_market/sellerscreens/seller_product_screen.dart';

class StallsScreen extends StatelessWidget {
  final String userId;

  const StallsScreen(this.userId);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.purple,
        scaffoldBackgroundColor: const Color.fromARGB(255, 63, 5, 73),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(0, 255, 255, 255),
          elevation: 0,
        ),
      ),
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 242, 233, 226),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 242, 233, 226),
          leading: BackButton(
            color: const Color.fromARGB(255, 126, 70, 62),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BottomNavigation(userId)));
            },
          ),
          title: null,
          actions: [],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Your Stalls',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 126, 70, 62),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('stalls')
                    .where('userId', isEqualTo: userId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: const CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        children: [
                          const Text('No stalls available',
                          style: TextStyle(
                          color: const Color.fromARGB(255, 126, 70, 62),
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                          ),),
                          SizedBox(height: 20,),
                          ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterStall(userId),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.brown, // Change text color here
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 16),
                            // Adjust button size here
                          ),
                          child: const Text(
                            'Register a Stall',
                            style: TextStyle(
                              fontSize: 18, // Change text size here
                            ),
                          ),
                        ),
                        ],
                      ),
                    );
                  }
                  var stalls = snapshot.data!.docs;

                  return Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: stalls.length,
                        itemBuilder: (context, index) {
                          var stallDoc = stalls[index];
                          var stallName = stallDoc['name'];
                          return Column(
                            children: [
                              ListTile(
                                tileColor: Color.fromARGB(255, 223, 206, 193),
                                title: Text(
                                  stallName,
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 91, 62, 51),
                                    fontSize: 20, fontWeight: FontWeight.bold
                                  ),
                                ),
                                onTap: () {
                                  var stallId = stallDoc.id;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SellerProductsScreen(userId, stallId),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 10,)
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterStall(userId),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.brown, // Change text color here
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 16),
                            // Adjust button size here
                          ),
                          child: const Text(
                            'Register a Stall',
                            style: TextStyle(
                              fontSize: 18, // Change text size here
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
