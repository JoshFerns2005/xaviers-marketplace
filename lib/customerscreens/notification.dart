// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 242, 233, 226),
      appBar: AppBar(
        leading: BackButton(
          color: Color.fromARGB(255, 126, 70, 62),
        ),
        backgroundColor: Color.fromARGB(255, 242, 233, 226),
        title: Text(
          'Notifications',
          style: TextStyle(
color: Color.fromARGB(255, 126, 70, 62),              fontSize: 25),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications,
              size: 100,
color: Color.fromARGB(255, 126, 70, 62)),
            
            SizedBox(height: 20),
            Text(
              'You have no notifications yet',
              style: TextStyle(
                  fontSize: 18, color: Color.fromARGB(255, 126, 70, 62)),
            ),
          ],
        ),
      ),
    );
  }
}
