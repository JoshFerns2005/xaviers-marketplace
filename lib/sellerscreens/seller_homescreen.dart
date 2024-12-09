// ignore_for_file: prefer_const_constructors

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xaviers_market/customerscreens/NewsScreen.dart';
import 'package:xaviers_market/sellerscreens/notification.dart';
import 'package:xaviers_market/sellerscreens/seller_settings.dart';

import 'package:xaviers_market/sellerscreens/seller_stalls_screen.dart';

class SellerHomeScreen extends StatefulWidget {
  final String userId;
  const SellerHomeScreen(this.userId);

  @override
  State<SellerHomeScreen> createState() => _SellerHomeScreenState();
}

class _SellerHomeScreenState extends State<SellerHomeScreen> {
  String? _customerName;

  @override
  void initState() {
    super.initState();
    _fetchCustomerName();
  }

  Future<void> _fetchCustomerName() async {
    var nameSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .get();
    setState(() {
      _customerName = nameSnapshot['name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 233, 226),
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: const Color.fromARGB(255, 242, 233, 226),
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Hi, ',
                    style: TextStyle(
                      fontSize: 20,
                      color: const Color.fromARGB(255, 126, 70, 62),
                      fontWeight: FontWeight.bold
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: _customerName,
                        style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 77, 43, 38),
                              fontWeight: FontWeight.w900),                       
                      ),
                    ],
                  ),
                ),
                Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: 25,
                      color: const Color.fromARGB(255, 126, 70, 62),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Spacer(),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 500),
                    pageBuilder: (_, __, ___) => NotificationScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(0.0, -1.0);
                      const end = Offset.zero;
                      var curve = Curves.easeInOut;

                      var tween = Tween(begin: begin, end: end).chain(
                        CurveTween(curve: curve),
                      );

                      var offsetAnimation = animation.drive(tween);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: Hero(
                tag: 'notificationBell',
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: const Icon(
                    Icons.notifications,
                    size: 30,
                      color: const Color.fromARGB(255, 126, 70, 62),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              iconSize: 30,
              color: Colors.blueGrey,
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const SellerSettingsScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset(0.0, 0.0);
                      var tween = Tween(begin: begin, end: end);
                      var offsetAnimation = animation.drive(tween);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 400),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StallsScreen(widget.userId))),
              child: Container(
                height: 200.0,
                width: double.infinity, // Set the height to 100
                margin: const EdgeInsets.only(top: 50.0, left: 30, right: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image(
                    image: AssetImage('assets/images/Your_stalls.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Divider(
              thickness: 2,
              indent: 5,
              endIndent: 5,
              color: Colors.grey.withOpacity(0.5),
            ),
            SizedBox(height: 20),
            Text(
              'Xavier\'s News',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 126, 70, 62),
              ),
            ),
            SizedBox(height: 20),
            CarouselSlider(
              options: CarouselOptions(
                height: 250.0,
                enableInfiniteScroll: true,
                enlargeCenterPage: true,
                autoPlay: true,
              ),
              items: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetailsScreen(
                          title: 'Tedx',
                          imagePath: 'assets/images/Tedx.jpeg',
                          content:
                              'TEDxXaviers is an annual event held at Xaviers College in Mumbai, India, showcasing a diverse range of ideas and innovations through the platform of TED Talks. The event brings together a community of passionate individuals, speakers, and attendees who share a common goal of inspiring positive change and fostering intellectual discourse. One of the defining characteristics of TEDxXaviers is its commitment to providing a platform for individuals from various backgrounds and disciplines to share their unique perspectives and experiences. From technology and science to art, culture, and social issues, TEDxXaviers covers a wide array of topics that are both thought-provoking and relevant to contemporary society. The event typically features a series of talks given by speakers who are experts in their respective fields or individuals with compelling stories to share. These talks are designed to be engaging, informative, and inspirational, aiming to spark curiosity and encourage critical thinking among the audience. Moreover, TEDxXaviers serves as a catalyst for meaningful conversations and connections. Attendees have the opportunity to interact with speakers, exchange ideas with fellow participants, and engage in discussions that transcend the boundaries of traditional academic disciplines. This collaborative environment fosters creativity, innovation, and collaboration, laying the groundwork for positive change in the world. Beyond the talks themselves, TEDxXaviers also incorporates interactive activities, performances, and workshops that enhance the overall experience for attendees. These elements add depth and richness to the event, allowing participants to immerse themselves fully in the ideas and themes being presented. In addition to its impact on the local community, TEDxXaviers also extends its reach through live streaming and social media, allowing individuals from around the world to tune in and participate virtually. This global perspective amplifies the influence of the event, enabling it to reach a broader audience and inspire change on a global scale. Overall, TEDxXaviers is more than just a series of talks; it is a platform for innovation, inspiration, and transformation. By bringing together diverse voices and ideas, TEDxXaviers empowers individuals to think critically, act boldly, and make a positive difference in the world.',
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 3,
                          blurRadius: 5,
                          color: Colors.black,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),
                    child: Image(
                      image: AssetImage('assets/images/Tedx.jpeg'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetailsScreen(
                          title: 'Malhar Gone Wild',
                          imagePath: 'assets/images/BLood_drive.jpeg',
                          content:
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua..',
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 3,
                          blurRadius: 5,
                          color: Colors.black,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),
                    child: Image(
                      image: AssetImage('assets/images/BLood_drive.jpeg'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetailsScreen(
                          title: 'Malhar Gone Wild',
                          imagePath: 'assets/images/BLood_drive.jpeg',
                          content:
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua..',
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 3,
                          blurRadius: 5,
                          color: Colors.black,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),
                    child: Image(
                      image: AssetImage('assets/images/BLood_drive.jpeg'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                // Add more carousel items as needed...
              ],
            ),
          ],
        ),
      ),
    );
  }
}
