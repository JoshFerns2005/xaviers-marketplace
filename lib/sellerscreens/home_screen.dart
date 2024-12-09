import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xaviers_market/consts/consts.dart';
import 'package:xaviers_market/prac.dart';
import 'package:xaviers_market/sellerscreens/register_stall.dart';
import 'package:xaviers_market/customerscreens/signin_screen.dart';
import 'package:xaviers_market/sellerscreens/stalls_screen.dart';
import 'package:xaviers_market/sellerscreens/transactions.dart';

class SellerHomeScreen extends StatelessWidget {
  final String userId;

  // Constructor with a required parameter 'userId'
  const SellerHomeScreen(this.userId);

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
            title: Text("Home", style: TextStyle(color: Colors.white),),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Crud())
                  );
                },
                child: Text("PRAC"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Transactions(userId)));
                },
                child: Text("Transactions", style: TextStyle(color: Colors.white))
              )
            ]
          ),
          body: GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => StallsScreen(userId))),
            child: Container(
              height: 100.0,
              width: double.infinity, // Set the height to 100
              padding: EdgeInsets.all(16.0),
              margin: EdgeInsets.only(top: 100.0, left: 10, right: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                "Your Stalls",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ),
        ));
  }
}





