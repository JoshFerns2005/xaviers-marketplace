import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xaviers_market/sellerscreens/products_screen.dart';
import 'package:xaviers_market/sellerscreens/register_stall.dart';

class StallsScreen extends StatelessWidget {
  final String userId;

  const StallsScreen(this.userId);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.purple,
        scaffoldBackgroundColor: Color.fromARGB(255, 63, 5, 73),
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromARGB(0, 255, 255, 255),
          elevation: 0,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: BackButton(color: Colors.white),
          title: Text('Home', style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterStall(userId),
                  ),
                );
              },
              child: Text(
                "Register a Stall",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Your Stalls',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              // Wrap the StreamBuilder with Expanded
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                    .collection('stalls')
                    .where('userId', isEqualTo: userId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text('No stalls available');
                  }

                  // Assuming you want to display a list of stalls
                  var stalls = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: stalls.length,
                    itemBuilder: (context, index) {
                      var stallDoc = stalls[index];
                      var stallName =
                          stallDoc['name']; // Replace 'name' with the actual field name

                      return Container(
                        color: Colors.white, // Set background color
                        child: ListTile(
                          title: Text(
                            stallName,
                            style: TextStyle(
                              color: Colors.black, // Set text color to black
                            ),
                          ),
                          onTap: () {
                            // Extract the document ID
                            var stallId = stallDoc.id;

                            // Navigate to the ProductsScreen with stall ID
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductsScreen(stallId),
                              ),
                            );
                          },
                        ),
                      );
                    },
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