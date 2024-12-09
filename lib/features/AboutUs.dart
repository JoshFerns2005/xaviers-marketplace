import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 233, 226),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 242, 233, 226),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'About Our Stall App',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 126, 70, 62),

              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Welcome to our stall app! We aim to revolutionize the way people buy and sell items at our college by providing a convenient and efficient platform.',
              style: TextStyle(fontSize: 18.0,
              color: Color.fromARGB(255, 126, 70, 62),
),
            ),
            SizedBox(height: 16.0),
            Text(
              'Features:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 126, 70, 62),

              ),
            ),
            SizedBox(height: 8.0),
            Text(
              '- Browse and purchase items from various stalls.',
              style: TextStyle(fontSize: 18.0,
              color: Color.fromARGB(255, 126, 70, 62),
),
            ),
            Text(
              '- Save time by avoiding long queues and waiting times.',
              style: TextStyle(fontSize: 18.0,         
               color: Color.fromARGB(255, 126, 70, 62),
),
            ),
            Text(
              '- Easily find items you are looking for at your own comfort.',
              style: TextStyle(fontSize: 18.0,          
              color: Color.fromARGB(255, 126, 70, 62),
),
            ),
            SizedBox(height: 16.0),
            Text(
              'Our Vision:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 126, 70, 62),

              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'To create a seamless and enjoyable shopping experience for students and faculty, promoting a culture of innovation and efficiency.',
              style: TextStyle(fontSize: 18.0,          
              color: Color.fromARGB(255, 126, 70, 62),

              ),
            ),
            SizedBox(height: 50.0),
            Text(
              'Thank You for utilizing our app.',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,          
              color: Color.fromARGB(255, 126, 70, 62),

              ),
              
            ),
            Center(
              child: Icon(Icons.celebration,size: 30,color: Color.fromARGB(255, 126, 70, 62),),
            )
          ],
        ),
      ),
    );
  }
}
